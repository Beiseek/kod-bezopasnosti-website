#!/bin/bash

echo "📱 ПРОСТОЕ ИСПРАВЛЕНИЕ - ОБЕРНУЛИ НОМЕР В DIV!"

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
echo "✅ НОМЕР ОБЕРНУТ В DIV С ЦЕНТРИРОВАНИЕМ!"
echo ""
echo "Что сделано:"
echo "1. ✅ Номер обернут в .phone-wrapper"
echo "2. ✅ Кнопка обернута в .button-wrapper"
echo "3. ✅ Простое text-align: center"
echo "4. ✅ Обновлен CSS до версии 3.2"
echo ""
echo "Проверь на мобильном: 📱 http://91.229.8.148/"
echo "========================================================"
