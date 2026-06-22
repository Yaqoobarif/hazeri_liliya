# حاضری لیلیه معرفت — نسخه محافظت‌شده

این سایت با **Supabase** و **GitHub Pages** کار می‌کند. همه می‌توانند گزارش و حاضری را ببینند، اما فقط مدیر واردشده می‌تواند اطلاعات را ثبت یا تغییر دهد.

## ۱) ساخت پروژه Supabase
1. وارد Supabase شو و یک Project رایگان بساز.
2. از **SQL Editor**، تمام متن فایل `supabase-schema.sql` را کپی و Run کن.
3. به **Authentication → Users** برو و با ایمیل خودت یک کاربر مدیر بساز. برای شروع می‌توانی ایمیل را تأییدشده (Auto Confirm User) بسازی.
4. دوباره به **SQL Editor** برو و این را با ایمیل همان مدیر اجرا کن:
   ```sql
   insert into public.app_admins (email) values ('your-email@example.com') on conflict do nothing;
   ```
5. از **Project Settings → API** این دو مورد را بگیر:
   - Project URL
   - anon public key
6. فایل `config.js` را باز کن و دو مقدار را وارد کن.

## ۲) انتشار رایگان با GitHub Pages
1. تمام فایل‌های این فولدر را داخل یک Repository جدید در GitHub آپلود کن.
2. به **Settings → Pages** برو.
3. گزینه **Deploy from a branch** را انتخاب کن.
4. Branch را `main` و Folder را `/root` انتخاب کن و Save بزن.

## ورود مدیر و تغییر رمز
- در سایت روی **ورود مدیر** بزن، ایمیل و رمز حسابی را که در Supabase ساخته‌ای وارد کن.
- بعد از ورود، فقط مدیر می‌تواند لیست شاگردان و حاضری را تغییر بدهد.
- دکمه **تغییر رمز** برای تغییر رمز همان حساب مدیر است.

## نکته امنیتی مهم
کلید `anon public key` در سایت قابل دیدن است و مشکلی ندارد؛ امنیت اصلی توسط قانون‌های RLS در Supabase انجام می‌شود. **هرگز service_role key را داخل `config.js` قرار نده.**
