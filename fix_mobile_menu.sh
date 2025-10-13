#!/bin/bash

echo "📱 ИСПРАВЛЯЕМ МОБИЛЬНОЕ МЕНЮ..."

# --- Переменные ---
PROJECT_DIR="/var/www/kod-bezopasnosti"
USER="www-data"

echo "--- [ШАГ 1/6] ОСТАНОВКА СЛУЖБ ---"
supervisorctl stop kodbezopasnosti

echo "--- [ШАГ 2/6] ПЕРЕХОД В ПАПКУ ПРОЕКТА ---"
cd $PROJECT_DIR

echo "--- [ШАГ 3/6] АКТИВАЦИЯ ВИРТУАЛЬНОГО ОКРУЖЕНИЯ ---"
source venv/bin/activate

echo "--- [ШАГ 4/6] ОБНОВЛЕНИЕ КОДА ИЗ GITHUB ---"
git pull origin main

echo "--- [ШАГ 5/6] СОБИРАЕМ СТАТИЧЕСКИЕ ФАЙЛЫ ---"
python manage.py collectstatic --noinput

echo "--- [ШАГ 6/6] ЗАПУСКАЕМ СЛУЖБЫ ---"
supervisorctl start kodbezopasnosti

echo "========================================================"
echo "✅ МОБИЛЬНОЕ МЕНЮ ИСПРАВЛЕНО!"
echo ""
echo "Что исправлено:"
echo "1. ✅ Номер телефона и кнопка теперь в колонку"
echo "2. ✅ Кнопка растягивается на всю ширину"
echo "3. ✅ Обновлен CSS до версии 2.8"
echo ""
echo "Проверь на мобильном: 📱 http://91.229.8.148/"
echo "========================================================"
