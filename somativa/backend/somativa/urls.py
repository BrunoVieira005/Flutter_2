from django.contrib import admin
from django.urls import path
# Importa a view pronta de Login do DRF
from rest_framework.authtoken.views import obtain_auth_token 
from app.views import RegisterView

urlpatterns = [
    path('admin/', admin.site.urls),
    
    # ROTA DE LOGIN (Tela A):
    # O App envia JSON: {"username": "...", "password": "..."}
    # O Backend responde: {"token": "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b"}
    path('api/login/', obtain_auth_token, name='api_login'),

    # ROTA DE CADASTRO (Tela B):
    path('api/register/', RegisterView.as_view(), name='api_register'),
]