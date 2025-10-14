#!/bin/bash

echo "🚀 ИСПРАВЛЕНИЕ МАКЕТА ХЕДЕРА (CSS Grid)!"

# --- Переменные ---
PROJECT_DIR="/var/www/kod-bezopasnosti"

echo "--- [ШАГ 1/5] ОСТАНОВКА СЛУЖБ ---"
supervisorctl stop kodbezopasnosti

echo "--- [ШАГ 2/5] ПЕРЕХОД В ПАПКУ ПРОЕКТА ---"
cd $PROJECT_DIR

echo "--- [ШАГ 3/5] ОБНОВЛЕНИЕ КОДА ИЗ GITHUB ---"
git pull origin main

echo "--- [ШАГ 4/5] СБОРКА СТАТИКИ ---"
source venv/bin/activate
python manage.py collectstatic --noinput

echo "--- [ШАГ 5/5] ЗАПУСКАЕМ СЛУЖБЫ ---"
supervisorctl start kodbezopasnosti

echo "========================================================"
echo "✅ Макет хедера исправлен с помощью CSS Grid!"
echo "CSS обновлен до версии 4.2."
echo ""
echo "Проверяй снова: 🌐 http://91.229.8.148/"
echo "========================================================"
