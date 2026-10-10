# server.ps1 - OBS Broadcast Suite: HTTP static + WebSocket bridge (no install)
param([int]$Port = 4456)

$ErrorActionPreference = 'SilentlyContinue'
$Root  = Split-Path -Parent $MyInvocation.MyCommand.Path
$dataDir = Join-Path $Root "data"

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
try { $listener.Start() }
catch { Write-Host "PORT $Port sudah dipakai. Coba: server.ps1 -Port 4456"; exit 1 }

Write-Host "OBS Broadcast Suite server:"
Write-Host "  HTTP : http://127.0.0.1:$Port/  (dock=/dock/, overlay=/browser-source/...)"
Write-Host "  WS   : ws://127.0.0.1:$Port"
Write-Host "  LOG  : IP 127.0.0.x dilog ke console + data/server.log"
Write-Host "Tekan Ctrl+C untuk berhenti."

$mime = @{
    '.html'='text/html; charset=utf-8'; '.htm'='text/html; charset=utf-8'
    '.css' ='text/css; charset=utf-8';  '.js'  ='application/javascript'
    '.json'='application/json; charset=utf-8'; '.txt'='text/plain; charset=utf-8'
    '.png' ='image/png'; '.jpg'='image/jpeg'; '.jpeg'='image/jpeg'
    '.gif' ='image/gif'; '.svg'='image/svg+xml'; '.ico'='image/x-icon'
    '.woff'='font/woff'; '.woff2'='font/woff2'; '.ttf'='font/ttf'
}

$conn = @'
param($stream, $root, $dataDir, $mime, $clientIp)
$ErrorActionPreference = 'SilentlyContinue'

function Write-IPLog($msg) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$ts] IP=$clientIp $msg"
    Write-Host $line
    try { $line | Out-File (Join-Path $dataDir "server.log") -Append -Encoding utf8 } catch {}
}

function Send-WSFrame($stream, $msg) {
    $bytes = [Text.Encoding]::UTF8.GetBytes($msg)
    $frame = New-Object byte[] (2 + $bytes.Length)
    $frame[0] = 0x81
    $frame[1] = $bytes.Length
    [Array]::Copy($bytes, 0, $frame, 2, $bytes.Length)
    $stream.Write($frame, 0, $frame.Length)
    $stream.Flush()
}

function Read-WSFrame($stream) {
    $h = New-Object byte[] 2
    $n = 0
    while ($n -lt 2) { $r = $stream.Read($h, $n, 2 - $n); if ($r -le 0) { return $null }; $n += $r }
    $masked = ($h[1] -band 0x80) -ne 0
    $len = $h[1] -band 0x7F
    if ($len -eq 126) { $ex = New-Object byte[] 2; $stream.Read($ex, 0, 2) | Out-Null; if ([BitConverter]::IsLittleEndian) { [Array]::Reverse($ex) }; $len = [BitConverter]::ToUInt16($ex, 0) }
    elseif ($len -eq 127) { $ex = New-Object byte[] 8; $stream.Read($ex, 0, 8) | Out-Null; if ([BitConverter]::IsLittleEndian) { [Array]::Reverse($ex) }; $len = [BitConverter]::ToUInt64($ex, 0) }
    $mask = New-Object byte[] 4
    if ($masked) { $stream.Read($mask, 0, 4) | Out-Null }
    $payload = New-Object byte[] $len
    $read = 0
    while ($read -lt $len) { $r = $stream.Read($payload, $read, $len - $read); if ($r -le 0) { return $null }; $read += $r }
    if ($masked) { for ($i = 0; $i -lt $len; $i++) { $payload[$i] = $payload[$i] -bxor $mask[$i % 4] } }
    return [Text.Encoding]::UTF8.GetString($payload)
}

function Send-HTTP($stream, $code, $ct, [byte[]]$body) {
    $msg = "HTTP/1.1 $code X`r`nContent-Type: $ct`r`nContent-Length: $($body.Length)`r`nConnection: close`r`n`r`n"
    $head = [Text.Encoding]::ASCII.GetBytes($msg)
    $stream.Write($head, 0, $head.Length)
    $stream.Write($body, 0, $body.Length)
    $stream.Flush()
}

