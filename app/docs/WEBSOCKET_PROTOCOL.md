# WEBSOCKET_PROTOCOL.md

Version: 1.0

---

# Overview

OBS Broadcast Suite menggunakan WebSocket sebagai media komunikasi antara Browser Dock dan Lua Backend.

Semua komunikasi menggunakan format JSON.

Tidak diperbolehkan mengirim string biasa.

---

# Communication Flow

Browser Dock

↓

Request

↓

Lua Backend

↓

OBS Studio

↓

Response

↓

Browser Dock

---

# JSON Structure

Semua packet menggunakan struktur berikut.

```json
{
  "event": "",
  "data": {},
  "timestamp": 0
}
```

---

# Event Naming

Gunakan format:

module.action

Contoh:

scene.change

scene.list

scene.active

runningtext.show

runningtext.hide

runningtext.update

lowerthird.show

lowerthird.hide

ppt.next

ppt.previous

emergency.enable

emergency.disable

theme.change

config.save

---

# Response Format

Success

```json
{
  "success": true,
  "event": "",
  "message": "",
  "data": {}
}
```

---

Error

```json
{
  "success": false,
  "event": "",
  "message": "",
  "error": ""
}
```

---

# Scene Module

## Get Scene List

Request

```json
{
  "event": "scene.list"
}
```

Response

```json
{
  "success": true,
  "data": {
    "scenes": [
      "Camera 1",
      "Camera 2",
      "PPT",
      "Closing"
    ]
  }
}
```

---

## Change Scene

Request

```json
{
  "event": "scene.change",
  "data": {
    "scene": "Camera 1"
  }
}
```

---

## Active Scene

Broadcast

```json
{
  "event": "scene.active",
  "data": {
    "scene": "Camera 1"
  }
}
```

---

# Running Text Module

## Show

```json
{
  "event": "runningtext.show"
}
```

---

## Hide

```json
{
  "event": "runningtext.hide"
}
```

---

## Update

```json
{
  "event": "runningtext.update",
  "data": {
    "text": "Selamat Datang di Pondok Pesantren",
    "theme": "modern",
    "showClock": true,
    "showLogo": true,
    "speed": 80
  }
}
```

---

# Lower Third Module

## Show

```json
{
  "event": "lowerthird.show",
  "data": {
    "name": "KH Ahmad",
    "subtitle": "Pengasuh Pondok",
    "eventName": "Kajian Ahad",
    "theme": "modern",
    "duration": 10
  }
}
```

---

## Hide

```json
{
  "event": "lowerthird.hide"
}
```

---

# PPT Module

## Show

```json
{
  "event": "ppt.show"
}
```

---

## Hide

```json
{
  "event": "ppt.hide"
}
```

---

## Next Slide

```json
{
  "event": "ppt.next"
}
```

---

## Previous Slide

```json
{
  "event": "ppt.previous"
}
```

---

## Current Slide

```json
{
  "event": "ppt.current"
}
```

Response

```json
{
  "success": true,
  "data": {
    "current": 5,
    "total": 32
  }
}
```

---

# Emergency Module

## Enable

```json
{
  "event": "emergency.enable"
}
```

---

## Disable

```json
{
  "event": "emergency.disable"
}
```

---

# Theme Module

## List

```json
{
  "event": "theme.list"
}
```

---

## Change

```json
{
  "event": "theme.change",
  "data": {
    "theme": "modern"
  }
}
```

---

# Config Module

## Save

```json
{
  "event": "config.save"
}
```

---

## Load

```json
{
  "event": "config.load"
}
```

---

# System Events

OBS Connected

```json
{
  "event": "system.connected"
}
```

OBS Disconnected

```json
{
  "event": "system.disconnected"
}
```

Ready

```json
{
  "event": "system.ready"
}
```

---

# Error Events

```json
{
  "event": "system.error",
  "data": {
    "message": ""
  }
}
```

---

# Status Events

```json
{
  "event": "status.update",
  "data": {
    "scene": "Camera 1",
    "runningText": true,
    "lowerThird": false,
    "pptVisible": true,
    "emergency": false
  }
}
```

Status dikirim ketika ada perubahan.

Bukan secara polling.

---

# Rules

Semua command harus memiliki response.

Semua response harus memiliki field success.

Semua event menggunakan huruf kecil.

Gunakan format:

module.action

Jangan menggunakan:

camelCase

PascalCase

snake_case

Untuk nama event.

---

# Future Reserved Events

Dicadangkan untuk versi berikutnya.

countdown.*

scoreboard.*

quran.*

hadith.*

playlist.*

clock.*

media.*

audio.*

stream.*

recording.*

---

# Development Notes

Frontend tidak boleh mengakses OBS secara langsung.

Seluruh kontrol OBS harus melalui Lua Backend.

Lua adalah satu-satunya komponen yang berkomunikasi dengan OBS API.

Browser Dock hanya mengirim request dan menerima response melalui WebSocket.