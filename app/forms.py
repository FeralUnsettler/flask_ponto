from flask_wtf import FlaskForm
from wtforms import StringField, BooleanField, DateField, SubmitField
from wtforms.validators import DataRequired, Email, Length

class ColaboradorForm(FlaskForm):
    cpf = StringField('CPF', validators=[DataRequired(), Length(min=11, max=11)])
    nome = StringField('Nome', validators=[DataRequired()])
    email = StringField('Email', validators=[DataRequired(), Email()])
    telefone = StringField('Telefone')
    data_admissao = DateField('Data de Admissão', validators=[DataRequired()])
    data_rescisao = DateField('Data de Rescisão')
    cargo = StringField('Cargo')
    funcao = StringField('Função')
    usuario = StringField('Usuário', validators=[DataRequired()])
    ativo = BooleanField('Ativo')
    submit = SubmitField('Salvar')
