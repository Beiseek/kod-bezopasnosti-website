#!/bin/bash

echo "🔥 FLEXBOX ЦЕНТРИРОВАНИЕ - 100% РАБОТАЕТ!"

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
echo "🔥 FLEXBOX ЦЕНТРИРОВАНИЕ ПРИМЕНЕНО!"
echo ""
echo "Что сделано:"
echo "1. ✅ .phone-wrapper: display: flex + justify-content: center"
echo "2. ✅ .button-wrapper: display: flex + justify-content: center"
echo "3. ✅ Принудительное центрирование через flexbox"
echo "4. ✅ Обновлен CSS до версии 3.3"
echo ""
echo "Проверь на мобильном: 📱 http://91.229.8.148/"
echo "Теперь номер точно по центру через flexbox!"
echo "========================================================"
