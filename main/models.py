from django.db import models
from django.utils import timezone


class ConsultationRequest(models.Model):
    """Модель для хранения заявок на консультацию"""
    
    CATEGORY_CHOICES = [
        ('business', 'Для бизнеса'),
        ('industry', 'Для промышленности'),
        ('city', 'Безопасный город'),
        ('housing', 'Для жилых комплексов'),
        ('general', 'Общая консультация'),
    ]
    
    name = models.CharField('Имя', max_length=100)
    phone = models.CharField('Телефон', max_length=20)
    email = models.EmailField('Email')
    category = models.CharField('Категория', max_length=20, choices=CATEGORY_CHOICES, default='general')
    message = models.TextField('Сообщение', blank=True, null=True)
    consent = models.BooleanField('Согласие на обработку данных', default=False)
    created_at = models.DateTimeField('Дата создания', default=timezone.now)
    processed = models.BooleanField('Обработано', default=False)
    
    class Meta:
        verbose_name = 'Заявка на консультацию'
        verbose_name_plural = 'Заявки на консультацию'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"Заявка от {self.name} ({self.phone})"

class SiteImage(models.Model):
    PAGE_CHOICES = [
        ('home', 'Главная'),
        ('business', 'Для бизнеса'),
        ('industry', 'Для промышленности'),
        ('city', 'Безопасный город'),
        ('housing', 'Для ЖК'),
        ('contacts', 'Контакты'),
        ('common', 'Общие'),
    ]
    
    key = models.CharField(max_length=100, unique=True, verbose_name="Ключ изображения")
    image = models.ImageField(upload_to='site_images/', verbose_name="Изображение")
    description = models.CharField(max_length=255, blank=True, null=True, verbose_name="Описание")
    page = models.CharField(max_length=20, choices=PAGE_CHOICES, default='common', verbose_name="Страница")
    display_name = models.CharField(max_length=200, default='', verbose_name="Понятное название")

    class Meta:
        verbose_name = "Изображение сайта"
        verbose_name_plural = "Изображения сайта"
        ordering = ['page', 'display_name']

    def __str__(self):
        return f"{self.get_page_display()} - {self.display_name}"



class TextPage(models.Model):
    slug = models.SlugField(max_length=100, unique=True, verbose_name="URL-адрес (slug)")
    title = models.CharField(max_length=200, verbose_name="Заголовок страницы")
    content = models.TextField(verbose_name="Содержимое страницы")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Последнее обновление")

    def __str__(self):
        return self.title

    class Meta:
        verbose_name = "Текстовая страница"
        verbose_name_plural = "Текстовые страницы"
