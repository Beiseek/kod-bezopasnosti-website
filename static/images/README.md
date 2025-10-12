# Изображения для сайта

## Рекомендуемые изображения

### Hero-секции (фоновые изображения)

Разместите следующие изображения в этой папке:

1. **hero-main.jpg** - Главная страница
   - Тема: AI, видеонаблюдение, технологичный интерфейс
   - Размер: 1920x1080px
   - Источники:
     - https://unsplash.com/s/photos/ai-surveillance
     - https://unsplash.com/s/photos/security-camera-ai
     - https://unsplash.com/s/photos/smart-city-technology

2. **hero-business.jpg** - Для бизнеса
   - Тема: Офис, торговый зал, склад с видеокамерами
   - Размер: 1920x1080px
   - Источники:
     - https://unsplash.com/s/photos/office-security
     - https://unsplash.com/s/photos/warehouse-surveillance

3. **hero-industry.jpg** - Для промышленности
   - Тема: Завод, производство, промышленная площадка
   - Размер: 1920x1080px
   - Источники:
     - https://unsplash.com/s/photos/factory-security
     - https://unsplash.com/s/photos/industrial-surveillance

4. **hero-city.jpg** - Безопасный город
   - Тема: Городская инфраструктура, умный город, видеонаблюдение на улицах
   - Размер: 1920x1080px
   - Источники:
     - https://unsplash.com/s/photos/smart-city
     - https://unsplash.com/s/photos/city-surveillance

5. **hero-housing.jpg** - Для ЖК
   - Тема: Жилой комплекс, двор, детская площадка
   - Размер: 1920x1080px
   - Источники:
     - https://unsplash.com/s/photos/residential-complex
     - https://unsplash.com/s/photos/apartment-security

### Иконки и дополнительные изображения

- **logo.png** - Логотип компании (когда будет готов)
  - Размер: 250x80px (примерно)
  - Формат: PNG с прозрачностью

## Текущие фоновые изображения

В CSS используются изображения с Unsplash через CDN:
- `https://images.unsplash.com/photo-1550751827-4bd374c3f58b?w=1920&h=1080&fit=crop`

Для production рекомендуется скачать изображения локально.

## Как добавить изображения

1. Скачайте изображения по рекомендованным темам
2. Оптимизируйте их (сжатие без потери качества)
3. Поместите в папку `static/images/`
4. Обновите пути в CSS файле `static/css/style.css`

Пример:
```css
.hero-section::before {
    background-image: url('../images/hero-main.jpg');
}
```

## Лицензирование

При использовании изображений с Unsplash/Pexels соблюдайте их лицензионные требования.

