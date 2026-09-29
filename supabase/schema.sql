-- A ดวง: ตารางเก็บผลเปิดไพ่ + ฟังก์ชันสถิติรายวัน
-- ติดตั้งแล้วในโปรเจกต์ orldpdisplmplxrrqaan (migration: create_readings_and_today_stats)
-- ถ้าจะสร้างโปรเจกต์ใหม่: Supabase Dashboard > SQL Editor > วางทั้งไฟล์แล้วกด Run

create table if not exists public.readings (
  id           bigint generated always as identity primary key,
  device_id    uuid        not null,
  reading_date date        not null,
  love_card    smallint    not null check (love_card  between 0 and 21),
  work_card    smallint    not null check (work_card  between 0 and 21),
  money_card   smallint    not null check (money_card between 0 and 21),
  total_score  smallint    not null check (total_score between 3 and 15),
  created_at   timestamptz not null default now()
);

create index if not exists readings_date_idx on public.readings (reading_date);

-- เปิด RLS: ผู้ใช้ทั่วไป "เขียนได้อย่างเดียว" อ่านข้อมูลดิบไม่ได้
alter table public.readings enable row level security;
revoke select, update, delete, truncate on public.readings from anon, authenticated;
grant insert on public.readings to anon, authenticated;

drop policy if exists "anyone can insert a reading" on public.readings;
create policy "anyone can insert a reading"
  on public.readings for insert
  to anon, authenticated
  -- กันข้อมูลวันที่มั่ว: ต้องเป็นวันนี้ ±1 วัน (เผื่อ timezone)
  with check (reading_date between current_date - 1 and current_date + 1);

-- สถิติของวัน (คืนเฉพาะตัวเลขรวม ไม่เปิดเผยข้อมูลรายคน)
create or replace function public.today_stats(p_date date)
returns json
language sql
stable
security definer
set search_path = public
as $$
  select json_build_object(
    'people',   (select count(distinct device_id) from readings where reading_date = p_date),
    'readings', (select count(*)                  from readings where reading_date = p_date),
    'top_card', (
      select c from (
        select unnest(array[love_card, work_card, money_card]) as c
        from readings where reading_date = p_date
      ) t
      group by c order by count(*) desc, c limit 1
    )
  );
$$;

revoke all on function public.today_stats(date) from public;
grant execute on function public.today_stats(date) to anon, authenticated;
