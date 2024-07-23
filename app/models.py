from datetime import datetime
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    
    
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    role = db.Column(db.Boolean, default=False, nullable=False)

class Colaborador(db.Model):
    
    
    id = db.Column(db.Integer, primary_key=True)
    cpf = db.Column(db.String(11), unique=True, nullable=False)
    nome = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(120), nullable=False)
    telefone = db.Column(db.String(15), nullable=True)
    data_nascimento = db.Column(db.Date, nullable=False)
    data_admissao = db.Column(db.Date, nullable=False)
    data_rescisao = db.Column(db.Date, nullable=True)
    cargo = db.Column(db.String(50), nullable=False)
    funcao = db.Column(db.String(50), nullable=False)
    ativo = db.Column(db.Boolean, default=True)
    usuario = db.Column(db.String(50), unique=True, nullable=False)
    horario = db.relationship('horario', backref='colaborador', lazy=True)

class Horario(db.Model):
    
    
    id = db.Column(db.Integer, primary_key=True)
    colaborador_id = db.Column(db.Integer, db.ForeignKey('colaborador.id'), nullable=False)
    dia_semana = db.Column(db.String(10), nullable=False)
    entrada1 = db.Column(db.Time, nullable=True)
    saida1 = db.Column(db.Time, nullable=True)
    entrada2 = db.Column(db.Time, nullable=True)
    saida2 = db.Column(db.Time, nullable=True)