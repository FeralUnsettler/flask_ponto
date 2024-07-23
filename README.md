O problema ocorre porque a função `url_quote` foi removida ou renomeada em uma versão mais recente do `werkzeug`. Para resolver este problema, precisamos usar uma versão específica do `werkzeug` que ainda inclui a função `url_quote`, ou atualizar o código para compatibilidade com a versão atual do `werkzeug`.

Vamos atualizar a versão do `werkzeug` no `requirements.txt` para uma versão que ainda inclui `url_quote`. Vamos usar `werkzeug==2.0.3`, que deve funcionar com a versão do Flask que estamos usando.

### Atualização do `requirements.txt`

```txt
Flask==2.0.3
Flask-SQLAlchemy==2.5.1
Flask-Migrate==3.1.0
psycopg2-binary==2.9.3
gunicorn==20.1.0
werkzeug==2.0.3
```

### Rebuild do Docker

Depois de atualizar o `requirements.txt`, precisamos reconstruir a imagem Docker para instalar a versão correta do `werkzeug`.

1. Pare e remova os containers existentes:
   ```sh
   docker-compose down
   ```

2. Reconstrua a imagem e inicie os containers:
   ```sh
   docker-compose up --build
   ```

Se preferir atualizar o código para compatibilidade com a versão mais recente do `werkzeug`, substitua `url_quote` por `quote` do módulo `urllib.parse` da biblioteca padrão do Python:

### Atualização do Código

Em vez de importar `url_quote` de `werkzeug.urls`, podemos usar a função `quote` de `urllib.parse`. Essa mudança pode ser necessária em arquivos dentro do pacote `Flask` e seus dependentes, mas vamos focar nas partes do código que você controla diretamente.

**Atualize a importação e uso de `url_quote`**:

### app/__init__.py

Verifique se não há importações de `url_quote` no seu código. Se houver, altere para:

```python
from urllib.parse import quote as url_quote
```

Esta alteração permite que você use `url_quote` da mesma forma que antes.

### Reconstrução do Docker

Após as atualizações no código, reconstrua e reinicie o Docker:

1. Pare e remova os containers existentes:
   ```sh
   docker-compose down
   ```

2. Reconstrua a imagem e inicie os containers:
   ```sh
   docker-compose up --build
   ```

Isso deve resolver o problema de compatibilidade com a função `url_quote`. Se encontrar mais erros relacionados, certifique-se de atualizar o código ou ajustar as versões das dependências conforme necessário.


---

O problema atual está relacionado ao uso de uma versão incompatível do SQLAlchemy. Parece que você está usando uma versão do Flask-SQLAlchemy que não é compatível com a versão mais recente do SQLAlchemy. Vamos corrigir isso especificando versões compatíveis de ambos os pacotes.

### Atualização do `requirements.txt`

```txt
Flask==2.0.3
Flask-SQLAlchemy==2.5.1
Flask-Migrate==3.1.0
psycopg2-binary==2.9.3
gunicorn==20.1.0
werkzeug==2.0.3
SQLAlchemy==1.4.32
```

### Rebuild do Docker

Depois de atualizar o `requirements.txt`, vamos reconstruir a imagem Docker para garantir que as versões corretas dos pacotes sejam instaladas.

1. Pare e remova os containers existentes:
   ```sh
   docker-compose down
   ```

2. Reconstrua a imagem e inicie os containers:
   ```sh
   docker-compose up --build
   ```

Essas etapas devem resolver o problema de compatibilidade com a função `__all__` do SQLAlchemy.

### Confirmar o código do seu projeto

Vamos também garantir que o código do seu projeto esteja correto. Abaixo está um exemplo básico de como o `app/__init__.py` pode ser estruturado:

```python
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@db:5432/postgres'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)

from app import routes, models
```

### Confirmar `manage.py`

Certifique-se de que o `manage.py` esteja correto:

```python
from flask.cli import FlaskGroup
from app import app, db

cli = FlaskGroup(app)

if __name__ == '__main__':
    cli()
```

