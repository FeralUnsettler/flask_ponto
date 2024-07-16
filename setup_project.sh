#!/bin/bash

# Diretórios do projeto
mkdir -p flask_ponto/app/{templates,static/{css,js},tests}

# Arquivos do projeto
touch app/__init__.py
touch app/models.py
touch app/routes.py
touch app/templates/{index.html,colaboradores.html,cadastro_colaborador.html,alterar_colaborador.html,registro_ponto.html}
touch app/static/css/styles.css
touch app/static/js/scripts.js
touch app/tests/test_colaboradores.py
touch Dockerfile
touch docker-compose.yml
touch requirements.txt
touch manage.py

# Conteúdo do arquivo Dockerfile
cat <<EOL > Dockerfile
FROM python:3.10-alpine

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy project
COPY . /app/

# Expose the port the app runs on
EXPOSE 5000

# Run the Flask app
CMD ["flask", "run", "--host=0.0.0.0"]
EOL

# Conteúdo do arquivo docker-compose.yml
cat <<EOL > docker-compose.yml
version: '2.28.0'

services:
  web:
    build: .
    command: flask run --host=0.0.0.0
    volumes:
      - .:/app
    ports:
      - "5000:5000"
    environment:
      FLASK_APP: manage.py
      FLASK_ENV: development
    depends_on:
      - db

  db:
    image: postgres:13
    environment:
      POSTGRES_DB: colaboradores_db
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOL

# Conteúdo do arquivo requirements.txt
cat <<EOL > requirements.txt
Flask==2.0.3
Flask-SQLAlchemy==2.5.1
Flask-Migrate==3.1.0
psycopg2-binary==2.9.3
gunicorn==20.1.0
EOL

# Conteúdo do arquivo app/__init__.py
cat <<EOL > app/__init__.py
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://user:password@db:5432/colaboradores_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)

from . import routes, models

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOL

# Conteúdo do arquivo app/models.py
cat <<EOL > app/models.py
from . import db

class Colaborador(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    cpf = db.Column(db.String(11), unique=True, nullable=False)
    nome = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), nullable=False)
    telefone = db.Column(db.String(15), nullable=True)
    data_nascimento = db.Column(db.Date, nullable=False)
    data_admissao = db.Column(db.Date, nullable=False)
    data_rescisao = db.Column(db.Date, nullable=True)
    ativo = db.Column(db.Boolean, nullable=False, default=True)
    usuario = db.Column(db.String(100), unique=True, nullable=False)
    cargo = db.Column(db.String(50), nullable=False)
    funcao = db.Column(db.String(50), nullable=False)

