#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z "$SQL_HOST" "$SQL_PORT"; do
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
