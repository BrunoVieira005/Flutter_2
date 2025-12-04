from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Pedido, ItemPedido, Produto

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'password', 'email'] # Campos que o app vai enviar
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        # Cria o usuário no banco com a senha criptografada corretamente
        user = User.objects.create_user(**validated_data)
        return user

class ProdutoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Produto
        fields = ['id', 'nome', 'preco', 'categoria', 'imagem_url']

class ItemPedidoSerializer(serializers.ModelSerializer):
    nome_produto = serializers.CharField(source='produto.nome', read_only=True)
    
    class Meta:
        model = ItemPedido
        fields = ['produto', 'nome_produto', 'quantidade', 'preco_no_momento']

class PedidoSerializer(serializers.ModelSerializer):
    itens = ItemPedidoSerializer(many=True) # Nested Serializer (Itens dentro do Pedido)

    class Meta:
        model = Pedido
        fields = ['id', 'status', 'total', 'endereco_entrega', 'data_pedido', 'itens']

    def create(self, validated_data):
        itens_data = validated_data.pop('itens') # Separa os itens do cabeçalho
        # Cria o pedido principal associado ao usuário logado (passado na View)
        pedido = Pedido.objects.create(**validated_data)
        
        # Cria cada item do pedido
        for item_data in itens_data:
            ItemPedido.objects.create(pedido=pedido, **item_data)
        
        return pedido