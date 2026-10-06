-- Extensões que o Supabase local já traz habilitadas e que o schema usa.
-- Em PG15 gen_random_uuid() é nativo, mas pgcrypto mantém paridade com o
-- Supabase para as demais funções de hash/criptografia.
create extension if not exists pgcrypto;
create extension if not exists "uuid-ossp";
