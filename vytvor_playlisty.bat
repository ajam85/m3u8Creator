@echo off
chcp 65001 > nul
cd /d "%~dp0"

echo Spouštím PowerShell generátor playlistů...
echo ---------------------------------------------------

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Get-ChildItem -Recurse -Directory | ForEach-Object {" ^
    "   $slozke = $_.FullName;" ^
    "   $nazevSlozky = $_.Name;" ^
    "   $hudba = Get-ChildItem -Path $slozke -File | Where-Object { $_.Extension -match '\.(mp3|flac|wav|m4a)$' };" ^
    "   $playlist = Join-Path $slozke \"$nazevSlozky.m3u8\";" ^
    "   if ($hudba -and -not (Test-Path $playlist)) {" ^
    "       Write-Host \"Vytvářím playlist pro album: $nazevSlozky\" -ForegroundColor Green;" ^
    "       Set-Content -Path $playlist -Value '#EXTM3U' -Encoding utf8;" ^
    "       foreach ($soubor in $hudba) {" ^
    "           Add-Content -Path $playlist -Value \"#EXTINF:-1,$($soubor.BaseName)\" -Encoding utf8;" ^
    "           Add-Content -Path $playlist -Value $soubor.Name -Encoding utf8;" ^
    "       }" ^
    "   } elseif ($hudba) {" ^
    "       Write-Host \"Přeskočeno (již existuje): $nazevSlozky\" -ForegroundColor Yellow;" ^
    "   }" ^
    "}"

echo ---------------------------------------------------
echo Hotovo!
pause