# 🚀 ИНСТРУКЦИЯ ПО ЗАГРУЗКЕ В GITHUB

## 📋 **ЧТО УЖЕ ГОТОВО:**
- ✅ Git репозиторий инициализирован
- ✅ Все файлы добавлены (код + база данных + 129 фотографий)
- ✅ Сделано 3 коммита
- ✅ README.md с документацией

## 🔧 **ЧТО НУЖНО СДЕЛАТЬ:**

### 1. **Создать репозиторий на GitHub:**
1. Зайди на [github.com](https://github.com)
2. Нажми зеленую кнопку **"New"** или **"+"** → **"New repository"**
3. **Repository name:** `kod-bezopasnosti-website`
4. **Description:** `Website for Код Безопасности - AI-powered video surveillance systems`
5. Сделай **Public** (чтобы было проще)
6. **НЕ** добавляй README, .gitignore, лицензию (у нас уже есть)
7. Нажми **"Create repository"**

### 2. **Загрузить код в репозиторий:**

**Скопируй и выполни эти команды в терминале:**

```bash
# Добавить удаленный репозиторий (замени на свой URL)
git remote add origin https://github.com/ТВОЙ-USERNAME/kod-bezopasnosti-website.git

# Переименовать ветку в main (современный стандарт)
git branch -M main

# Загрузить код в GitHub
git push -u origin main
```

### 3. **Если возникнут проблемы с аутентификацией:**

**Вариант 1 - Personal Access Token:**
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token → Select scopes: `repo`
3. Скопируй токен
4. При запросе пароля вставь токен вместо пароля

**Вариант 2 - GitHub CLI:**
```bash
# Установить GitHub CLI
# Затем:
gh auth login
git push -u origin main
```

## 📁 **ЧТО БУДЕТ В РЕПОЗИТОРИИ:**

### ✅ **ВКЛЮЧЕНО:**
- Весь код Django (104 файла)
- База данных `db.sqlite3` (все настройки, тексты, заявки)
- 129 фотографий в `media/site_images/`
- Логотип в `static/images/logo.png`
- README.md с документацией
- DEPLOYMENT_GUIDE.md с инструкциями

### ❌ **ИСКЛЮЧЕНО (.gitignore):**
- venv/ (виртуальное окружение)
- __pycache__/ (кеш Python)
- staticfiles/ (собранные статические файлы)
- .vscode/, .idea/ (настройки IDE)

## 🎯 **РЕЗУЛЬТАТ:**
После загрузки у тебя будет полный репозиторий с:
- ✅ Рабочим кодом сайта
- ✅ Всеми фотографиями
- ✅ Всеми текстами
- ✅ Настройками изображений
- ✅ Документацией

**ГОТОВО К ЗАГРУЗКЕ НА СЕРВЕР!** 💪
