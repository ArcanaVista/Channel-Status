#!/bin/bash

TELEGRAM_BOT_TOKEN="TELEGRAM_BOT_TOKEN"
CHANNEL_ID="CHANNEL_ID"
GITHUB_USERNAME="GITHUB_USERNAME"
GITHUB_REPO="Channel-Status"
GIT_EMAIL="GIT_EMAIL"
FILE_NAME="subscribers.txt"
IMAGE1_NAME="result/TelegramLab_status.png"
IMAGE2_NAME="result/ChannelStatus_status.png"
REPO_DIR="/tmp/$GITHUB_REPO"
PROJECT_DIR="/home/user/Channel-Status"
VENV_PATH="$PROJECT_DIR/venv"
FONT_PATH="$PROJECT_DIR/fonts/DejaVuSans-Bold.ttf"
BG1_PATH="$PROJECT_DIR/background/TelegramLab.png"
BG2_PATH="$PROJECT_DIR/background/ChannelStatus.png"

export TZ="Europe/Kyiv"

if [ -d "$REPO_DIR" ]; then
    echo "[~] Removing old repo (need sudo)..."
    sudo rm -rf "$REPO_DIR"
fi

if [ ! -d "$VENV_PATH" ]; then
    echo "[~] Creating virtual environment..."
    python3 -m venv "$VENV_PATH"
fi

source "$VENV_PATH/bin/activate"

for package in aiogram pillow pytz; do
    if ! pip show $package >/dev/null 2>&1; then
        echo "[~] Installing $package..."
        pip install $package
    fi
done

git clone "git@github.com:$GITHUB_USERNAME/$GITHUB_REPO.git" "$REPO_DIR"

cd "$REPO_DIR" || exit 1
git config user.name "$GITHUB_USERNAME"
git config user.email "$GIT_EMAIL"

mkdir -p "$REPO_DIR/background"
mkdir -p "$REPO_DIR/fonts"
mkdir -p "$REPO_DIR/result"
cp "$BG1_PATH" "$REPO_DIR/background/TelegramLab.png"
cp "$BG2_PATH" "$REPO_DIR/background/ChannelStatus.png"
cp "$FONT_PATH" "$REPO_DIR/fonts/DejaVuSans-Bold.ttf"

SUBSCRIBERS=$(python3 - <<END
import asyncio
from aiogram import Bot

async def main():
    bot = Bot(token="$TELEGRAM_BOT_TOKEN")
    count = await bot.get_chat_member_count(chat_id=$CHANNEL_ID)
    print(count)
    await bot.session.close()

asyncio.run(main())
END
)

DATE=$(date '+📅 %Y-%m-%d %H:%M:%S')
echo -e "$DATE\n👥 Підписників: $SUBSCRIBERS" > "$FILE_NAME"

python3 - <<END
from PIL import Image, ImageDraw, ImageFont
import datetime
import pytz
import os

def make_status(bg_path, out_path, font_path, subs):
    kyiv = pytz.timezone('Europe/Kyiv')
    timestamp = datetime.datetime.now(kyiv).strftime("%Y-%m-%d %H:%M:%S")
    line1 = f"{timestamp}"
    line2 = f"Підписників: {subs}"
    text_color = (255, 255, 255, 255)
    font1 = ImageFont.truetype(font_path, 48)
    font2 = ImageFont.truetype(font_path, 48)
    background = Image.open(bg_path).convert("RGBA")
    draw = ImageDraw.Draw(background)
    padding_x = 50
    padding_y = 40
    draw.text((padding_x, padding_y), line1, font=font1, fill=text_color)
    draw.text((padding_x, padding_y + 60), line2, font=font2, fill=text_color)
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    background.save(out_path)

make_status("background/TelegramLab.png", "result/TelegramLab_status.png", "fonts/DejaVuSans-Bold.ttf", $SUBSCRIBERS)
make_status("background/ChannelStatus.png", "result/ChannelStatus_status.png", "fonts/DejaVuSans-Bold.ttf", $SUBSCRIBERS)
END

git pull --rebase origin main

git add "$FILE_NAME" "$IMAGE1_NAME" "$IMAGE2_NAME"
git commit -m "update subs: $SUBSCRIBERS"
git push origin main

