import asyncio
from aiogram import Bot
from datetime import datetime
import subprocess

API_TOKEN = "YOUR_BOT_TOKEN"  # замените на ваш токен
CHANNEL = "@your_channel"      # замените на юзернейм или chat_id
FILE_PATH = "subscribers.txt"

bot = Bot(token=API_TOKEN)

async def get_subscriber_count():
    count = await bot.get_chat_member_count(chat_id=CHANNEL)
    return count

async def main():
    count = await get_subscriber_count()
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    with open(FILE_PATH, "w") as f:
        f.write(f"📅 {now}\n👥 Подписчиков: {count}\n")

    # Git commit and push
    subprocess.run(["git", "add", FILE_PATH])
    subprocess.run(["git", "commit", "-m", f"update subs: {count}"])
    subprocess.run(["git", "push"])

if __name__ == "__main__":
    asyncio.run(main())
