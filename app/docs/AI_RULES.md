# AI_RULES.md

Version: 1.0

---

# AI Development Rules

Semua implementasi WAJIB mengikuti aturan pada file ini.

Apabila terdapat konflik antara implementasi dengan aturan berikut, maka aturan dalam file ini memiliki prioritas lebih tinggi.

---

# Project Identity

Nama Project:

OBS Broadcast Suite

Tujuan utama:

Membangun plugin broadcast profesional untuk OBS Studio menggunakan Lua dan Browser Dock tanpa aplikasi tambahan.

---

# Golden Rules

## Rule 1

Seluruh sistem harus berjalan langsung di dalam OBS Studio.

Tidak boleh membutuhkan software tambahan.

---

## Rule 2

Seluruh kontrol dilakukan melalui Browser Dock.

Tidak boleh membuat window desktop terpisah.

---

## Rule 3

Lua adalah backend utama.

Browser Dock hanyalah user interface.

---

## Rule 4

Seluruh komunikasi UI ↔ Lua menggunakan WebSocket.

Jangan menggunakan metode komunikasi lain kecuali benar-benar diperlukan.

---

## Rule 5

Semua overlay WAJIB menggunakan Browser Source HTML.

Jangan menggunakan Text Source OBS sebagai sistem utama.

---

# Forbidden Technologies

JANGAN menggunakan:

- Python
- Electron
- Tauri
- React
- Vue
- Angular
- Svelte
- Next.js
- Nuxt
- Express
- Fastify
- Flask
- Django
- Node Runtime
- Docker
- PostgreSQL
- MySQL
- MongoDB
- Redis

Project harus tetap sederhana.

---

# Allowed Technologies

Backend

- Lua
- OBS Lua API

Frontend

- HTML
- CSS
- Vanilla JavaScript

Communication

- WebSocket

Storage

- JSON

---

# UI Philosophy

UI dibuat khusus untuk OBS Dock.

Bukan aplikasi desktop.

Jangan membuat dashboard besar.

Jangan membuat sidebar.

Jangan membuat floating window.

Jangan membuat popup yang tidak penting.

---

# Dock Rules

Satu Dock hanya memiliki satu tanggung jawab.

Contoh:

Running Text Dock

Lower Third Dock

Scene Dock

PPT Dock

Emergency Dock

Jangan menggabungkan semua fitur ke dalam satu Dock.

---

# UI Principles

Selalu utamakan:

- Minimal
- Flat
- Modern
- Clean
- Dark

Ikuti tampilan OBS Studio.

---

# UX Principles

Operator sedang LIVE.

Setiap klik sangat berharga.

Semua aksi harus selesai maksimal dua klik.

Contoh yang benar:

Klik Scene

↓

Scene berubah

Contoh yang salah:

Klik Scene

↓

Klik Apply

↓

Klik OK

↓

Scene berubah

---

# Performance Rules

Selalu utamakan performa.

Hindari:

- polling berlebihan
- loop yang tidak perlu
- DOM manipulation berlebihan
- memory leak

Gunakan event apabila memungkinkan.

---

# Browser Source Rules

Semua animasi menggunakan CSS.

Contoh:

Fade

Slide

Scale

Push

Jangan menggunakan library animasi.

---

# Theme Rules

Setiap overlay harus mendukung Theme.

Minimal:

Modern

Minimal

Flat

Islamic

Theme harus mudah ditambah.

Jangan hardcode.

---

# Config Rules

Semua konfigurasi disimpan pada JSON.

Contoh:

config.json

theme.json

runningtext.json

lowerthird.json

settings.json

Jangan menggunakan database.

---

# Coding Style

Gunakan:

Clean Code

SOLID apabila relevan

Reusable

Modular

Readable

Maintainable

Hindari file berukuran ribuan baris.

Pisahkan berdasarkan tanggung jawab.

---

# Lua Rules

Pisahkan module.

Contoh:

scene.lua

ppt.lua

runningtext.lua

lowerthird.lua

websocket.lua

config.lua

utils.lua

Jangan membuat seluruh kode di satu file.

---

# JavaScript Rules

Gunakan:

Vanilla JavaScript

ES6+

Pisahkan:

api.js

websocket.js

theme.js

components/

pages/

Jangan membuat satu file JS berukuran sangat besar.

---

# CSS Rules

Gunakan CSS Variables.

Contoh:

--primary

--background

--text

--border

Gunakan Flexbox.

Gunakan Grid bila diperlukan.

Hindari hardcode.

---

# File Naming

Gunakan:

kebab-case

Contoh:

running-text.js

theme-manager.js

ppt-controller.js

---

# Error Handling

Semua error harus ditampilkan dengan jelas.

Jangan membuat aplikasi crash.

Apabila WebSocket putus:

- tampilkan status
- reconnect otomatis

---

# Logging

Gunakan logging seperlunya.

Jangan memenuhi console.

Gunakan level:

INFO

WARNING

ERROR

---

# Security

Jangan menggunakan eval().

Jangan menjalankan JavaScript dari input pengguna.

Validasi seluruh data WebSocket.

---

# Accessibility

Button harus cukup besar.

Minimal tinggi:

40px

Jarak antar button cukup.

Operator harus dapat mengklik dengan cepat.

---

# Responsive

UI harus tetap nyaman pada Dock OBS.

Target lebar:

320px

360px

380px

Jangan mendesain untuk layar penuh.

---

# Animation Rules

Animasi maksimal:

250ms

Harus terasa halus.

Tidak boleh mengganggu operator.

---

# Project Structure

obs-broadcast-suite/

lua/

dock/

browser-source/

themes/

config/

data/

docs/

README.md

Jangan mengubah struktur ini tanpa alasan kuat.

---

# Documentation Rules

Setiap module harus memiliki komentar yang cukup.

Fungsi publik harus memiliki dokumentasi.

---

# Code Quality Checklist

Sebelum membuat kode, AI harus selalu bertanya:

Apakah kode ini sederhana?

Apakah bisa dibuat lebih modular?

Apakah bisa dipakai ulang?

Apakah sesuai filosofi OBS?

Apakah operator dapat menggunakannya saat LIVE tanpa berpikir lama?

Jika jawabannya tidak, maka desain harus diperbaiki.

---

# Primary Goal

OBS Broadcast Suite harus terasa seperti plugin bawaan OBS Studio.

Bukan seperti aplikasi web yang dipindahkan ke dalam OBS.

Seluruh keputusan desain dan implementasi harus selalu mengutamakan:

- Kesederhanaan
- Kecepatan
- Stabilitas
- Kemudahan operator
- Performa
- Pengalaman penggunaan yang profesional

Apabila AI ragu dalam mengambil keputusan implementasi, selalu pilih solusi yang paling sederhana, paling ringan, dan paling mudah dipelihara.