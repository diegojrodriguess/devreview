-- Permissões nas tabelas da aplicação.
--
-- O schema do DevReview não usa RLS, e no Supabase local isso significava que
-- a anon key tinha acesso total às tabelas. Replicamos exatamente esse
-- comportamento para o frontend continuar funcionando sem alteração.

grant all on all tables    in schema public to anon, authenticated, service_role;
grant all on all sequences in schema public to anon, authenticated, service_role;
grant all on all functions in schema public to anon, authenticated, service_role;

-- Vale também para o que futuras migrations criarem.
alter default privileges in schema public
  grant all on tables to anon, authenticated, service_role;
alter default privileges in schema public
  grant all on sequences to anon, authenticated, service_role;
alter default privileges in schema public
  grant all on functions to anon, authenticated, service_role;

-- Faz o PostgREST recarregar o cache de schema no primeiro boot.
notify pgrst, 'reload schema';
