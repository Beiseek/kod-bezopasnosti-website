from django import forms
from .models import ConsultationRequest

class ConsultationRequestForm(forms.ModelForm):
    agree_policy = forms.BooleanField(
        label="",
        required=True,
        widget=forms.CheckboxInput(attrs={'class': 'form-check-input'})
    )
    agree_processing = forms.BooleanField(
        label="",
        required=True,
        widget=forms.CheckboxInput(attrs={'class': 'form-check-input'})
    )

    class Meta:
        model = ConsultationRequest
        fields = ['name', 'phone', 'email', 'message', 'category']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Ваше имя'}),
            'phone': forms.TextInput(attrs={'class': 'form-control phone-mask', 'placeholder': '+7 (XXX) XXX-XX-XX'}),
            'email': forms.EmailInput(attrs={'class': 'form-control', 'placeholder': 'Ваш Email (необязательно)'}),
            'message': forms.Textarea(attrs={'class': 'form-control', 'rows': 3, 'placeholder': 'Ваше сообщение (необязательно)'}),
            'category': forms.HiddenInput(),
        }
        labels = {
            'name': 'Имя',
            'phone': 'Телефон',
            'email': 'Email',
            'message': 'Сообщение',
        }

    # Явно делаем email необязательным для совместимости с разными браузерами
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['email'].required = False

    # Нормализуем пустой email в None, чтобы не падать на валидации/сохранении
    def clean_email(self):
        value = self.cleaned_data.get('email')
        if not value:
            return None
        return value

