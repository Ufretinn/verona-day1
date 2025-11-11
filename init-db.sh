#!/bin/bash
set -e

# УБИВАЕМ ВОПРОС ПРО ЧАСОВОЙ ПОЯС НАВСЕГДА
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export TZ=Europe/Warsaw

# Принудительно создаём кластер с нужными параметрами
pg_dropcluster --stop 14 main 2>/dev/null || true
pg_createcluster --start -o "-c lc-collate=C" -o "-c lc-ctype=C" -o "-c locale=C.UTF-8" 14 main

# Создаём пользователя и базу
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER verona WITH ENCRYPTED PASSWORD 'SuperSecret123!';
    CREATE DATABASE verona OWNER verona;
    GRANT ALL PRIVILEGES ON DATABASE verona TO verona;
    \c verona
    CREATE SCHEMA IF NOT EXISTS verona AUTHORIZATION verona;
EOSQL

echo "Verona DB created with Europe/Warsaw"
