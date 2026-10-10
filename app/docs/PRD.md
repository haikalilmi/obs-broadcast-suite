# PRD — OBS Broadcast Suite

Version: 1.0  
Status: Draft  
Author: Haikal Ilmi

---

# 1. Project Overview

OBS Broadcast Suite adalah plugin broadcast profesional berbasis **Lua + HTML + CSS + JavaScript** yang berjalan sepenuhnya di dalam OBS Studio.

Project ini dirancang khusus untuk memudahkan operator saat menjalankan acara seperti:

- Pengajian
- Seminar
- Wisuda
- Haflah
- Muktamar
- Live Streaming Pondok Pesantren
- Acara Sekolah
- Event Organisasi

Seluruh kontrol dilakukan melalui OBS menggunakan **Lua Script** dan **Custom Browser Dock** tanpa memerlukan aplikasi eksternal.

---

# 2. Vision

Membuat pengalaman broadcast di OBS menjadi lebih profesional, sederhana, cepat, dan nyaman digunakan oleh operator dengan meminimalkan jumlah klik saat live.

Target utama adalah membuat plugin yang terasa seperti fitur bawaan OBS Studio.

---

# 3. Goals

- 100% berjalan di dalam OBS
- Tidak memerlukan Python
- Tidak memerlukan Electron
- Tidak memerlukan aplikasi desktop tambahan
- Offline First
- Zero Dependency
- Mudah digunakan operator pemula
- UI sederhana
- Responsif
- Ringan

---

# 4. Technical Stack

## Backend

- Lua
- OBS Lua API
- WebSocket

## Frontend

- HTML5
- CSS3
- Vanilla JavaScript

## Overlay

Semua overlay WAJIB menggunakan Browser Source.

Tidak diperbolehkan menggunakan Text Source OBS sebagai sistem utama.

---

# 5. Architecture

Custom Browser Dock

↓

WebSocket

↓

Lua

↓

OBS API

↓

Browser Source

Semua komunikasi antara UI dan OBS dilakukan melalui WebSocket.

Lua menjadi pusat kontrol seluruh sistem.

---

# 6. Core Modules

Project hanya memiliki 5 modul utama.

## 1. Running Text

### Features

- Edit teks berjalan
- Multiple theme
- Show / Hide logo
- Show / Hide jam
- Ubah kecepatan
- Start
- Stop

### Theme

Minimal terdapat beberapa tema bawaan:

- Modern
- Minimal
- Islamic
- Flat

---

## 2. Lower Third

### Features

- Edit nama pembicara
- Edit jabatan / subjudul
- Edit nama acara
- Pilih tema
- Show
- Hide

### Duration

Jika durasi

> 0

Maka otomatis hide.

Jika

= 0

Maka tampil sampai tombol Hide ditekan.

---

## 3. Scene Switcher

### Features

Menampilkan daftar seluruh Scene OBS.

Operator cukup klik nama Scene.

Scene langsung berpindah.

Perpindahan harus menggunakan Transition OBS yang sedang aktif.

Tidak diperlukan tombol Apply.

---

## 4. PPT Controller

### Features

- Show PPT
- Hide PPT
- Next Slide
- Previous Slide

Slide menggunakan kumpulan image.

Pergantian slide harus memiliki animasi.

Contoh animasi:

- Fade
- Slide
- Push

Tidak perlu thumbnail.

Tidak perlu editor PPT.

---

## 5. Emergency Mode

Saat tombol Emergency ditekan:

- Berpindah ke Scene Emergency
- Menampilkan TV Color Bar / Noise
- Menampilkan tulisan

"Mohon Maaf
Sedang Terjadi Gangguan Teknis"

Emergency dapat dimatikan kapan saja.

---

# 7. UI Guidelines

Seluruh UI dibuat khusus untuk ukuran OBS Dock.

JANGAN membuat layout seperti aplikasi desktop.

## Dock Width

320px - 380px

## Theme

Dark Mode

Mengikuti tampilan OBS.

## Style

- Flat
- Minimal
- Modern
- Clean

## Rules

One Feature = One Dock

Tidak ada sidebar.

Tidak ada dashboard besar.

Tidak ada floating window.

Tidak ada popup yang tidak diperlukan.

---

# 8. User Experience Rules

Operator harus dapat menjalankan fitur maksimal dalam dua klik.

Contoh:

Scene

Klik Scene

↓

Done

Lower Third

Klik Show

↓

Done

Emergency

Klik Emergency

↓

Done

---

# 9. Browser Source Rules

Semua tampilan visual WAJIB dibuat menggunakan HTML.

Contoh:

- Running Text
- Lower Third
- PPT
- Emergency

Animasi menggunakan CSS.

Tidak menggunakan plugin animasi tambahan.

---

# 10. Performance Rules

Harus ringan.

Target:

- Startup cepat
- RAM kecil
- CPU rendah

Tidak boleh ada polling berlebihan.

Gunakan event jika memungkinkan.

---

# 11. Installation

User hanya melakukan:

1.

OBS

↓

Tools

↓

Scripts

↓

Add Lua

2.

OBS

↓

Docks

↓

Custom Browser Dock

↓

Tambahkan Dock

Selesai.

Tidak ada instalasi tambahan.

---

# 12. Project Structure

obs-broadcast-suite/

├── lua/

├── dock/

├── browser-source/

├── themes/

├── config/

├── data/

├── docs/

└── README.md

---

# 13. Non Functional Requirements

Harus:

- Offline
- Cepat
- Stabil
- Mudah dipelajari
- Mudah dikembangkan
- Mudah menambah tema baru

---

# 14. Constraints

JANGAN menggunakan:

- Python
- Electron
- React
- Vue
- Angular
- Node Runtime
- Express
- Database Server

WAJIB menggunakan:

- Lua
- HTML
- CSS
- JavaScript
- Browser Source
- OBS Lua API
- WebSocket

---

# 15. Future Features (Out of Scope)

Fitur berikut TIDAK dibuat pada versi pertama:

- Countdown
- Live Score
- Ayat Al-Qur'an
- Hadits Overlay
- Auto Rundown
- Audio Mixer
- Camera Controller
- Stream Deck Support
- NDI Controller

---

# 16. Success Criteria

Project dianggap berhasil apabila:

- Berjalan sepenuhnya di OBS Studio
- Tidak membutuhkan software tambahan
- Semua modul berjalan melalui Lua + Browser Dock
- Semua overlay menggunakan Browser Source
- UI nyaman digunakan pada OBS Dock
- Operator dapat mengoperasikan fitur dengan sangat cepat saat live
- Struktur project mudah dikembangkan untuk versi berikutnya

---

# 17. Design Philosophy

OBS Broadcast Suite bukan sekadar kumpulan script Lua.

Project ini harus terasa seperti plugin profesional yang menjadi bagian dari OBS Studio.

Semua interaksi pengguna berlangsung di dalam OBS.

Fokus utama adalah:

- Kesederhanaan
- Kecepatan
- Stabilitas
- Kemudahan operator
- Tampilan modern
- Pengalaman penggunaan yang natural

Setiap keputusan desain harus selalu mengutamakan kemudahan operator saat siaran langsung.