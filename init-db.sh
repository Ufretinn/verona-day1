#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER verona WITH ENCRYPTED PASSWORD 'SuperSecret123!';
    CREATE DATABASE verona OWNER verona;
    GRANT ALL PRIVILEGES ON DATABASE verona TO verona;
    \c verona
    CREATE SCHEMA IF NOT EXISTS verona AUTHORIZATION verona;
EOSQL
