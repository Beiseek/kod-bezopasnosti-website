from django.contrib import admin
from .models import ConsultationRequest, SiteImage, TextPage

@admin.register(ConsultationRequest)
class ConsultationRequestAdmin(admin.ModelAdmin):
    list_display = ['name', 'phone', 'email', 'category', 'created_at', 'processed']
    list_filter = ['category', 'processed', 'created_at']
    search_fields = ('name', 'phone', 'email', 'message')
    list_editable = ('processed',)
    readonly_fields = ['created_at']
    date_hierarchy = 'created_at'
    
    fieldsets = (
        ('Контактная информация', {
            'fields': ('name', 'phone', 'email')
        }),
        ('Детали заявки', {
            'fields': ('category', 'message')
        }),
        ('Служебная информация', {
            'fields': ('created_at', 'processed')
        }),
    )

@admin.register(SiteImage)
class SiteImageAdmin(admin.ModelAdmin):
    list_display = ('display_name', 'page', 'key', 'image_preview')
    list_display_links = ('key',)
    list_filter = ('page',)
    search_fields = ('key', 'description', 'display_name')
    list_editable = ('display_name',)
    ordering = ('page', 'display_name')
    
    fieldsets = (
        ('Основная информация', {
            'fields': ('key', 'display_name', 'page', 'description')
        }),
        ('Изображение', {
            'fields': ('image',)
        }),
    )
    
    def image_preview(self, obj):
        if obj.image:
            return f'<img src="{obj.image.url}" style="max-height: 50px; max-width: 50px;" />'
        return "Нет изображения"
    image_preview.allow_tags = True
    image_preview.short_description = "Превью"

@admin.register(TextPage)
class TextPageAdmin(admin.ModelAdmin):
    list_display = ('title', 'slug', 'updated_at')
    search_fields = ('title', 'content')
    prepopulated_fields = {'slug': ('title',)}
