-- ============================================================
-- BANGU 2030 | Gestão de Bares — Configuração da nuvem (Supabase)
-- Rode este script uma única vez em: SQL Editor > New query > Run
-- ============================================================

-- Tabela única de sincronização: cada registro do app vira uma linha.
create table if not exists public.bangu_registros (
  id         text primary key,          -- ex.: "vendas::v-abc123"
  tipo       text not null,             -- coleção: produtos, vendas, jogos…
  dados      jsonb not null,            -- o registro completo
  updated_at timestamptz not null default now()
);

create index if not exists bangu_registros_tipo_idx on public.bangu_registros (tipo);
create index if not exists bangu_registros_upd_idx  on public.bangu_registros (updated_at);

-- Segurança (RLS): habilita e permite acesso via chave anon.
-- O app é de uso interno; a "senha" da operação é manter a chave anon privada.
-- Para maior segurança no futuro: crie usuários no Supabase Auth e troque
-- estas políticas por "to authenticated".
alter table public.bangu_registros enable row level security;

drop policy if exists "bangu_select" on public.bangu_registros;
drop policy if exists "bangu_insert" on public.bangu_registros;
drop policy if exists "bangu_update" on public.bangu_registros;

create policy "bangu_select" on public.bangu_registros for select using (true);
create policy "bangu_insert" on public.bangu_registros for insert with check (true);
create policy "bangu_update" on public.bangu_registros for update using (true);
