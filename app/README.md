# OBS Broadcast Suite

Plugin broadcast profesional berbasis Lua + Browser Dock untuk OBS Studio.

## Struktur

```
obs-broadcast-suite/
├── lua/            Backend Lua (config, websocket, modules)
├── dock/           Browser Dock UI (HTML, CSS, JS)
├── browser-source/ Browser Source overlay HTML
├── themes/         File tema JSON
├── config/         Konfigurasi JSON
├── data/           Data penyimpanan JSON
└── docs/           Dokumentasi
```

## Instalasi

1. OBS → Tools → Scripts → Add → pilih `main.lua`
2. OBS → Docks → Custom Browser Docks → tambahkan file HTML dari `dock/`

## Modules

- Running Text
- Lower Third
- Scene Switcher
- PPT Controller
- Emergency Mode

## Tech Stack

Lua, HTML, CSS, Vanilla JavaScript, WebSocket