### Estrutura do Projeto

Certifique-se de que sua estrutura de projeto esteja conforme o esperado:

```
/app
    /app
        __init__.py
        routes.py
        models.py
    manage.py
    Dockerfile
    requirements.txt
    docker-compose.yml
```

Depois de verificar tudo isso, siga as etapas acima para reconstruir e iniciar seus containers Docker. Isso deve resolver os problemas que você está enfrentando.


---


Se o container do web service está saindo com o código 0, isso normalmente indica que o processo terminou corretamente, mas não permaneceu em execução. Isso pode ocorrer se o Flask não foi iniciado corretamente. Vamos garantir que o aplicativo Flask esteja configurado para ser executado corretamente dentro do Docker.

### Certificar que o `app` está sendo executado

Certifique-se de que o seu `manage.py` esteja configurado para iniciar o servidor Flask corretamente:

### manage.py

```python
from flask.cli import FlaskGroup
from app import app, db

cli = FlaskGroup(app)

if __name__ == '__main__':
    cli()
```

### Dockerfile

Certifique-se de que o Dockerfile está configurado corretamente para iniciar o aplicativo Flask:

```Dockerfile
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
```

### docker-compose.yml

Certifique-se de que o Docker Compose está configurado corretamente para iniciar o serviço web:

```yaml
version: '3.8'

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
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: postgres
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
```

### Executar o Docker Compose

Depois de verificar as configurações, execute os seguintes comandos para parar quaisquer containers em execução, reconstruir as imagens e iniciar os serviços novamente:

1. Pare e remova os containers existentes:
   ```sh
   docker-compose down
   ```

2. Reconstrua a imagem e inicie os containers:
   ```sh
   docker-compose up --build
   ```

Isso deve garantir que o Flask seja iniciado corretamente dentro do container Docker e que o serviço permaneça em execução. Se o problema persistir, revise os logs de saída do Docker para obter mais informações sobre por que o container pode estar saindo.


---
insert database

---

Vamos ajustar o código e a configuração para criar o banco de dados com um usuário administrador e dez colaboradores fictícios. Vamos adicionar uma função de seed (semeadura) ao nosso projeto para inserir esses dados iniciais no banco de dados.

### Atualizar `models.py`

Primeiro, vamos atualizar o `models.py` para definir os modelos de dados:

```python
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    role = db.Column(db.String(20), nullable=False)  # 'admin' ou 'user'

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
    horario = db.relationship('Horario', backref='colaborador', lazy=True)

class Horario(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    colaborador_id = db.Column(db.Integer, db.ForeignKey('colaborador.id'), nullable=False)
    dia_semana = db.Column(db.String(10), nullable=False)
    entrada1 = db.Column(db.Time, nullable=True)
    saida1 = db.Column(db.Time, nullable=True)
    entrada2 = db.Column(db.Time, nullable=True)
    saida2 = db.Column(db.Time, nullable=True)
```

### Atualizar `manage.py` para incluir a função de seed

Vamos adicionar uma função de seed ao `manage.py` para popular o banco de dados com dados iniciais:

```python
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
```

### Atualizar `__init__.py` para importar modelos

Certifique-se de que `app/__init__.py` importa os modelos:

```python
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@db:5432/postgres'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)

from app import models
```

### Executar o Docker Compose e Popular o Banco de Dados

Depois de configurar tudo, siga estes passos para executar o Docker Compose, criar o banco de dados e popular com dados iniciais:

1. Pare e remova quaisquer containers existentes:
   ```sh
   docker compose down -v
   ```

2. Reconstrua a imagem e inicie os containers:
   ```sh
   docker compose up -d --build
   ```

3. Em outra janela de terminal, execute os comandos de criação e seed do banco de dados:
   ```sh
   docker compose exec web flask create_db
   docker compose exec web flask seed_db
   ```

Isso deve criar o banco de dados, adicionar um usuário administrador e dez colaboradores fictícios. Agora, você deve ser capaz de fazer login com o usuário administrador e ver os colaboradores cadastrados.