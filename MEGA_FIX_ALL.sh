#!/bin/bash

# ==============================================================================
#  МЕГА-СКРИПТ ИСПРАВЛЕНИЯ ВСЕГО И ВСЯ
#  Исправляет админку, статические файлы, настройки Django и Nginx
# ==============================================================================

echo "🚀 МЕГА-СКРИПТ ИСПРАВЛЕНИЯ ВСЕГО И ВСЯ..."

# Останавливаем ВСЕ службы
echo "--- [ШАГ 1/15] ОСТАНОВКА ВСЕХ СЛУЖБ ---"
supervisorctl stop kodbezopasnosti 2>/dev/null || true
systemctl stop nginx 2>/dev/null || true

# Переходим в папку проекта
cd /var/www/kod-bezopasnosti

# Активируем виртуальное окружение
source venv/bin/activate

echo "--- [ШАГ 2/15] ОЧИСТКА ВСЕГО ---"
rm -rf staticfiles/*
rm -rf static/*
rm -rf media/site_images/*

echo "--- [ШАГ 3/15] СОЗДАЕМ ПРАВИЛЬНЫЙ SETTINGS.PY ---"
cat > kodbezopasnosti/settings.py << 'EOF'
"""
Django settings for kodbezopasnosti project.
"""

from pathlib import Path

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-n9l-5-lab(bhho6z+bl9j354x5gjwf#9s^z9+sn-8omzgz-#e-'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

# РАЗРЕШАЕМ ВСЕ ХОСТЫ
ALLOWED_HOSTS = ['*']

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'main',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'kodbezopasnosti.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'main.context_processors.site_images',
            ],
        },
    },
]

WSGI_APPLICATION = 'kodbezopasnosti.wsgi.application'

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
LANGUAGE_CODE = 'ru-ru'
TIME_ZONE = 'Asia/Omsk'
USE_I18N = True
USE_TZ = True

# Static files (CSS, JavaScript, Images)
STATIC_URL = 'static/'
STATICFILES_DIRS = [BASE_DIR / 'static']
STATIC_ROOT = BASE_DIR / 'staticfiles'

MEDIA_URL = 'media/'
MEDIA_ROOT = BASE_DIR / 'media'

# Default primary key field type
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
EOF

echo "--- [ШАГ 4/15] ВЫПОЛНЯЕМ МИГРАЦИИ ---"
python manage.py migrate

echo "--- [ШАГ 5/15] СОЗДАЕМ СУПЕРПОЛЬЗОВАТЕЛЯ ---"
python manage.py shell << 'EOF'
from django.contrib.auth.models import User
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
    print("Создан суперпользователь: admin / admin123")
else:
    print("Суперпользователь уже существует")
EOF

echo "--- [ШАГ 6/15] СОБИРАЕМ СТАТИЧЕСКИЕ ФАЙЛЫ ---"
python manage.py collectstatic --noinput --clear

echo "--- [ШАГ 7/15] СОЗДАЕМ ПРАВИЛЬНУЮ КОНФИГУРАЦИЮ NGINX ---"
cat > /etc/nginx/sites-available/kod-bezopasnosti.ru << 'EOF'
server {
    listen 80;
    server_name kod-bezopasnosti.ru www.kod-bezopasnosti.ru 91.229.8.148;

    # Логи
    access_log /var/log/nginx/kod-bezopasnosti.access.log;
    error_log /var/log/nginx/kod-bezopasnosti.error.log;

    # Статические файлы Django
    location /static/ {
        alias /var/www/kod-bezopasnosti/staticfiles/;
        expires 30d;
        add_header Cache-Control "public, immutable";
        add_header Access-Control-Allow-Origin "*";
    }

    # Медиа файлы
    location /media/ {
        alias /var/www/kod-bezopasnosti/media/;
        expires 30d;
        add_header Cache-Control "public, immutable";
        add_header Access-Control-Allow-Origin "*";
    }

    # Основное приложение Django
    location / {
        proxy_pass http://unix:/var/www/kod-bezopasnosti/kodbezopasnosti.sock;
        proxy_set_header Host 91.229.8.148;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Connection "";
        proxy_http_version 1.1;
    }

    # Favicon
    location = /favicon.ico {
        access_log off;
        log_not_found off;
    }
}
EOF

echo "--- [ШАГ 8/15] ВКЛЮЧАЕМ САЙТ В NGINX ---"
ln -sf /etc/nginx/sites-available/kod-bezopasnosti.ru /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

echo "--- [ШАГ 9/15] ПРОВЕРЯЕМ КОНФИГУРАЦИЮ NGINX ---"
nginx -t

echo "--- [ШАГ 10/15] ИСПРАВЛЯЕМ ПРАВА ДОСТУПА ---"
chown -R www-data:www-data /var/www/kod-bezopasnosti
chmod -R 755 /var/www/kod-bezopasnosti
chmod -R 644 /var/www/kod-bezopasnosti/staticfiles/*

echo "--- [ШАГ 11/15] ПЕРЕЗАПИСЫВАЕМ КОНФИГУРАЦИЮ SUPERVISOR ---"
cat > /etc/supervisor/conf.d/kodbezopasnosti.conf << 'EOF'
[program:kodbezopasnosti]
command=/var/www/kod-bezopasnosti/venv/bin/gunicorn --workers 3 --bind unix:/var/www/kod-bezopasnosti/kodbezopasnosti.sock kodbezopasnosti.wsgi:application
directory=/var/www/kod-bezopasnosti
user=www-data
autostart=true
autorestart=true
stderr_logfile=/var/log/kodbezopasnosti.err.log
stdout_logfile=/var/log/kodbezopasnosti.out.log
EOF

echo "--- [ШАГ 12/15] ПЕРЕЗАГРУЖАЕМ SUPERVISOR ---"
supervisorctl reread
supervisorctl update

echo "--- [ШАГ 13/15] ЗАПУСКАЕМ GUNICORN ---"
supervisorctl start kodbezopasnosti

echo "--- [ШАГ 14/15] ЗАПУСКАЕМ NGINX ---"
systemctl start nginx

echo "--- [ШАГ 15/15] ПРОВЕРЯЕМ СТАТУС ---"
echo "Статус Gunicorn:"
supervisorctl status kodbezopasnosti

echo ""
echo "Статус Nginx:"
systemctl status nginx --no-pager -l

echo ""
echo "========================================================"
echo "✅ МЕГА-СКРИПТ ЗАВЕРШЕН!"
echo ""
echo "Проверь сайт:"
echo "  🌐 http://91.229.8.148/"
echo "  🌐 http://91.229.8.148/admin/"
echo ""
echo "Логин админки: admin / admin123"
echo ""
echo "Если что-то не работает, проверь логи:"
echo "  tail -f /var/log/kodbezopasnosti.err.log"
echo "  tail -f /var/log/nginx/kod-bezopasnosti.error.log"
echo "========================================================"
