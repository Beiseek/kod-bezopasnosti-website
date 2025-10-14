#!/bin/bash

echo "🚀 ОБНОВЛЕНИЕ МАКЕТА ХЕДЕРА (1450px)!"

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
echo "✅ Макет хедера обновлен!"
echo "На экранах от 992px до 1450px телефон будет на новой строке."
echo "CSS обновлен до версии 4.1."
echo ""
echo "Проверяй: 🌐 http://91.229.8.148/"
echo "========================================================"
