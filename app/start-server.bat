@echo off
title OBS Broadcast Suite Server
echo Starting WebSocket server on ws://127.0.0.1:4455
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0server.ps1"
pause
