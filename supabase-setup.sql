-- Run this entire script once in Supabase: SQL Editor > New query > Run

create table if not exists public.tournament_state (
  id text primary key,
  players jsonb not null,
  results jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

insert into public.tournament_state (id, players, results)
values (
  'ibach-2026',
  '["Laura","Sarah","Pam","Shannon","Sloane","Alina","Reagan","Avery","Jeff","Josh","Jason","Kelly","Ricardo","Gage","Cael","Ellis"]'::jsonb,
  '{}'::jsonb
)
on conflict (id) do nothing;

alter table public.tournament_state enable row level security;

drop policy if exists "Anyone can view the bracket" on public.tournament_state;
create policy "Anyone can view the bracket"
on public.tournament_state
for select
to anon, authenticated
using (true);

drop policy if exists "Signed-in admin can update bracket" on public.tournament_state;
create policy "Signed-in admin can update bracket"
on public.tournament_state
for update
to authenticated
using (id = 'ibach-2026')
with check (id = 'ibach-2026');

grant select on public.tournament_state to anon, authenticated;
grant update on public.tournament_state to authenticated;

-- Enable live browser updates. If this reports that the table is already
-- in the publication, that is harmless.
alter publication supabase_realtime add table public.tournament_state;
