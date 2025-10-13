#!/bin/bash

echo "🔧 ИСПРАВЛЯЕМ ПРОБЛЕМЫ С ФОРМОЙ..."

# --- Переменные ---
PROJECT_DIR="/var/www/kod-bezopasnosti"
USER="www-data"

echo "--- [ШАГ 1/8] ОСТАНОВКА СЛУЖБ ---"
supervisorctl stop kodbezopasnosti

echo "--- [ШАГ 2/8] ПЕРЕХОД В ПАПКУ ПРОЕКТА ---"
cd $PROJECT_DIR

echo "--- [ШАГ 3/8] АКТИВАЦИЯ ВИРТУАЛЬНОГО ОКРУЖЕНИЯ ---"
source venv/bin/activate

echo "--- [ШАГ 4/8] ПРИМЕНЕНИЕ МИГРАЦИЙ ---"
python manage.py migrate

echo "--- [ШАГ 5/8] НАСТРОЙКА EMAIL ---"
# Создаем файл с настройками email
cat > email_settings.py << 'EOF'
# Email settings для 923sen@mail.ru
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.mail.ru'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = '923sen@mail.ru'
EMAIL_HOST_PASSWORD = 'your_password_here'  # ЗАМЕНИТЕ НА РЕАЛЬНЫЙ ПАРОЛЬ!
DEFAULT_FROM_EMAIL = '923sen@mail.ru'

# CSRF settings для совместимости с Яндекс браузером
CSRF_COOKIE_SECURE = False
CSRF_COOKIE_HTTPONLY = False
CSRF_COOKIE_SAMESITE = 'Lax'
CSRF_TRUSTED_ORIGINS = [
    'http://91.229.8.148',
    'http://kod-bezopasnosti.ru',
    'http://www.kod-bezopasnosti.ru',
]
EOF

echo "--- [ШАГ 6/8] ОБНОВЛЕНИЕ SETTINGS.PY ---"
# Добавляем email настройки в settings.py
if ! grep -q "EMAIL_BACKEND" kodbezopasnosti/settings.py; then
    echo "" >> kodbezopasnosti/settings.py
    echo "# Email settings" >> kodbezopasnosti/settings.py
    echo "EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'" >> kodbezopasnosti/settings.py
    echo "EMAIL_HOST = 'smtp.mail.ru'" >> kodbezopasnosti/settings.py
    echo "EMAIL_PORT = 587" >> kodbezopasnosti/settings.py
    echo "EMAIL_USE_TLS = True" >> kodbezopasnosti/settings.py
    echo "EMAIL_HOST_USER = '923sen@mail.ru'" >> kodbezopasnosti/settings.py
    echo "EMAIL_HOST_PASSWORD = 'your_password_here'  # ЗАМЕНИТЕ НА РЕАЛЬНЫЙ ПАРОЛЬ!" >> kodbezopasnosti/settings.py
    echo "DEFAULT_FROM_EMAIL = '923sen@mail.ru'" >> kodbezopasnosti/settings.py
    echo "" >> kodbezopasnosti/settings.py
    echo "# CSRF settings для совместимости с Яндекс браузером" >> kodbezopasnosti/settings.py
    echo "CSRF_COOKIE_SECURE = False" >> kodbezopasnosti/settings.py
    echo "CSRF_COOKIE_HTTPONLY = False" >> kodbezopasnosti/settings.py
    echo "CSRF_COOKIE_SAMESITE = 'Lax'" >> kodbezopasnosti/settings.py
    echo "CSRF_TRUSTED_ORIGINS = [" >> kodbezopasnosti/settings.py
    echo "    'http://91.229.8.148'," >> kodbezopasnosti/settings.py
    echo "    'http://kod-bezopasnosti.ru'," >> kodbezopasnosti/settings.py
    echo "    'http://www.kod-bezopasnosti.ru'," >> kodbezopasnosti/settings.py
    echo "]" >> kodbezopasnosti/settings.py
fi

echo "--- [ШАГ 7/8] СОБИРАЕМ СТАТИЧЕСКИЕ ФАЙЛЫ ---"
python manage.py collectstatic --noinput

echo "--- [ШАГ 8/8] ЗАПУСКАЕМ СЛУЖБЫ ---"
supervisorctl start kodbezopasnosti

echo "========================================================"
echo "✅ ПРОБЛЕМЫ С ФОРМОЙ ИСПРАВЛЕНЫ!"
echo ""
echo "Что исправлено:"
echo "1. ✅ Email поле теперь необязательное"
echo "2. ✅ CSRF ошибка для Яндекс браузера"
echo "3. ✅ Мобильное меню - номер и кнопка в колонку"
echo "4. ✅ Настроена отправка email на 923sen@mail.ru"
echo ""
echo "ВАЖНО: Замените 'your_password_here' на реальный пароль от почты!"
echo "Файл: kodbezopasnosti/settings.py"
echo ""
echo "Проверь сайт: 🌐 http://91.229.8.148/"
echo "========================================================"
