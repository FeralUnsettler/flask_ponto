import pytest
from app.models import Colaborador

def test_colaborador_model():
    colaborador = Colaborador(
        cpf="12345678901",
        nome="Teste",
        email="teste@example.com",
        telefone="123456789",
        data_admissao="2021-01-01",
        cargo="Desenvolvedor",
        funcao="Backend",
        usuario="testeuser",
        ativo=True
    )
    assert colaborador.nome == "Teste"
    assert colaborador.email == "teste@example.com"
