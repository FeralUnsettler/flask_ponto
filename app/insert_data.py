import sys
import os

# Adiciona o diretório atual ao PYTHONPATH
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app import create_app, db
from app.models import Colaborador

app = create_app()

with app.app_context():
    # Adicione seus colaboradores de teste aqui
    colaboradores = [
        Colaborador(
            cpf='12345678901',
            nome='João Silva',
            data_nascimento='1980-01-01',
            data_admissao='2020-01-01',
            email='joao.silva@example.com',
            cargo='Analista',
            funcao='Desenvolvedor',
            data_rescisao=None,
            usuario='joao_silva',
            senha='123'
        ),
        Colaborador(
            cpf='98765432109',
            nome='Maria Oliveira',
            data_nascimento='1985-05-05',
            data_admissao='2018-05-05',
            email='maria.oliveira@example.com',
            cargo='Gerente',
            funcao='Gestora de Projetos',
            data_rescisao=None,
            usuario='maria_oliveira',
            senha='123'
        )
    ]

    db.session.bulk_save_objects(colaboradores)
    db.session.commit()
    print('Colaboradores inseridos com sucesso!')
