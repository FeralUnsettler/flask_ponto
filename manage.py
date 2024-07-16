from flask.cli import FlaskGroup
from app import app, db
from app.models import User, Colaborador, Horario
from datetime import datetime

cli = FlaskGroup(app)

@cli.command("create_db")
def create_db():
    db.drop_all()
    db.create_all()
    db.session.commit()

@cli.command("seed_db")
def seed_db():
    # Criar usuário administrador
    admin = User(username="admin", email="admin@example.com", password="admin123", role="admin")
    db.session.add(admin)
    
    # Criar 10 colaboradores fictícios
    for i in range(1, 11):
        colaborador = Colaborador(
            cpf=f"1234567890{i}",
            nome=f"Colaborador {i}",
            email=f"colaborador{i}@example.com",
            telefone=f"99999-999{i}",
            data_nascimento=datetime(1990, 1, 1),
            data_admissao=datetime(2020, 1, 1),
            cargo="Cargo Exemplo",
            funcao="Funcao Exemplo",
            usuario=f"colaborador_{i}"
        )
        db.session.add(colaborador)
    db.session.commit()

if __name__ == '__main__':
    cli()