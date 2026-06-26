alter table public.config
  add column if not exists raduno_visible boolean not null default true;

alter table public.partners
  add column if not exists url text;

alter table public.partners
  add column if not exists logo_url text;

alter table public.partners
  add column if not exists active boolean not null default true;

alter table public.partners
  add column if not exists sort_order integer not null default 0;

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

grant usage on schema public to anon, authenticated;
grant insert on table public.hub_subscribers to anon, authenticated;

drop policy if exists "Hub subscribers can insert" on public.hub_subscribers;
create policy "Hub subscribers can insert"
  on public.hub_subscribers
  for insert
  to anon, authenticated
  with check (true);

grant select, insert, update, delete on table public.partners to anon, authenticated;

drop policy if exists "Partners public read" on public.partners;
create policy "Partners public read"
  on public.partners
  for select
  to anon, authenticated
  using (true);

drop policy if exists "Partners admin manage" on public.partners;
create policy "Partners admin manage"
  on public.partners
  for all
  to anon, authenticated
  using (true)
  with check (true);

insert into public.partners (name, tag, description, logo_url, url, active, sort_order)
select 'Desmoblood', 'Community', 'Ducati lover', 'https://drivenode.netlify.app/assets/desmoblood.jpeg', 'https://desmoblood.com', true, 10
where not exists (select 1 from public.partners where lower(name) = 'desmoblood');

insert into public.partners (name, tag, description, logo_url, url, active, sort_order)
select 'Elatos', 'Software', 'Software gestionale', 'https://drivenode.netlify.app/assets/elatos.png', 'https://elatos.net/software-gestionale-index.html', true, 20
where not exists (select 1 from public.partners where lower(name) = 'elatos');

insert into public.partners (name, tag, description, logo_url, url, active, sort_order)
select 'Bilux Tech', 'Partner', '', 'https://drivenode.netlify.app/assets/bilux.svg', 'https://biluxtech.com', true, 30
where not exists (select 1 from public.partners where lower(name) like 'bilux%');
