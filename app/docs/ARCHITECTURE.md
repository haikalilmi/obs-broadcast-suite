# ARCHITECTURE.md

Version: 1.0

---

# System Architecture

OBS Broadcast Suite menggunakan arsitektur Client-Server sederhana yang berjalan sepenuhnya di dalam OBS Studio.

Lua bertindak sebagai backend.

Browser Dock bertindak sebagai user interface.

Browser Source bertindak sebagai renderer overlay.

Semua komunikasi dilakukan melalui WebSocket lokal.

---

# Architecture Diagram

                  +----------------------+
                  |      Browser Dock    |
                  |  HTML CSS JavaScript |
                  +----------+-----------+
                             |
                             |
                          WebSocket
                             |
                             |
                  +----------v-----------+
                  |     Lua Backend      |
                  | OBS Lua API Wrapper  |
                  +----------+-----------+
                             |
        ----------------------------------------------
        |             |            |                 |
        |             |            |                 |
+-------v------+ +-----v-----+ +----v-----+ +---------v------+
| Scene Module | | Running   | | Lower    | | PPT Controller |
|              | | Text      | | Third    | |                |
+--------------+ +-----------+ +----------+ +----------------+
                             |
                             |
                  +----------v-----------+
                  |      OBS Studio      |
                  +----------+-----------+
                             |
                             |
                  +----------v-----------+
                  |   Browser Sources    |
                  +----------------------+

---

# Main Components

## Browser Dock

Fungsi:

- User Interface
- Input pengguna
- Menampilkan status
- Mengirim command ke Lua

Browser Dock tidak boleh mengontrol OBS secara langsung.

---

## Lua Backend

Lua adalah pusat seluruh sistem.

Semua command dari Browser Dock harus diproses oleh Lua terlebih dahulu.

Lua bertugas:

- menerima command
- validasi
- mengontrol OBS
- menyimpan konfigurasi
- mengirim status kembali

---

## OBS API

Lua menggunakan OBS Lua API resmi.

Semua interaksi dengan OBS harus melalui API ini.

Contoh:

- Change Scene
- Show Source
- Hide Source
- Text Update
- Transition
- Audio
- Timer

---

## Browser Source

Browser Source digunakan untuk seluruh overlay.

Contoh:

Running Text

Lower Third

Emergency

PPT

Semua animasi dilakukan menggunakan HTML dan CSS.

---

# Data Flow

Operator

↓

Browser Dock

↓

WebSocket

↓

Lua

↓

OBS API

↓

Browser Source

↓

Overlay tampil

---

# Reverse Data Flow

OBS Event

↓

Lua

↓

WebSocket

↓

Browser Dock

↓

UI Update

Contoh:

Scene berubah

↓

Dock langsung mengetahui scene aktif.

---

# Modules

Project dipisahkan menjadi beberapa module independen.

## Running Text Module

Bertanggung jawab atas:

- update text
- speed
- logo
- jam
- theme

---

## Lower Third Module

Bertanggung jawab atas:

- nama
- jabatan
- nama acara
- durasi
- theme
- show
- hide

---

## Scene Module

Bertanggung jawab:

- mendapatkan daftar scene
- change scene
- active scene
- transition

---

## PPT Module

Bertanggung jawab:

- next
- previous
- show
- hide
- animation

---

## Emergency Module

Bertanggung jawab:

- show emergency
- hide emergency
- emergency scene

---

## Theme Module

Bertanggung jawab:

- load theme
- save theme
- daftar theme

Semua module dapat menggunakan Theme Module.

---

## Config Module

Semua konfigurasi disimpan melalui module ini.

Contoh:

config.json

settings.json

theme.json

---

# Folder Structure

obs-broadcast-suite/

lua/

    websocket.lua

    config.lua

    scene.lua

    lowerthird.lua

    runningtext.lua

    ppt.lua

    emergency.lua

    theme.lua

dock/

    html

    css

    js

browser-source/

    running-text

    lower-third

    ppt

    emergency

themes/

config/

data/

docs/

---

# Design Principles

## Single Responsibility

Satu module hanya memiliki satu tugas.

---

## Loose Coupling

Module tidak boleh saling bergantung secara langsung.

Komunikasi dilakukan melalui Event atau API.

---

## Reusable

Seluruh module harus mudah digunakan ulang.

---

## Maintainable

Kode harus mudah dipelihara.

---

## Extensible

Penambahan fitur baru tidak boleh mengubah arsitektur utama.

---

# Communication Rules

Browser Dock

↓

Request

↓

Lua

↓

OBS

↓

Response

↓

Dock

Semua komunikasi menggunakan format JSON.

---

# Event Driven

Seluruh sistem menggunakan Event.

Contoh:

scene.changed

lowerthird.show

ppt.next

runningtext.updated

Emergency.on

Jangan menggunakan polling jika event tersedia.

---

# Error Handling

Apabila terjadi error:

Lua

↓

Mengirim Error

↓

Browser Dock

↓

Menampilkan notifikasi

Jangan membuat aplikasi crash.

---

# Offline Support

Project harus dapat berjalan tanpa internet.

Tidak ada request ke server eksternal.

---

# Performance Goals

Target:

Startup cepat

RAM kecil

CPU rendah

Animasi halus

WebSocket latency rendah

---

# Future Scalability

Arsitektur harus mendukung penambahan module baru.

Contoh:

Countdown

Scoreboard

Ayat Qur'an

Hadits

Auto Rundown

Clock

Media Playlist

Tanpa mengubah fondasi sistem.