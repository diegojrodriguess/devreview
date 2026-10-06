#!/bin/sh
# Aplica as migrations de db/migrations/ em ordem e, por último, o seed.
# Equivalente ao que `npx supabase db reset` fazia na stack anterior.
set -e

psql_run() {
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$1"
}

for migration in /devreview/migrations/*.sql; do
  [ -e "$migration" ] || continue
  echo "==> migration: $(basename "$migration")"
  psql_run "$migration"
done

if [ -f /devreview/seed.sql ]; then
  echo "==> seed: seed.sql"
  psql_run /devreview/seed.sql
fi
