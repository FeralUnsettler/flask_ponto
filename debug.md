Com a configuração que você forneceu, aqui estão os passos para garantir que as migrações e o banco de dados sejam configurados corretamente. Vou detalhar a configuração e execução passo a passo.

### Estrutura do Projeto

Assegure-se de que a estrutura do projeto esteja similar a essa:

```
your_project/
│
├── app/
│   ├── __init__.py
│   ├── models.py
│   ├── routes.py
│   ├── config.py
│   ├── templates/
│   └── static/
│
├── migrations/
│
├── Dockerfile
├── entrypoint.sh
├── manage.py
└── requirements.txt
```

### `__init__.py`

Seu `__init__.py` parece correto. O arquivo deve ser assim:

```python
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

app = Flask(__name__)
app.config.from_object("app.config.Config")

db = SQLAlchemy(app)
migrate = Migrate(app, db)

from . import routes, models

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

### `config.py`

Você precisa de um arquivo `config.py` para armazenar as configurações do Flask. O arquivo deve ser assim:

```python
class Config:
    SQLALCHEMY_DATABASE_URI = 'postgresql://user:password@db:5432/database'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
```

### `requirements.txt`

Assegure-se de que o `requirements.txt` contenha as dependências necessárias:

```
Flask
Flask-SQLAlchemy
Flask-Migrate
psycopg2-binary
```

### `manage.py`

Seu `manage.py` deve ser assim:

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
    admin1 = User(username="admin1", email="admin1@example.com", password="admin123", admin=True)
    db.session.add(admin)
    
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

### `entrypoint.sh`

Seu `entrypoint.sh` deve ser assim:

```sh
#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

# Executar migrações
flask db upgrade

# Criar tabelas e popular o banco de dados
python manage.py create_db
python manage.py seed_db

exec "$@"
```

### `Dockerfile`

Seu `Dockerfile` deve ser assim:

```Dockerfile
FROM python:3.10-alpine

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . /app/

# Install netcat for checking PostgreSQL readiness
RUN apk add --no-cache netcat-openbsd

# Make entrypoint.sh executable
RUN chmod +x /app/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

# Command to run the application
CMD ["flask", "run", "--host=0.0.0.0"]
```

### Migrações

Para garantir que as migrações estejam configuradas corretamente, você precisa inicializar e aplicar as migrações.

Dentro do contêiner Docker, execute:

```sh
flask db init
flask db migrate -m "Initial migration"
flask db upgrade
```

### `docker-compose.yml`

Certifique-se de que seu `docker-compose.yml` esteja configurado corretamente para iniciar os serviços:

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
      - DATABASE=postgres
      - SQL_HOST=db
      - SQL_PORT=5432
    depends_on:
      - db

  db:
    image: postgres:13
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: database
    ports:
      - "5432:5432"
```

### Conclusão

Depois de configurar todos os arquivos e iniciar os contêineres, o sistema deve estar funcionando corretamente. As tabelas do banco de dados devem ser criadas e populadas sem erros.

Inicie os contêineres com:

```sh
docker-compose up --build
```

Se precisar de mais alguma coisa, por favor, avise!



---


### [chatgpt debug link]
(https://chatgpt.com/share/db765ff0-67e1-47b4-8ecc-eadc57be7f10)
---