function Serve-File($stream, $ctxPath) {
    if ($ctxPath -eq '/logo') {
        $lp = $null
        $rawJson = $null
        try { $rawJson = Get-Content (Join-Path $root 'config/settings.json') -Raw } catch { $rawJson = $null }
        try { if ($rawJson) { $lp = ($rawJson | ConvertFrom-Json).logoPath } } catch { Write-IPLog "HTTP /logo JSON error: $_ raw=$rawJson" }
        $lp = if ($lp) { $lp.ToString().Trim().Trim('"').Trim("'") } else { "" }
        if ([string]::IsNullOrWhiteSpace($lp)) {
            Send-HTTP $stream 404 'text/plain' ([Text.Encoding]::UTF8.GetBytes('no logo - path kosong, isi di Settings'))
            Write-IPLog "HTTP 404 /logo (logoPath kosong di settings.json)"
            return
        }
        # normalisasi: ganti / jadi \ untuk Test-Path, tapi biarkan asli untuk ReadAllBytes
        $exists = Test-Path -LiteralPath $lp
        if (-not $exists) {
            # coba gabung dengan root jika path relatif
            $alt = Join-Path $root $lp
            if (Test-Path -LiteralPath $alt) { $lp = $alt; $exists = $true }
        }
        if ($exists) {
            try {
                $ext = [IO.Path]::GetExtension($lp).ToLowerInvariant(); $ct = $mime[$ext]; if (-not $ct) { $ct = 'application/octet-stream' }
                Send-HTTP $stream 200 $ct ([IO.File]::ReadAllBytes($lp))
                Write-IPLog "HTTP 200 /logo -> $lp"
            } catch {
                Send-HTTP $stream 500 'text/plain' ([Text.Encoding]::UTF8.GetBytes("logo read error: $_"))
                Write-IPLog "HTTP 500 /logo read fail $lp err=$_"
            }
            return
        }
        Send-HTTP $stream 404 'text/plain' ([Text.Encoding]::UTF8.GetBytes("no logo - file tidak ada: $lp"))
        Write-IPLog "HTTP 404 /logo file tidak ada: '$lp' (cek settings.json logoPath, pastikan file ada dan path pakai \\)"
        return
    }
    if ($ctxPath -eq '/' -or $ctxPath -eq '') { $ctxPath = '/dock/index.html' }
    $rel = $ctxPath.TrimStart('/').Replace('/', [IO.Path]::DirectorySeparatorChar)
    $full = Join-Path $root $rel
    if (Test-Path -LiteralPath $full -PathType Container) { $full = Join-Path $full 'index.html' }
    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { Send-HTTP $stream 404 'text/plain' ([Text.Encoding]::UTF8.GetBytes('not found')); Write-IPLog "HTTP 404 $ctxPath"; return }
    $ext = [IO.Path]::GetExtension($full).ToLowerInvariant(); $ct = $mime[$ext]; if (-not $ct) { $ct = 'application/octet-stream' }
    Send-HTTP $stream 200 $ct ([IO.File]::ReadAllBytes($full))
    Write-IPLog "HTTP 200 $ctxPath"
}

# baca baris request + header; lancar tidak membalas spasi
$lines = @()
$reader = [IO.StreamReader]::new($stream, [Text.Encoding]::ASCII, $false, 8192, $true)
while ($true) { $ln = $reader.ReadLine(); if ($null -eq $ln) { break }; if ($ln -eq '') { break }; $lines += $ln }
if ($lines.Count -eq 0) { Write-IPLog "koneksi kosong / timeout"; try { $stream.Close() } catch {}; return }
$requestLine = $lines[0]
$parts = $requestLine -split ' '
$method = if ($parts.Count -gt 0) { $parts[0] } else { '' }
$path = if ($parts.Count -gt 1) { $parts[1] } else { '' }
$hd = @{}
foreach ($l in $lines[1..($lines.Count - 1)]) { if ($l -match '^([^:]+):\s*(.+)$') { $hd[$Matches[1].ToLowerInvariant()] = $Matches[2].Trim() } }

# log tiap request masuk (filter 127.0.0.x tetap kelog semua, highlight jika loopback)
$ipTag = if ($clientIp -like "127.0.0.*") { "LOOPBACK" } else { "REMOTE" }
Write-IPLog "$ipTag $method $path"

