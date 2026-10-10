# UI_GUIDELINE.md

Version: 1.0

---

# UI Philosophy

OBS Broadcast Suite bukan aplikasi web.

OBS Broadcast Suite bukan dashboard admin.

OBS Broadcast Suite adalah sekumpulan OBS Dock yang digunakan saat LIVE.

Seluruh desain harus mengutamakan:

- Cepat
- Sederhana
- Ringan
- Mudah dipahami
- Mudah diklik

---

# Design Language

Style

- Flat
- Modern
- Minimal
- Professional

Color

Mengikuti Dark Theme OBS Studio.

Jangan menggunakan warna mencolok kecuali untuk status penting.

---

# OBS Dock Limitation

Seluruh UI harus didesain berdasarkan ukuran Dock OBS.

Target Width

320px

Ideal Width

360px

Maximum Width

420px

Jangan pernah mendesain untuk layar penuh.

---

# General Rules

Satu Dock hanya memiliki satu fungsi.

Contoh:

Running Text Dock

Lower Third Dock

Scene Dock

PPT Dock

Emergency Dock

Jangan menggabungkan semua fitur dalam satu halaman.

---

# Layout Rules

Gunakan layout vertikal.

Contoh:

Title

↓

Input

↓

Option

↓

Action Button

↓

Status

Jangan menggunakan sidebar.

Jangan menggunakan navbar.

Jangan menggunakan dashboard.

---

# Component Spacing

Margin

12px

Gap

8px

Padding

12px

Button Height

40px

Input Height

38px

Border Radius

8px

---

# Typography

Gunakan font system.

Contoh

Segoe UI

Inter (optional)

Sans Serif

Ukuran

Title

16px

Subtitle

14px

Body

13px

Caption

12px

Jangan menggunakan font dekoratif.

---

# Button Rules

Button harus besar.

Mudah diklik.

Gunakan full width apabila memungkinkan.

Contoh

[ SHOW ]

[ HIDE ]

Jangan membuat tombol kecil.

---

# Icon Rules

Gunakan icon seperlunya.

Contoh

▶

■

⚠

🎤

📄

📰

Jangan memenuhi UI dengan icon.

---

# Form Rules

Input harus sederhana.

Contoh

Nama

[................]

Subjudul

[................]

Theme

[ Modern ▼ ]

Jangan membuat form yang rumit.

---

# Running Text Dock

Komponen

Text

Theme

Show Logo

Show Clock

Speed

Show

Hide

Tidak boleh ada pengaturan yang jarang digunakan.

---

# Lower Third Dock

Komponen

Nama

Subjudul

Nama Acara

Theme

Duration

Show

Hide

Durasi = 0 berarti Manual.

---

# Scene Dock

Komponen

Daftar Scene

Scene aktif diberi highlight.

Klik Scene

↓

Langsung berpindah.

Tidak ada tombol Apply.

---

# PPT Dock

Komponen

Slide

Current / Total

Next

Previous

Show

Hide

Tidak menggunakan thumbnail.

Tidak ada preview slide.

---

# Emergency Dock

UI sesederhana mungkin.

Contoh

⚠ Emergency

[ AKTIFKAN ]

[ MATIKAN ]

Tidak ada konfigurasi lain.

---

# Settings Dock

Semua pengaturan yang jarang diubah ditempatkan di sini.

Contoh

Theme

Animation

Folder

Port

Logo

Version

Jangan tampilkan menu ini saat operator LIVE kecuali diperlukan.

---

# Theme Rules

Minimal memiliki

Modern

Minimal

Flat

Islamic

Seluruh theme harus menggunakan sistem yang sama.

Jangan hardcode.

---

# Animation Rules

Durasi

150ms - 250ms

Animasi

Fade

Slide

Scale

Push

Tidak boleh berlebihan.

---

# Color Rules

Primary

OBS Blue

Danger

Red

Success

Green

Warning

Orange

Background

Dark Gray

Border

Dark Gray

Jangan menggunakan terlalu banyak warna.

---

# Status Indicator

Gunakan warna sederhana.

Hijau

Aktif

Abu-abu

Tidak Aktif

Merah

Error

---

# Notification

Gunakan toast kecil.

Posisi

Bottom

atau

Top Right

Jangan menggunakan popup besar.

---

# UX Rules

Operator sedang LIVE.

Semua aksi harus selesai maksimal dua klik.

Contoh

Klik Show

↓

Overlay tampil

Jangan membuat dialog konfirmasi.

Kecuali aksi berbahaya.

---

# Accessibility

Semua tombol minimal

40px

Semua input mudah dibaca.

Kontras warna tinggi.

Tidak menggunakan teks kecil.

---

# Responsive

UI tetap nyaman pada

320px

360px

380px

420px

Lebih kecil dari 320px tetap dapat digunakan.

---

# Forbidden UI

Jangan membuat

Sidebar

Dashboard

Floating Window

Wizard

Stepper

Popup berlapis

Accordion yang terlalu banyak

Nested Menu

Tab lebih dari satu level

---

# Design Principle

Operator tidak punya waktu berpikir.

Operator hanya perlu melihat.

Klik.

Selesai.

Apabila pengguna harus mencari tombol lebih dari 2 detik, maka desain dianggap gagal.

Seluruh UI harus terasa seperti fitur bawaan OBS Studio.

Kesederhanaan selalu lebih penting daripada banyak fitur dalam satu layar.