#!/bin/sh
# Roles que o Supabase provisiona e que o PostgREST espera encontrar.
#
# O PostgREST conecta como `authenticator` (o único role com LOGIN) e faz
# SET ROLE para anon / authenticated / service_role conforme o claim "role"
# do JWT enviado pelo @supabase/supabase-js.
set -e

: "${AUTHENTICATOR_PASSWORD:?AUTHENTICATOR_PASSWORD não definida (ver docker-compose.yml)}"

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" \
     --dbname "$POSTGRES_DB" \
     -v authenticator_password="$AUTHENTICATOR_PASSWORD" <<'SQL'
create role anon          nologin noinherit;
create role authenticated nologin noinherit;
create role service_role  nologin noinherit bypassrls;

create role authenticator login noinherit password :'authenticator_password';

grant anon, authenticated, service_role to authenticator;

-- Acesso ao schema público. As tabelas em si são liberadas no 90-grants.sql,
-- depois que as migrations rodaram.
grant usage on schema public to anon, authenticated, service_role;
SQL
