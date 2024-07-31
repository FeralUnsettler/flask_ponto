from . import db

class Colaborador(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    cpf = db.Column(db.String(11), unique=True, nullable=False)
    nome = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    telefone = db.Column(db.String(20))
    ativo = db.Column(db.Boolean, default=True)
    data_nascimento = db.Column(db.Date, nullable=False)
    data_admissao = db.Column(db.Date, nullable=False)
    data_rescisao = db.Column(db.Date)
    cargo = db.Column(db.String(50))
    funcao = db.Column(db.String(50))
    usuario = db.Column(db.String(50), unique=True, nullable=False)

    def __repr__(self):
        return f'<Colaborador {self.nome}>'
