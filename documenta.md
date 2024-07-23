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

3. Acesse a aplicação em [http://localhost:5000](http://localhost:5000).

4. docker compose exec db psql --username=user --dbname=colaboradores_db


$ docker-compose exec db psql --username=hello_flask --dbname=hello_flask_dev

psql (13.11)
Type "help" for help.

colaboradores_db=# \l
                                 List of databases
       Name       | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
------------------+-------+----------+------------+------------+-------------------
 colaboradores_db | user  | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres         | user  | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0        | user  | UTF8     | en_US.utf8 | en_US.utf8 | =c/user          +
                  |       |          |            |            | user=CTc/user
 template1        | user  | UTF8     | en_US.utf8 | en_US.utf8 | =c/user          +
                  |       |          |            |            | user=CTc/user
(4 rows)

hello_flask_dev=# \c colaboradores_db
You are now connected to database "colaboradores_db" as user "user".

hello_flask_dev=# \dt
          List of relations
 Schema | Name  | Type  |    Owner
--------+-------+-------+-------------
 public | users | table | hello_flask
(1 row)

hello_flask_dev=# \q
You can check that the volume was created as well by running:

$ docker volume inspect flask-on-docker_postgres_data



5. Em outra janela de terminal, execute os comandos de criação e seed do banco de dados:
   ```sh
   
   pip install python-dotenv

   docker compose exec web python manage.py create_db
   docker compose exec web python manage.py seed_db
   ```

Isso deve criar o banco de dados, adicionar um usuário administrador e dez colaboradores fictícios. Agora, você deve ser capaz de fazer login com o usuário administrador e ver os colaboradores cadastrados.