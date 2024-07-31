
### 2. Suba os Contêineres com Docker Compose

Depois de criar a estrutura do projeto, você precisa subir os contêineres Docker. Na raiz do seu projeto (onde está o arquivo `docker-compose.yml`), execute o seguinte comando:

```bash
docker compose up -d --build
```

Este comando irá:

- Construir a imagem Docker para o seu serviço web.
- Iniciar os contêineres web e db (PostgreSQL).

### 3. Inicialize o Banco de Dados

Após subir os contêineres, você precisa criar as tabelas no banco de dados. Para isso, abra outro terminal e execute o seguinte comando para acessar o contêiner web:

```bash
docker compose exec web flask db init
docker compose exec web flask db migrate -m "Initial migration."
docker compose exec web flask db upgrade
```

Esses comandos irão:

- Inicializar o diretório de migrações.
- Criar uma migração inicial para o banco de dados.
- Aplicar a migração ao banco de dados, criando as tabelas definidas em `models.py`.

### 4. Acesse a Aplicação

Depois de inicializar o banco de dados, a aplicação estará rodando no endereço:

```
http://localhost:5000
```

### 5. Parar os Contêineres

Para parar os contêineres, você pode usar `Ctrl + C` no terminal onde está rodando o `docker compose up`. Alternativamente, em outro terminal, você pode executar:

```bash
docker compose down
```

Este comando irá parar e remover todos os contêineres, redes e volumes definidos no `docker-compose.yml`.

Seguindo esses passos, sua aplicação web estará rodando e acessível via navegador. Se precisar de mais alguma coisa, estou à disposição!


---

# Populando o DB

Para inserir colaboradores de teste na aplicação, você pode seguir os passos abaixo. Vamos utilizar o Flask CLI e o SQLAlchemy para adicionar registros ao banco de dados diretamente do terminal.

### 1. Adicionar Função de Script para Inserir Dados

Primeiro, vamos criar um script para inserir colaboradores de teste. Adicione um arquivo `insert_data.py` na pasta `app` com o seguinte conteúdo:

```python
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
            usuario='joao_silva'
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
            usuario='maria_oliveira'
        )
    ]

    db.session.bulk_save_objects(colaboradores)
    db.session.commit()
    print('Colaboradores inseridos com sucesso!')
```

### 2. Atualizar `Dockerfile` e `docker-compose.yml`

Certifique-se de que o seu `Dockerfile` e `docker-compose.yml` estão configurados para permitir a execução de comandos personalizados. Adicione o seguinte ao seu `Dockerfile` para instalar dependências e copiar scripts:

```Dockerfile
# Dockerfile

# outras linhas...

COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
```

### 3. Executar o Script

Agora, você pode executar o script diretamente no contêiner Docker. Utilize o comando abaixo para entrar no contêiner e rodar o script:

```bash
docker-compose exec web python app/insert_data.py
```

### 4. Confirmar a Inserção

Você pode confirmar que os colaboradores foram inseridos acessando a rota de listagem de colaboradores na sua aplicação. 

### Atualização do Script

Certifique-se de que os modelos e a configuração do aplicativo estão corretos. O modelo `Colaborador` deve estar definido em `app/models.py`. Aqui está um exemplo básico:

```python
# app/models.py

from app import db

class Colaborador(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    cpf = db.Column(db.String(11), unique=True, nullable=False)
    nome = db.Column(db.String(100), nullable=False)
    data_nascimento = db.Column(db.Date, nullable=False)
    data_admissao = db.Column(db.Date, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    cargo = db.Column(db.String(50), nullable=False)
    funcao = db.Column(db.String(50), nullable=False)
    data_rescisao = db.Column(db.Date, nullable=True)
    usuario = db.Column(db.String(100), unique=True, nullable=False)
```

### Passo a Passo Completo

1. **Criar o Script de Inserção de Dados (`insert_data.py`)**
2. **Atualizar o Dockerfile para Incluir Dependências e Scripts**
3. **Entrar no Contêiner Docker e Executar o Script**
4. **Confirmar a Inserção de Dados na Aplicação**

Seguindo esses passos, você deve ser capaz de inserir colaboradores de teste na sua aplicação sem problemas. Se precisar de mais assistência ou houver algum erro, sinta-se à vontade para perguntar!