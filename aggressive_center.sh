#!/bin/bash

echo "🔥 АГРЕССИВНОЕ ПЕРЕОПРЕДЕЛЕНИЕ BOOTSTRAP!"

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
echo "🔥 АГРЕССИВНОЕ ПЕРЕОПРЕДЕЛЕНИЕ ПРИМЕНЕНО!"
echo ""
echo "Что сделано:"
echo "1. ✅ Добавлен z-index: 999 для приоритета"
echo "2. ✅ Агрессивное переопределение Bootstrap классов"
echo "3. ✅ Дополнительные !important правила"
echo "4. ✅ Обновлен CSS до версии 3.6"
echo ""
echo "Проверь на мобильном: 📱 http://91.229.8.148/"
echo "Теперь Bootstrap точно не перебьет наши стили!"
echo "========================================================"
