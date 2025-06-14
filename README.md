<!--
  Title: Channel-Status Telegram Subscriber Monitor
  Description: Автоматичний моніторинг кількості підписників Telegram-каналу з відображенням статусу у вигляді тексту та графіки у GitHub-репозиторії. Автоматичне оновлення, зручна інтеграція для ботів, проєктів та аналітики.
  Keywords: telegram, телеграм, підписники, моніторинг, subscribers, channel, канал, status, github, auto, автоматизація, скрипт, bash, python, bot, бот, аналітика, банер, графіка, кількість, віджет, automation, image, pillow, aiogram, bash, cron, open source, telegram bot, python script
-->

<p align="center">
  <img src="https://raw.githubusercontent.com/ArcanaVista/Channel-Status/main/result/ChannelStatus_status.png" alt="AV Banner" width="100%" />
</p>






# Channel-Status

> **Автоматичний моніторинг підписників Telegram-каналу із вивантаженням статусу у вигляді тексту та графіки у GitHub-репозиторій**

---

## ⚡ Опис

Цей проект автоматично:
- отримує кількість підписників у Telegram-каналі,
- записує це число у текстовий файл,
- генерує красиве зображення з датою та кількістю підписників (на фоні вашого банера),
- пушить все це у GitHub-репозиторій.

Автоматизація відбувається через cron кожні 10 хвилин (або зручний вам інтервал).

---

## 📦 Структура

```
Channel-Status/
├── bash.sh                     # Основний Bash-скрипт для повної автоматизації
├── background/
│   └── Group 3.png             # Ваш фоновий банер
├── fonts/
│   └── DejaVuSans-Bold.ttf     # Шрифт для генерації картинок
├── venv/                       # Віртуальне оточення Python (не додається у git)
├── subscribers.txt             # Автоматично оновлюваний файл із кількістю підписників
├── status.png                  # Картинка з датою та кількістю підписників
└── README.md                   # Опис цього проекту
```

---

## 🚀 Автоматизація

Весь процес організовано у `bash.sh`:

- Створює Python-віртуальне оточення, якщо воно відсутнє.
- Встановлює залежності (`aiogram`, `pillow`).
- Клонує репозиторій у тимчасову директорію.
- Копіює фон та шрифт.
- Через Telegram Bot API отримує число підписників.
- Записує дату та кількість у `subscribers.txt`.
- Генерує картинку `status.png`.
- Пушить зміни в GitHub.

---

## ⏰ Cron (запуск кожні 5 хвилин)

Щоб запускати скрипт автоматично, додайте у cron:

```cron
*/5 * * * * /bin/bash /home/user/Channel-Status/bash.sh >> /home/user/Channel-Status/bash.log 2>&1
```

---

## ⚙️ Як розгорнути

1. **Клонуйте репозиторій**
2. **Додайте свої токени та налаштуйте конфіг (змінні у `bash.sh`)**
3. **Переконайтесь, що у вас є SSH-ключ на GitHub і він доданий до вашого облікового запису**
4. **Запустіть вручну або додайте cron-правило**
5. **Файли `subscribers.txt` та `status.png` автоматично будуть оновлюватись у репозиторії**

---

## 📝 Приклад результату

- `subscribers.txt`:
  ```
  📅 2025-06-02 18:30:12
  👥 Підписників: 2135
  ```
- `ChannelStatus_status.png`:  
  ![Статус](result/ChannelStatus_status.png)

- `TelegramLab_status.png`:  
  ![Статус](result/TelegramLab_status.png)


---

## 💬 Зворотний зв’язок та ідеї

Пишіть ідеї, фідбек, баги — або відкривайте pull requests!

---

## 📚 Корисні посилання

- [Arcana Vista – Telegram-канал](https://t.me/+OU1lpTQbSpA3OTdi)
- [Офіційний FAQ Telegram](https://telegram.org/faq)
- [GitHub Topics](https://github.com/topics/telegram)

---

## 📝 Ліцензія

Матеріал доступний для вільного використання та адаптації з посиланням на [Arcana Vista](https://t.me/+OU1lpTQbSpA3OTdi)

> Автор: [Arcana Vista](https://t.me/+OU1lpTQbSpA3OTdi) 

---


> 🔄 Оновлюється регулярно. Пропозиції, фідбек або PR — вітаються!
