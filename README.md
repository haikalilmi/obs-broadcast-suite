# OBS Broadcast Suite

Plugin broadcast profesional berbasis Lua + Browser Dock untuk OBS Studio.

Bind lokal only (`127.0.0.1`). Jangan ubah ke `0.0.0.0` tanpa auth.

## Struktur

```
./
├── main.lua            # Entry OBS (load config, bridge, event 17x)
├── app/lua/            # Backend Lua (config, websocket, bridge, scene, ppt, ...)
├── app/dock/           # Browser Dock UI
├── app/browser-source/ # Overlay HTML
├── app/themes/         # Tema JSON
├── app/config/         # settings.json bersih (logoPath kosong)
├── app/data/           # Default data (ppt/runningtext/lowerthird). Runtime di-ignore
├── app/docs/           # PRD, arsitektur, protokol WS
└── app/*.ps1           # Server lokal + util PPT
```

## Instalasi

1. OBS → Tools → Scripts → Add → pilih `main.lua`.
2. OBS → Docks → Custom Browser Docks → tambah HTML dari `app/dock/`.
3. Isi `app/config/settings.json` bila perlu (contoh: `{"port":4456,"theme":"modern","logoPath":""}`).
4. Buat source `PPT Overlay` bila pakai modul PPT.

## Modul

Running Text, Lower Third, Scene Switcher, PPT Controller, Emergency Mode, Theme.

## Catatan keamanan

- `ppt.export(path)` concat path ke PowerShell — hanya terima path lokal tepercaya.
- `server.ps1` hanya listen loopback, tanpa auth. Jangan expose ke LAN.
- File runtime (`server.log`, `command/response/status.json`, `ppt-cache/`) tidak dicommit, lihat `.gitignore`.
