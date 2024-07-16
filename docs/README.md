Para desenvolver esta aplicação web, usaremos Docker, Flask, PostgreSQL, HTML, CSS e JavaScript. Abaixo está a estrutura do projeto, incluindo os requisitos funcionais e não funcionais:

### Estrutura do Projeto

- `app/`
  - `__init__.py`
  - `models.py`
  - `routes.py`
  - `templates/`
    - `index.html`
    - `colaboradores.html`
    - `cadastro_colaborador.html`
    - `alterar_colaborador.html`
    - `registro_ponto.html`
  - `static/`
    - `css/`
      - `styles.css`
    - `js/`
      - `scripts.js`
  - `tests/`
    - `test_colaboradores.py`
- `Dockerfile`
- `docker-compose.yml`
- `requirements.txt`
- `manage.py`

### Dockerfile

```dockerfile
# Utilizando a imagem oficial do Python 3.10 com Alpine
FROM python:3.10-alpine

# Setando o diretório de trabalho
WORKDIR /app

# Instalando dependências
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copiando o conteúdo do diretório atual para o diretório de trabalho no container
COPY . .

# Expondo a porta 5000 para acesso ao serviço
EXPOSE 5000

# Comando para rodar a aplicação
CMD ["python", "manage.py"]
```

### docker-compose.yml

```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    volumes:
      - .:/app
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
```

### requirements.txt

```txt
Flask==2.0.3
Flask-SQLAlchemy==2.5.1
Flask-Migrate==3.1.0
psycopg2-binary==2.9.3
gunicorn==20.1.0
```

### app/__init__.py

```python
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
```

### app/models.py

```python
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
```

### app/routes.py

```python
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
```

### app/templates/index.html

```html
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
```

### app/templates/colaboradores.html

```html
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
```

### app/templates/cadastro_colaborador.html

```html
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
        <label for="data_admissao">Data de Admissão</label>
        <input type="date" id="data_admissao" name="data_admissao">
        <label for="email">E-mail</label>
        <input type="email" id="email" name="email">
        <label for="

telefone">Telefone</label>
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
```

### app/templates/alterar_colaborador.html

```html
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
```

### app/templates/registro_ponto.html

```html
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
```

### app/static/css/styles.css

```css
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
```

### app/static/js/scripts.js

```javascript
// Adicione scripts JavaScript aqui, se necessário.
```

### app/tests/test_colaboradores.py

```python
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
```

### manage.py

```python
from flask.cli import FlaskGroup
from app import app, db

cli = FlaskGroup(app)

if __name__ == '__main__':
    cli()
```

### Requisitos Funcionais

1. **Autenticação**:
   - Página de login para usuários cadastrados.

2. **Cadastro de Colaboradores**:
   - Formulário para inserir novos colaboradores.
   - Campos: CPF, nome, data de nascimento, data de admissão, e-mail, telefone, usuário, cargo, função.

3. **Listagem de Colaboradores**:
   - Exibição de uma lista com colaboradores cadastrados.
   - Botão para editar e excluir colaboradores.

4. **Edição de Colaboradores**:
   - Formulário para atualizar informações de colaboradores existentes.

5. **Exclusão de Colaboradores**:
   - Função para excluir colaboradores cadastrados.

6. **Registro de Ponto**:
   - Formulário para registrar entrada e saída dos colaboradores.

### Requisitos Não Funcionais

1. **Segurança**:
   - Validação de formulários.
   - Senhas armazenadas de forma segura (não implementado neste exemplo).

2. **Usabilidade**:
   - Interface intuitiva e responsiva.

3. **Escalabilidade**:
   - Estrutura preparada para crescer com a aplicação.

### Instruções para Executar

1. Clone o repositório:
   ```sh
   git clone <URL_DO_REPOSITORIO>
   cd <NOME_DO_REPOSITORIO>
   ```

2. Execute o Docker Compose:
   ```sh
   docker-compose up --build
   ```

3. Acesse a aplicação em [http://localhost:5000](http://localhost:5000).

Esses arquivos e instruções devem fornecer uma base sólida para o desenvolvimento da aplicação web proposta.