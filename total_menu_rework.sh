#!/bin/bash

echo "💣 ТОТАЛЬНАЯ ПЕРЕДЕЛКА МОБИЛЬНОГО МЕНЮ!"

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
echo "✅ МОБИЛЬНОЕ МЕНЮ ПОЛНОСТЬЮ ПЕРЕДЕЛАНО!"
echo ""
echo "Что сделано:"
echo "1. ✅ HTML структура упрощена до предела."
echo "2. ✅ Весь старый, мусорный CSS для мобильного меню УДАЛЕН."
echo "3. ✅ Написан один чистый и правильный блок CSS."
echo "4. ✅ Обновлен CSS до версии 4.0."
echo ""
echo "Проверь на мобильном: 📱 http://91.22M8/"
echo "Теперь все должно работать как часы."
echo "========================================================"