class Horario(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    colaborador_id = db.Column(db.Integer, db.ForeignKey('colaborador.id'), nullable=False)
    dia_semana = db.Column(db.String(9), nullable=False)
    entrada1 = db.Column(db.Time, nullable=True)
    saida1 = db.Column(db.Time, nullable=True)
    entrada2 = db.Column(db.Time, nullable=True)
    saida2 = db.Column(db.Time, nullable=True)
EOL

# Conteúdo do arquivo app/routes.py
cat <<EOL > app/routes.py
from flask import render_template, request, redirect, url_for, flash
from . import app, db
from .models import Colaborador, Horario

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/colaboradores')
def lista_colaboradores():
    colaboradores = Colaborador.query.all()
    return render_template('colaboradores.html', colaboradores=colaboradores)

@app.route('/colaborador/novo', methods=['GET', 'POST'])
def novo_colaborador():
    if request.method == 'POST':
        # Processa o formulário de criação de colaborador
        pass
    return render_template('cadastro_colaborador.html')

@app.route('/colaborador/<int:id>/editar', methods=['GET', 'POST'])
def editar_colaborador(id):
    colaborador = Colaborador.query.get_or_404(id)
    if request.method == 'POST':
        # Processa o formulário de edição de colaborador
        pass
    return render_template('alterar_colaborador.html', colaborador=colaborador)

@app.route('/colaborador/<int:id>/excluir', methods=['POST'])
def excluir_colaborador(id):
    colaborador = Colaborador.query.get_or_404(id)
    db.session.delete(colaborador)
    db.session.commit()
    return redirect(url_for('lista_colaboradores'))

@app.route('/registro_ponto')
def registro_ponto():
    return render_template('registro_ponto.html')
EOL

# Conteúdo do arquivo app/templates/index.html
cat <<EOL > app/templates/index.html
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Cadastro e Ponto</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/styles.css') }}">
</head>
<body>
    <h1>XYZ</h1>
    <h2>Sistema de Cadastro e Ponto</h2>
    <form action="{{ url_for('lista_colaboradores') }}" method="POST">
        <input type="text" name="usuario" placeholder="Usuário">
        <input type="password" name="senha" placeholder="Senha">
        <button type="submit">Entrar</button>
    </form>
    <a href="{{ url_for('registro_ponto') }}">Registro de Ponto</a>
</body>
</html>
EOL

# Conteúdo do arquivo app/templates/colaboradores.html
cat <<EOL > app/templates/colaboradores.html
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Colaboradores</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/styles.css') }}">
</head>
<body>
    <h1>Colaboradores</h1>
    <a href="{{ url_for('novo_colaborador') }}">Inserir Novo Colaborador</a>
    <table>
        <thead>
            <tr>
                <th>Matrícula</th>
                <th>Nome</th>
                <th>E-mail</th>
                <th>Telefone</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            {% for colaborador in colaboradores %}
            <tr>
                <td>{{ colaborador.id }}</td>
                <td>{{ colaborador.nome }}</td>
                <td>{{ colaborador.email }}</td>
                <td>{{ colaborador.telefone }}</td>
                <td>
                    <a href="{{ url_for('editar_colaborador', id=colaborador.id) }}">Editar</a>
                    <form action="{{ url_for('excluir_colaborador', id=colaborador.id) }}" method="POST">
                        <button type="submit">Excluir</button>
                    </form>
                </td>
            </tr>
            {% endfor %}
        </tbody>
    </table>
</body>
</html>
EOL

# Conteúdo do arquivo app/templates/cadastro_colaborador.html
cat <<EOL > app/templates/cadastro_colaborador.html
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro de Colaboradores</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/styles.css') }}">
</head>
<body>
    <h1>Cadastro de Colaboradores</h1>
    <form action="{{ url_for('novo_colaborador') }}" method="POST">
        <label for="cpf">CPF</label>
        <input type="text" id="cpf" name="cpf">
        <label for="nome">Nome</label>
        <input type="text" id="nome" name="nome">
        <label for="data_nascimento">Data de Nascimento</label>
        <input type="date" id="data_nascimento" name="data_nascimento">
        <label for="data_admissao">Data de Ad

missão</label>
        <input type="date" id="data_admissao" name="data_admissao">
        <label for="email">E-mail</label>
        <input type="email" id="email" name="email">
        <label for="telefone">Telefone</label>
        <input type="text" id="telefone" name="telefone">
        <label for="usuario">Usuário</label>
        <input type="text" id="usuario" name="usuario">
        <label for="cargo">Cargo</label>
        <input type="text" id="cargo" name="cargo">
        <label for="funcao">Função</label>
        <input type="text" id="funcao" name="funcao">
        <button type="submit">Salvar</button>
    </form>
</body>
</html>
EOL

# Conteúdo do arquivo app/templates/alterar_colaborador.html
cat <<EOL > app/templates/alterar_colaborador.html
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alterar Colaborador</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/styles.css') }}">
</head>
<body>
    <h1>Alterar Colaborador</h1>
    <form action="{{ url_for('editar_colaborador', id=colaborador.id) }}" method="POST">
        <label for="cpf">CPF</label>
        <input type="text" id="cpf" name="cpf" value="{{ colaborador.cpf }}">
        <label for="nome">Nome</label>
        <input type="text" id="nome" name="nome" value="{{ colaborador.nome }}">
        <label for="data_nascimento">Data de Nascimento</label>
        <input type="date" id="data_nascimento" name="data_nascimento" value="{{ colaborador.data_nascimento }}">
        <label for="data_admissao">Data de Admissão</label>
        <input type="date" id="data_admissao" name="data_admissao" value="{{ colaborador.data_admissao }}">
        <label for="email">E-mail</label>
        <input type="email" id="email" name="email" value="{{ colaborador.email }}">
        <label for="telefone">Telefone</label>
        <input type="text" id="telefone" name="telefone" value="{{ colaborador.telefone }}">
        <label for="usuario">Usuário</label>
        <input type="text" id="usuario" name="usuario" value="{{ colaborador.usuario }}">
        <label for="cargo">Cargo</label>
        <input type="text" id="cargo" name="cargo" value="{{ colaborador.cargo }}">
        <label for="funcao">Função</label>
        <input type="text" id="funcao" name="funcao" value="{{ colaborador.funcao }}">
        <button type="submit">Salvar</button>
    </form>
</body>
</html>
EOL

# Conteúdo do arquivo app/templates/registro_ponto.html
cat <<EOL > app/templates/registro_ponto.html
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Ponto</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/styles.css') }}">
</head>
<body>
    <h1>Registro de Ponto</h1>
    <form action="{{ url_for('registro_ponto') }}" method="POST">
        <input type="text" name="usuario" placeholder="Usuário">
        <button type="submit">Registrar Entrada/Saída</button>
    </form>
</body>
</html>
EOL

# Conteúdo do arquivo app/static/css/styles.css
cat <<EOL > app/static/css/styles.css
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}

