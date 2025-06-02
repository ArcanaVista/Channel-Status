#!/bin/bash


TELEGRAM_BOT_TOKEN="TELEGRAM_BOT_TOKEN" 
CHANNEL_ID="CHANNEL_ID"
GITHUB_USERNAME="GITHUB_USERNAME"
GITHUB_REPO="GITHUB_REPO"
GIT_EMAIL="GIT_EMAIL"
FILE_NAME="subscribers.txt"
IMAGE_NAME="status.png"
REPO_DIR="/tmp/$GITHUB_REPO"
PROJECT_DIR="/home/user/Channel-Status"
VENV_PATH="$PROJECT_DIR/venv"
FONT_PATH="$PROJECT_DIR/fonts/DejaVuSans-Bold.ttf"
BG_PATH="$PROJECT_DIR/background/Group_3.png"


if [ ! -d "$VENV_PATH" ]; then
    echo "[~] Creating virtual environment..."
    python3 -m venv "$VENV_PATH"
fi


source "$VENV_PATH/bin/activate"


for package in aiogram pillow; do
    if ! pip show $package >/dev/null 2>&1; then
        echo "[~] Installing $package..."
        pip install $package
    fi
done


rm -rf "$REPO_DIR"
git clone "git@github.com:$GITHUB_USERNAME/$GITHUB_REPO.git" "$REPO_DIR"

cd "$REPO_DIR" || exit 1
git config user.name "$GITHUB_USERNAME"
git config user.email "$GIT_EMAIL"


mkdir -p "$REPO_DIR/background"
mkdir -p "$REPO_DIR/fonts"
cp "$BG_PATH" "$REPO_DIR/background/Group 3.png"
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

# Загрузка исходного фона
bg_path = "background/Group 3.png"
font_path = "fonts/DejaVuSans-Bold.ttf"

background = Image.open(bg_path).convert("RGBA")
width, height = background.size

# Подготовка текста
timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
line1 = f"{timestamp}"
line2 = f"Підписників: $SUBSCRIBERS"

# Настройки текста
text_color = (255, 255, 255, 255)
font1 = ImageFont.truetype(font_path, 48)
font2 = ImageFont.truetype(font_path, 48)

draw = ImageDraw.Draw(background)

# Координаты левого верхнего угла
padding_x = 50
padding_y = 40

# Отрисовка текста
draw.text((padding_x, padding_y), line1, font=font1, fill=text_color)
draw.text((padding_x, padding_y + 60), line2, font=font2, fill=text_color)

# Сохраняем
background.save("$IMAGE_NAME")
END


git add "$FILE_NAME" "$IMAGE_NAME"
git commit -m "update subs: $SUBSCRIBERS"
git push origin main