chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# ---- Load config from .env (one level up) ----
$envFile = Join-Path $PSScriptRoot "..\.env"
if (Test-Path $envFile) {
    Get-Content $envFile -Encoding UTF8 | ForEach-Object {
        if ($_ -match '^\s*([A-Z_][A-Z0-9_]*)\s*=\s*(.*?)\s*$') {
            Set-Variable -Name $matches[1] -Value $matches[2] -Scope Script
        }
    }
}

if (-not $WATCH_FOLDER)   { $WATCH_FOLDER   = "C:\Path\To\Your\Output\Folder" }
if (-not $ARTIST_NAME)    { $ARTIST_NAME    = "Your Name" }
if (-not $CREATOR_CREDIT) { $CREATOR_CREDIT = "Your Studio - your.site - Your Name" }
if (-not $COPYRIGHT_TEXT) { $COPYRIGHT_TEXT = "© 2025 Your Name. All rights reserved." }

# ---- Start watcher ----
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $WATCH_FOLDER
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

$action = {
    $file = $Event.SourceEventArgs.FullPath
    $extension = [System.IO.Path]::GetExtension($file).ToLower()

    $imgExtensions = @('.jpg','.jpeg','.png','.tif','.tiff','.gif','.bmp',
                        '.webp','.heic','.heif','.avif',
                        '.cr2','.cr3','.nef','.arw','.dng','.rw2',
                        '.orf','.raf','.pef','.srw','.psd')
    if ($extension -in $imgExtensions) {
        Start-Sleep -Seconds 2

        # Requires exiftool in PATH — see README.md
        & exiftool -charset utf8 -codedcharacterset=utf8 `
            -Artist="$ARTIST_NAME" `
            -Creator="$CREATOR_CREDIT" `
            -Copyright="$COPYRIGHT_TEXT" `
            -Rights="$COPYRIGHT_TEXT" `
            $file -overwrite_original

        Write-Host "  [+] $(Split-Path $file -Leaf)" -ForegroundColor Green
    }
}

Register-ObjectEvent $watcher "Created" -Action $action

Write-Host ""
Write-Host "  Watching : $WATCH_FOLDER" -ForegroundColor Cyan
Write-Host "  Press Ctrl+C to stop." -ForegroundColor DarkGray
Write-Host ""

try {
    while ($true) { Start-Sleep -Seconds 1 }
} finally {
    Get-EventSubscriber | Unregister-Event
    $watcher.Dispose()
    Write-Host "  Monitoring stopped." -ForegroundColor DarkGray
}

