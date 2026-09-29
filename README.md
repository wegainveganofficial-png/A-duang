# The Secret มู

เว็บเปิดไพ่ยิปซีรายวัน 3 ใบ (ความรัก / การงาน-การเรียน / การเงิน)
เป็นเว็บ static ไฟล์เดียว โฮสต์บน Vercel และใช้ Supabase เก็บสถิติ

## ไฟล์ในโปรเจกต์
- `index.html` ตัวเว็บทั้งหมด
- `config.js` ค่าเชื่อม Supabase (URL + anon key)
- `supabase/schema.sql` สร้างตาราง `readings` + ฟังก์ชัน `today_stats`
- `vercel.json` ตั้งค่า Vercel

## ขั้นที่ 1: ตั้งค่า Supabase (ทำเสร็จแล้ว)
โปรเจกต์ `orldpdisplmplxrrqaan` มีตาราง `readings` และฟังก์ชัน `today_stats` แล้ว และใส่ค่าใน `config.js` แล้ว
ข้อ 1-4 ด้านล่างใช้เฉพาะตอนจะย้ายไปโปรเจกต์ใหม่

1. สร้างโปรเจกต์ที่ https://supabase.com (เลือก region Singapore จะเร็วสุดสำหรับไทย)
2. ไปที่ **SQL Editor** วางไฟล์ `supabase/schema.sql` ทั้งไฟล์ แล้วกด **Run**
3. ไปที่ **Project Settings > API** คัดลอก **Project URL** และ **anon public key**
4. ใส่สองค่านี้ใน `config.js`

## ขั้นที่ 2: Deploy ขึ้น Vercel (เลือกวิธีเดียว)
**วิธี A: ผ่าน GitHub (แนะนำ)**
1. อัปโหลดโฟลเดอร์นี้ขึ้น GitHub repo ใหม่
2. ที่ https://vercel.com/new เลือก Import repo นั้น
3. Framework Preset: **Other** ไม่ต้องตั้ง Build Command กด **Deploy**

**วิธี B: ผ่าน Vercel CLI**
```bash
npm i -g vercel
cd a-duang
vercel --prod
```

## เว็บเก็บอะไรบ้าง
ทุกครั้งที่เปิดไพ่ จะบันทึก: รหัสเครื่องแบบสุ่ม (ไม่ใช่ข้อมูลส่วนตัว), วันที่, ไพ่ 3 ใบ และคะแนนรวม
หน้าเว็บจะแสดง "วันนี้เปิดไพ่แล้ว N คน" และ "ไพ่ฮิตของวันนี้"
ข้อมูลดิบอ่านจากหน้าเว็บไม่ได้ (RLS เปิดให้ insert อย่างเดียว) ดูได้จาก Supabase Dashboard > Table Editor

ถ้า `config.js` เว้นว่าง หรือ Supabase ล่ม เว็บยังเปิดไพ่ได้ปกติ แค่ไม่แสดงสถิติ
