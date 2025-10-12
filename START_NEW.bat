@echo off
echo ==========================================
echo    КОД БЕЗОПАСНОСТИ - ЗАПУСК САЙТА
echo    Python 3.11.9 + Django 5.2.7
echo ==========================================
echo.

echo [1/4] Активация виртуального окружения...
call venv\Scripts\activate
if errorlevel 1 (
    echo ОШИБКА: Не удалось активировать виртуальное окружение!
    echo Убедитесь, что Python 3.11.9 установлен.
    pause
    exit /b 1
)

echo [2/4] Применение миграций базы данных...
py manage.py migrate
if errorlevel 1 (
    echo ОШИБКА: Не удалось применить миграции!
    pause
    exit /b 1
)

echo [3/4] Сбор статических файлов...
py manage.py collectstatic --noinput
if errorlevel 1 (
    echo ОШИБКА: Не удалось собрать статические файлы!
    pause
    exit /b 1
)

echo [4/4] Запуск Django сервера...
echo.
echo ==========================================
echo    САЙТ ЗАПУЩЕН!
echo    Откройте: http://127.0.0.1:8000/
echo ==========================================
echo.
echo Для остановки нажмите Ctrl+C
echo.

py manage.py runserver
