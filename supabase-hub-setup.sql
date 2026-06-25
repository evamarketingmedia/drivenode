alter table public.config
  add column if not exists raduno_visible boolean not null default true;

alter table public.partners
  add column if not exists url text;

create table if not exists public.hub_subscribers (
  id uuid primary key default gen_random_uuid(),
  first_name text not null,
  last_name text not null,
  team text,
  email text not null,
  source text not null default 'hub',
  created_at timestamptz not null default now()
);

create unique index if not exists hub_subscribers_email_key
  on public.hub_subscribers (lower(email));

alter table public.hub_subscribers enable row level security;

drop policy if exists "Hub subscribers can insert" on public.hub_subscribers;
create policy "Hub subscribers can insert"
  on public.hub_subscribers
  for insert
  to anon
  with check (true);