h1, h2 {
    text-align: center;
    margin: 20px 0;
}

form {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: 20px 0;
}

input, button {
    margin: 10px;
    padding: 10px;
    width: 200px;
}

table {
    margin: 20px auto;
    border-collapse: collapse;
    width: 80%;
}

th, td {
    border: 1px solid #ddd;
    padding: 8px;
}

th {
    background-color: #4CAF50;
    color: white;
    text-align: left;
}
EOL

# Conteúdo do arquivo app/static/js/scripts.js
cat <<EOL > app/static/js/scripts.js
// Adicione scripts JavaScript aqui, se necessário.
EOL

# Conteúdo do arquivo app/tests/test_colaboradores.py
cat <<EOL > app/tests/test_colaboradores.py
import unittest
from app import app, db
from app.models import Colaborador

class ColaboradoresTestCase(unittest.TestCase):

    def setUp(self):
        app.config['TESTING'] = True
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
        self.app = app.test_client()
        db.create_all()

    def tearDown(self):
        db.session.remove()
        db.drop_all()

    def test_lista_colaboradores(self):
        response = self.app.get('/colaboradores')
        self.assertEqual(response.status_code, 200)

    def test_novo_colaborador(self):
        response = self.app.post('/colaborador/novo', data=dict(
            cpf='12345678901',
            nome='Teste',
            data_nascimento='1990-01-01',
            data_admissao='2020-01-01',
            email='teste@example.com',
            telefone='999999999',
            usuario='teste',
            cargo='Desenvolvedor',
            funcao='Backend'
        ))
        self.assertEqual(response.status_code, 302)
        colaborador = Colaborador.query.filter_by(cpf='12345678901').first()
        self.assertIsNotNone(colaborador)

if __name__ == '__main__':
    unittest.main()
EOL

# Conteúdo do arquivo manage.py
cat <<EOL > manage.py
from flask.cli import FlaskGroup
from app import app, db

cli = FlaskGroup(app)

if __name__ == '__main__':
    cli()
EOL

echo "Estrutura do projeto criada com sucesso!"
