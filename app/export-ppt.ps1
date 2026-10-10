param(
    [string]$pptPath,
    [string]$outputDir
)

$ErrorActionPreference = "Stop"
$pptFile = Get-Item $pptPath -ErrorAction SilentlyContinue
if (-not $pptFile) { Write-Host "ERROR: File not found"; exit 1 }

if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir -Force | Out-Null }

try {
    $app = New-Object -ComObject PowerPoint.Application
    $app.Visible = [Microsoft.Office.Core.MsoTriState]::msoFalse
    $presentation = $app.Presentations.Open($pptFile.FullName, $true, $false, $false)
    $total = $presentation.Slides.Count

    for ($i = 1; $i -le $total; $i++) {
        $slide = $presentation.Slides($i)
        $outputPath = Join-Path $outputDir "$i.png"
        $slide.Export($outputPath, "PNG", 1920, 1080)
        Write-Host "SLIDE:$i/$total"
    }

    $presentation.Close()
    $app.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($app) | Out-Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()

    Write-Host "DONE:$total slides exported to $outputDir"
} catch {
    Write-Host "ERROR:$_"
    try { $presentation.Close() } catch {}
    try { $app.Quit() } catch {}
    exit 1
}
