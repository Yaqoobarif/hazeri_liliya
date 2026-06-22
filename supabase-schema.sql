-- این کد را در Supabase > SQL Editor یک‌جا اجرا کن
-- مرحله ۱: ساخت جدول‌ها
create table if not exists public.students (
  id bigint primary key,
  number integer not null,
  name text not null,
  active boolean not null default true,
  created_at timestamptz default now(),
  archived_at timestamptz
);

create table if not exists public.attendance_records (
  id text primary key,
  student_id bigint not null references public.students(id) on update cascade,
  student_number integer not null,
  student_name text not null,
  status text not null check (status in ('present', 'absent', 'leave')),
  date date not null,
  time text,
  timestamp timestamptz default now()
);

-- فقط ایمیل‌های موجود در این جدول مدیر هستند.
create table if not exists public.app_admins (
  email text primary key,
  created_at timestamptz default now()
);

create index if not exists attendance_records_date_idx on public.attendance_records(date);
create index if not exists attendance_records_student_date_idx on public.attendance_records(student_id, date);

alter table public.students enable row level security;
alter table public.attendance_records enable row level security;
alter table public.app_admins enable row level security;

-- پاک‌سازی policyهای نسخه قبلی
 drop policy if exists "public read students" on public.students;
 drop policy if exists "public write students" on public.students;
 drop policy if exists "public read records" on public.attendance_records;
 drop policy if exists "public write records" on public.attendance_records;
 drop policy if exists "anyone can see own admin status" on public.app_admins;
 drop policy if exists "public read students" on public.students;
 drop policy if exists "manager changes students" on public.students;
 drop policy if exists "public read records" on public.attendance_records;
 drop policy if exists "manager changes records" on public.attendance_records;

-- همه فقط می‌توانند اطلاعات را ببینند؛ تغییر فقط برای ایمیل مدیر ممکن است.
create policy "public read students" on public.students for select to anon, authenticated using (true);
create policy "public read records" on public.attendance_records for select to anon, authenticated using (true);

-- کاربر واردشده فقط می‌تواند وضعیت مدیر بودنِ خودش را ببیند.
create policy "anyone can see own admin status" on public.app_admins
  for select to authenticated using (email = (auth.jwt() ->> 'email'));

create policy "manager changes students" on public.students
  for all to authenticated
  using (exists (select 1 from public.app_admins a where a.email = (auth.jwt() ->> 'email')))
  with check (exists (select 1 from public.app_admins a where a.email = (auth.jwt() ->> 'email')));

create policy "manager changes records" on public.attendance_records
  for all to authenticated
  using (exists (select 1 from public.app_admins a where a.email = (auth.jwt() ->> 'email')))
  with check (exists (select 1 from public.app_admins a where a.email = (auth.jwt() ->> 'email')));

-- مرحله ۲: نخست در Supabase > Authentication > Users یک کاربر مدیر بساز.
-- سپس ایمیل همان کاربر را در خط زیر جای‌گزین و اجرا کن:
-- insert into public.app_admins (email) values ('your-admin-email@example.com') on conflict do nothing;
