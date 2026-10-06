# Postgres do DevReview — substitui o `supabase start` da stack original.
# A imagem já sobe com extensões, roles, schema e seed aplicados.
FROM postgres:15-alpine

# Supabase local roda em UTC; manter igual evita divergência nos timestamptz.
ENV TZ=UTC
ENV PGTZ=UTC

# Scripts executados pelo entrypoint oficial na ordem alfabética, apenas no
# primeiro boot (quando o volume de dados está vazio).
COPY docker/postgres/init/00-extensions.sql /docker-entrypoint-initdb.d/00-extensions.sql
COPY docker/postgres/init/01-roles.sh       /docker-entrypoint-initdb.d/01-roles.sh
COPY docker/postgres/init/10-migrations.sh  /docker-entrypoint-initdb.d/10-migrations.sh
COPY docker/postgres/init/90-grants.sql     /docker-entrypoint-initdb.d/90-grants.sql

# As migrations ficam fora de /docker-entrypoint-initdb.d porque o entrypoint
# não varre subdiretórios: o 10-migrations.sh aplica uma a uma, em ordem.
COPY db/migrations/ /devreview/migrations/
COPY db/seed.sql    /devreview/seed.sql

RUN chmod +x /docker-entrypoint-initdb.d/01-roles.sh /docker-entrypoint-initdb.d/10-migrations.sh

EXPOSE 5432
