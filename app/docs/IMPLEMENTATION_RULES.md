# IMPLEMENTATION_RULES.md

Version: 1.0

---

# Purpose

Dokumen ini berisi aturan implementasi yang WAJIB dipatuhi selama pengembangan OBS Broadcast Suite.

AI tidak boleh mengubah aturan ini tanpa persetujuan pengguna.

Semua keputusan implementasi harus mengutamakan stabilitas, modularitas, dan kemudahan maintenance.

---

# Primary Goal

Buat software yang:

- sederhana
- stabil
- ringan
- mudah dikembangkan
- mudah dipelihara

Jangan mengejar fitur sebanyak mungkin.

Prioritaskan kualitas implementasi.

---

# Development Order

AI WAJIB mengikuti urutan berikut.

Phase 1

Project Structure

↓

Configuration

↓

WebSocket

↓

OBS Wrapper

↓

Theme System

↓

UI Framework

↓

Module System

Phase 2

Running Text

↓

Lower Third

↓

Scene Switcher

↓

PPT Controller

↓

Emergency

Phase 3

Bug Fix

↓

Optimization

↓

Documentation

Jangan melompati urutan.

---

# Build Rules

Jangan membuat seluruh project sekaligus.

Bangun sedikit demi sedikit.

Pastikan setiap module selesai sebelum membuat module berikutnya.

---

# Module Rules

Satu module

=

Satu tanggung jawab.

Module tidak boleh mengetahui implementasi internal module lain.

Komunikasi dilakukan melalui API atau Event.

---

# File Rules

Jangan membuat file besar.

Target maksimum

300 baris.

Apabila file mulai terlalu panjang,

pecah menjadi beberapa file.

---

# Folder Rules

Folder hanya dibuat apabila memang diperlukan.

Jangan membuat struktur folder yang berlebihan.

---

# Reusable Rules

Apabila kode digunakan lebih dari dua kali,

buat reusable function.

Apabila UI digunakan lebih dari dua kali,

buat reusable component.

---

# Refactor Rules

Refactor hanya dilakukan apabila:

- meningkatkan keterbacaan
- mengurangi duplikasi
- meningkatkan modularitas

Jangan refactor hanya karena preferensi pribadi.

---

# Performance Rules

Prioritas:

1. Stabil

2. Ringan

3. Cepat

4. Baru fitur tambahan

Jangan melakukan optimasi prematur.

---

# Dependency Rules

Tidak boleh menambah dependency tanpa alasan kuat.

Selalu gunakan kemampuan bawaan browser, Lua, atau OBS terlebih dahulu.

---

# Browser Dock Rules

Browser Dock hanya bertugas:

- menerima input
- mengirim request
- menampilkan status

Browser Dock tidak boleh mengontrol OBS secara langsung.

---

# Lua Rules

Lua adalah pusat seluruh sistem.

Semua logika utama berada di Lua.

Browser hanya menjadi antarmuka.

---

# Browser Source Rules

Browser Source hanya bertugas merender tampilan.

Semua data berasal dari Lua.

Browser Source tidak menyimpan state utama aplikasi.

---

# Config Rules

Semua konfigurasi disimpan dalam JSON.

Tidak boleh menggunakan database.

Tidak boleh menggunakan registry.

Tidak boleh menyimpan konfigurasi di source code.

---

# Naming Convention

Folder

kebab-case

File

kebab-case

Function

camelCase

Constant

UPPER_CASE

Class (jika ada)

PascalCase

---

# Event Rules

Semua event menggunakan format

module.action

Contoh

scene.change

ppt.next

runningtext.show

lowerthird.hide

Jangan menggunakan nama event yang ambigu.

---

# Error Handling

Semua fungsi harus mengembalikan status.

Success

atau

Error

Jangan membiarkan error diam.

---

# Logging

Gunakan level:

INFO

WARNING

ERROR

DEBUG hanya untuk development.

---

# UI Rules

UI dibuat untuk operator.

Bukan developer.

Operator harus dapat memahami fungsi tombol tanpa membaca dokumentasi.

---

# Code Style

Gunakan

Clean Code

DRY

KISS

YAGNI

Single Responsibility

Readable Code

Hindari clever code.

Lebih baik sederhana daripada pintar.

---

# Security

Validasi seluruh input.

Validasi seluruh data WebSocket.

Jangan menggunakan eval().

Jangan membuat code injection.

---

# Animation

Animasi hanya untuk membantu pengguna.

Animasi tidak boleh memperlambat operator.

Durasi ideal

150-250ms

---

# Testing Rules

Setiap module harus diuji sebelum membuat module berikutnya.

Minimal pengujian:

- normal case
- invalid input
- reconnect
- missing config
- duplicate command

---

# Git Rules

Commit kecil.

Commit jelas.

Contoh

feat: add running text module

fix: websocket reconnect

refactor: split theme manager

Jangan membuat commit besar berisi banyak perubahan.

---

# Documentation Rules

Setiap module harus memiliki:

Tujuan

Cara kerja

Public API

Dependency

Contoh penggunaan

---

# Completion Rules

Sebuah module dianggap selesai apabila:

- berjalan sesuai PRD
- tidak memiliki bug kritis
- terdokumentasi
- mengikuti AI_RULES.md
- mengikuti UI_GUIDELINE.md
- mengikuti ARCHITECTURE.md
- mengikuti WEBSOCKET_PROTOCOL.md

Baru setelah itu AI boleh melanjutkan ke module berikutnya.

---

# Decision Rules

Apabila terdapat dua solusi,

pilih solusi yang:

lebih sederhana

lebih ringan

lebih mudah dipelihara

lebih mudah dipahami developer lain.

---

# Final Principle

OBS Broadcast Suite bukan demo.

OBS Broadcast Suite adalah software yang akan digunakan saat acara berlangsung.

Operator tidak boleh dipaksa berpikir.

Developer tidak boleh dipaksa menebak.

Semua implementasi harus sederhana, konsisten, dan dapat dipelihara dalam jangka panjang.