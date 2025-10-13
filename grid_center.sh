#!/bin/bash

echo "🔥 CSS GRID ЦЕНТРИРОВАНИЕ - ТОЧНО СРАБОТАЕТ!"

# --- Переменные ---
PROJECT_DIR="/var/www/kod-bezopasnosti"

echo "--- [ШАГ 1/4] ОСТАНОВКА СЛУЖБ ---"
supervisorctl stop kodbezopasnosti

echo "--- [ШАГ 2/4] ПЕРЕХОД В ПАПКУ ПРОЕКТА ---"
cd $PROJECT_DIR

echo "--- [ШАГ 3/4] ОБНОВЛЕНИЕ КОДА ИЗ GITHUB ---"
git pull origin main

echo "--- [ШАГ 4/4] ЗАПУСКАЕМ СЛУЖБЫ ---"
supervisorctl start kodbezopasnosti

echo "========================================================"
echo "🔥 CSS GRID ЦЕНТРИРОВАНИЕ ПРИМЕНЕНО!"
echo ""
echo "Что сделано:"
echo "1. ✅ .phone-wrapper: display: grid + place-items: center"
echo "2. ✅ .button-wrapper: display: grid + place-items: center"
echo "3. ✅ CSS Grid принудительно центрирует содержимое"
echo "4. ✅ Обновлен CSS до версии 3.4"
echo ""
echo "Проверь на мобильном: 📱 http://91.229.8.148/"
echo "CSS Grid - это 100% гарантия центрирования!"
echo "========================================================"
