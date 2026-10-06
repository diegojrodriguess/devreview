# DevReview

Ferramenta de code review assistida por IA — projeto base do Curso 5: MCP, Conectando o Agent ao Mundo Real.

## Stack

- **Frontend:** React 18, TypeScript, Vite, TailwindCSS, shadcn/ui, Redux Toolkit
- **Backend (construído durante o curso):** Node.js, @modelcontextprotocol/sdk, Zod
- **Banco de dados:** PostgreSQL 15 em Docker, com PostgREST + nginx expondo a API e pgAdmin para administração

## Pré-requisitos

- Node.js 20+
- npm 10+
- Docker Desktop (com Docker Compose v2)

## Como rodar

```bash
# 1. Instalar dependências
npm install

# 2. Copiar variáveis de ambiente do frontend
cp apps/web/.env.example apps/web/.env

# 3. Subir o banco e iniciar o frontend
npm run dev
```

`npm run dev` sobe a stack Docker (`npm run db:up`) e depois o Vite. O schema e o
seed são aplicados automaticamente na primeira vez que o container do Postgres
é criado.

| Serviço | URL | Credenciais |
| --- | --- | --- |
| Frontend | http://localhost:5173 | — |
| API REST | http://localhost:54321 | anon key do `.env.example` |
| Postgres | `localhost:54322` | `postgres` / `postgres` |
| pgAdmin | http://localhost:54323 | `admin@devreview.com` / `admin` |

As portas são as mesmas que o `supabase start` publicava, então o
`@supabase/supabase-js` do frontend e do mcp-server continua funcionando sem
nenhuma alteração de código ou de variável de ambiente. Dois detalhes fazem isso
valer:

- O `:54321` é um nginx que traduz o prefixo `/rest/v1` usado pelo supabase-js
  para a raiz do PostgREST — o mesmo papel que o Kong cumpria no Supabase.
- O PostgREST valida os JWTs com o mesmo segredo do Supabase local, então as
  `anon` e `service_role` keys que já estão nos `.env.example` seguem válidas, e
  o claim `role` de cada uma é aplicado via `SET ROLE` no Postgres.

O que o Supabase oferecia e esta stack não cobre: Auth (GoTrue), Storage,
Realtime e o Inbucket (`:54324`). O projeto não usa nenhum deles — só queries
REST nas tabelas.

No pgAdmin a conexão **DevReview (local)** já vem cadastrada; ao expandi-la pela
primeira vez ele pede a senha do Postgres (`postgres`).

## Scripts do banco

```bash
npm run db:up      # sobe postgres + postgrest + api + pgadmin (build incluso)
npm run db:down    # para os containers, preservando os dados
npm run db:reset   # apaga o volume e recria do zero (reaplica schema + seed)
npm run db:logs    # acompanha os logs da stack
npm run db:psql    # abre um psql no container do Postgres
```

## Estrutura

```
devreview/
├── apps/
│   ├── web/          # Frontend React
│   └── mcp-server/   # MCP Server (construído durante o curso)
├── db/
│   ├── migrations/   # Schema, aplicado em ordem no primeiro boot
│   └── seed.sql      # Dados de exemplo
├── docker/
│   ├── postgres/     # Dockerfile do Postgres e scripts de inicialização
│   ├── nginx/        # Gateway da API (prefixo /rest/v1 → PostgREST)
│   └── pgadmin/      # Conexão pré-cadastrada no pgAdmin
├── docker-compose.yml
└── docs/             # Documentação do curso (gitignored)
```

## Novas migrations

Crie o arquivo em `db/migrations/` com o prefixo numérico seguinte
(`00002_...sql`). Os scripts de init só rodam quando o volume está vazio, então
para aplicar use `npm run db:reset`, ou rode o SQL direto via `npm run db:psql`
se quiser preservar os dados.
