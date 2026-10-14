$ErrorActionPreference = 'Stop'

$version = '1.53.0'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$tools = Join-Path $root '.tools\windows'
$archiveName = "mago-$version-x86_64-pc-windows-msvc.zip"
$url = "https://github.com/carthage-software/mago/releases/download/$version/$archiveName"
$temp = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString())

try {
    New-Item -ItemType Directory -Path $temp | Out-Null
    $archive = Join-Path $temp $archiveName
    Invoke-WebRequest -Uri $url -OutFile $archive
    Expand-Archive -LiteralPath $archive -DestinationPath $temp
    $binary = Get-ChildItem -Path $temp -Filter 'mago.exe' -Recurse | Select-Object -First 1
    if (-not $binary) { throw 'The Mago release archive did not contain mago.exe.' }
    New-Item -ItemType Directory -Force -Path $tools | Out-Null
    Copy-Item -LiteralPath $binary.FullName -Destination (Join-Path $tools 'mago.exe') -Force
    Write-Host "Installed Mago $version for Windows x86_64 at $(Join-Path $tools 'mago.exe')"
}
finally {
    Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue
}
