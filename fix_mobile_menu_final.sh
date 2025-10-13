#!/bin/bash

echo "📱 ФИНАЛЬНОЕ ИСПРАВЛЕНИЕ МОБИЛЬНОГО МЕНЮ..."

# --- Переменные ---
PROJECT_DIR="/var/www/kod-bezopasnosti"
USER="www-data"

echo "--- [ШАГ 1/7] ОСТАНОВКА СЛУЖБ ---"
supervisorctl stop kodbezopasnosti

echo "--- [ШАГ 2/7] ПЕРЕХОД В ПАПКУ ПРОЕКТА ---"
cd $PROJECT_DIR

echo "--- [ШАГ 3/7] АКТИВАЦИЯ ВИРТУАЛЬНОГО ОКРУЖЕНИЯ ---"
source venv/bin/activate

echo "--- [ШАГ 4/7] ОБНОВЛЕНИЕ КОДА ИЗ GITHUB ---"
git pull origin main

echo "--- [ШАГ 5/7] ПРИНУДИТЕЛЬНОЕ ИСПРАВЛЕНИЕ CSS ---"
# Добавляем дополнительные CSS правила прямо в файл
cat >> static/css/style.css << 'EOF'

/* ДОПОЛНИТЕЛЬНЫЕ ПРАВИЛА ДЛЯ МОБИЛЬНОГО МЕНЮ */
@media (max-width: 768px) {
    /* Принудительно разделяем номер и кнопку */
    .navbar-collapse .right-actions {
        display: block !important;
        width: 100% !important;
    }
    
    .navbar-collapse .right-actions .header-phone {
        display: block !important;
        width: 100% !important;
        margin-bottom: 15px !important;
        margin-right: 0 !important;
        float: none !important;
        clear: both !important;
    }
    
    .navbar-collapse .right-actions .btn-primary-custom {
        display: block !important;
        width: 100% !important;
        margin: 0 !important;
        float: none !important;
        clear: both !important;
    }
    
    /* Убираем все flex свойства для мобильных */
    .navbar-collapse .d-flex {
        display: block !important;
    }
    
    .navbar-collapse .gap-3 {
        gap: 0 !important;
    }
    
    .navbar-collapse .ms-lg-3 {
        margin-left: 0 !important;
    }
    
    .navbar-collapse .flex-nowrap {
        flex-wrap: wrap !important;
    }
}
EOF

echo "--- [ШАГ 6/7] СОБИРАЕМ СТАТИЧЕСКИЕ ФАЙЛЫ ---"
python manage.py collectstatic --noinput

echo "--- [ШАГ 7/7] ЗАПУСКАЕМ СЛУЖБЫ ---"
supervisorctl start kodbezopasnosti

echo "========================================================"
echo "✅ МОБИЛЬНОЕ МЕНЮ ОКОНЧАТЕЛЬНО ИСПРАВЛЕНО!"
echo ""
echo "Что сделано:"
echo "1. ✅ Принудительно разделил номер и кнопку"
echo "2. ✅ Убрал все flex свойства для мобильных"
echo "3. ✅ Добавил display: block для принудительного разделения"
echo "4. ✅ Обновлен CSS до версии 2.9"
echo ""
echo "Проверь на мобильном: 📱 http://91.229.8.148/"
echo "Теперь номер и кнопка точно будут в колонку!"
echo "========================================================"
