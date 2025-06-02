# 📊 Channel-Status

Автоматичний моніторинг кількості підписників у Telegram-каналі з регулярним оновленням файлу `subscribers.txt` та автокомітом у GitHub-репозиторій.

---

## ⚙️ Що робить цей проєкт

- Отримує кількість підписників у Telegram-каналі через Telegram Bot API
- Записує її у `subscribers.txt` у форматі:
  ```
  📅 2025-06-02 16:05:00
  👥 Підписників: 1234
  ```
- Комітить і пушить зміни в репозиторій
- Автоматично повторює це кожні 5 хвилин за допомогою `cron`

---

## 🧱 Структура проєкту

```
Channel-Status/
├── channel_status.py        # основний скрипт
├── subscribers.txt          # сюди зберігається кількість підписників
├── README.md                
```

---

## 🧰 Встановлення та налаштування

### 1. Встанови залежності

```bash
sudo apt update
sudo apt install python3-pip git -y
pip install aiogram
```

### 2. Клонуй репозиторій або розпакуй ZIP

```bash
git clone git@github.com:ArcanaVista/Channel-Status.git
cd Channel-Status
```

> Якщо використовуєш HTTPS:  
> `git clone https://github.com/ArcanaVista/Channel-Status.git`

### 3. Вкажи токен та канал

Відкрий `channel_status.py` та заміни:

```python
API_TOKEN = "ТВІЙ_ТОКЕН_БОТА"
CHANNEL = "@твій_канал"  # або ID: -1001234567890
```

> Бот має бути доданий до каналу та мати права адміністратора.

### 4. Налаштуй git

```bash
git config --global user.name "Твоє Ім’я"
git config --global user.email "твоя@пошта.com"
```

---

## 🚀 Запуск вручну

```bash
python3 channel_status.py
```

Перевір, що файл `subscribers.txt` створився, і у GitHub з’явився коміт.

---

## 🔁 Автоматизація через `crontab`

Відкрий планувальник:

```bash
crontab -e
```

Додай рядок:

```bash
*/5 * * * * /usr/bin/python3 /шлях/до/channel_status.py >> /шлях/до/log.txt 2>&1
```

> Скрипт виконуватиметься кожні 5 хвилин, а лог зберігатиметься в `log.txt`.

---

## 📡 Додатково (опційно)

Якщо хочеш використовувати GitHub Actions замість cron, потрібно буде використати секрети (`GH_TOKEN`) для безпечного пушу.

---

## 🛡 Безпека

- Не публікуй токен Telegram-бота!
- Рекомендується налаштувати SSH-доступ до GitHub
- Ніколи не комміть `.env` з токенами (якщо будеш використовувати)

---

## 🧠 Автор

Створено в рамках проєкту [Telegram-Lab](https://github.com/ArcanaVista/Telegram-Lab) для експериментів з Telegram API.

---

## 📜 Ліцензія

MIT
