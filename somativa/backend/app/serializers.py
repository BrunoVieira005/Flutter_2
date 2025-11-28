from rest_framework import serializers
from django.contrib.auth.models import User

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'password', 'email'] # Campos que o app vai enviar
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        # Cria o usuário no banco com a senha criptografada corretamente
        user = User.objects.create_user(**validated_data)
        return user