if ($hd.ContainsKey('sec-websocket-key')) {
    $key = $hd['sec-websocket-key']
    $guid = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11'
    $hash = (New-Object Security.Cryptography.SHA1Managed).ComputeHash([Text.Encoding]::UTF8.GetBytes($key + $guid))
    $accept = [Convert]::ToBase64String($hash)
    $resp = "HTTP/1.1 101 Switching Protocols`r`nUpgrade: websocket`r`nConnection: Upgrade`r`nSec-WebSocket-Accept: $accept`r`n`r`n"
    $b = [Text.Encoding]::ASCII.GetBytes($resp)
    $stream.Write($b, 0, $b.Length); $stream.Flush()
    Write-IPLog "WS HANDSHAKE ok $path"

    while ($true) {
        $msg = Read-WSFrame $stream
        if ($null -eq $msg) { Write-IPLog "WS DISCONNECT"; break }
        Write-IPLog "WS RECV $msg"
        $cmd = $null
        try { $cmd = $msg | ConvertFrom-Json } catch { }
        if (-not $cmd -or -not $cmd.event) { Write-IPLog "WS SKIP (no event)"; continue }
        # simpan IP pengirim bersama command untuk debug
        try {
            $j = $msg | ConvertFrom-Json
            $j | Add-Member -NotePropertyName "_fromIp" -NotePropertyValue $clientIp -Force
            $j | ConvertTo-Json -Compress | Out-File (Join-Path $dataDir 'command.json') -Encoding utf8 -Force
        } catch { $msg | Out-File (Join-Path $dataDir 'command.json') -Encoding utf8 -Force }
        $rspFile = Join-Path $dataDir 'response.json'
        $rsp = $null
        for ($i = 0; $i -lt 200; $i++) {
            Start-Sleep -Milliseconds 100
            if (Test-Path $rspFile) { $rsp = Get-Content $rspFile -Raw; Remove-Item $rspFile -Force; break }
        }
        if ($null -ne $rsp) { Send-WSFrame $stream $rsp; Write-IPLog "WS SEND $rsp" } else { Write-IPLog "WS NO-RESPONSE timeout event=$($cmd.event)" }
    }
} else {
    Serve-File $stream $path
}
try { $stream.Close() } catch {}
'@

$script:conns = New-Object System.Collections.Queue
while ($true) {
    try { $client = $listener.AcceptTcpClient() } catch { Start-Sleep -Milliseconds 200; continue }
    $ep = try { $client.Client.RemoteEndPoint } catch { $null }
    $ipOnly = try { $ep.Address.ToString() } catch { "unknown" }
    $portOnly = try { $ep.Port } catch { "?" }
    $remoteIp = "$ipOnly`:$portOnly"
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$ts] IP=$ipOnly PORT=$portOnly KONEK"
    Write-Host $logLine
    try { $logLine | Out-File (Join-Path $dataDir "server.log") -Append -Encoding utf8 } catch {}
    # highlight khusus 127.0.0.x - sekarang IP saja tanpa port jadi -like pasti kena
    if ($ipOnly -like "127.0.0.*") { Write-Host "  -> IP loopback terdeteksi: $ipOnly (127.0.0.x)" }
    $stream = $client.GetStream()
    $ps = [System.Management.Automation.PowerShell]::Create([System.Management.Automation.RunspaceMode]::NewRunspace)
    [void]$ps.AddScript($conn).AddArgument($stream).AddArgument($Root).AddArgument($dataDir).AddArgument($mime).AddArgument($ipOnly)
    $t = $null
    try { $t = $ps.BeginInvoke() } catch { Write-Host "gagal invoke untuk $remoteIp : $_" }
    $null = $script:conns.Enqueue([pscustomobject]@{ PS = $ps; T = $t; C = $client })
    if ($script:conns.Count -gt 60) {
        while ($script:conns.Count -gt 40 -and $script:conns.Count -gt 0) {
            $head = $script:conns.Peek()
            if ($null -ne $head.T -and $head.T.IsCompleted) { [void]$script:conns.Dequeue(); try { $head.C.Close() } catch {} } else { break }
        }
    }
}
