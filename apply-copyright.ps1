param(
    [string]$FolderPath = "."
)

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

# ---- Fallback defaults (used when no .env present) ----
if (-not $ARTIST_NAME)               { $ARTIST_NAME               = "Your Name" }
if (-not $CREATOR_CREDIT)            { $CREATOR_CREDIT            = "Your Studio - your.site - Your Name" }
if (-not $COPYRIGHT_TEXT)            { $COPYRIGHT_TEXT            = "© 2025 Your Name. All rights reserved." }
if (-not $WEBSITE)                   { $WEBSITE                   = "https://your.site" }
if (-not $IMAGE_DEFAULT_TITLE)       { $IMAGE_DEFAULT_TITLE       = "Artwork Title" }
if (-not $IMAGE_DEFAULT_DESCRIPTION) { $IMAGE_DEFAULT_DESCRIPTION = "Artwork created by Your Name." }
if (-not $IMAGE_DEFAULT_KEYWORDS)    { $IMAGE_DEFAULT_KEYWORDS    = "art, photography, creative" }

# ---- Resolve folder ----
$FolderPath = (Resolve-Path $FolderPath).Path

Write-Host ""
Write-Host "  +-------------------------------------------------+" -ForegroundColor DarkCyan
Write-Host "  |        izored Copyright Tool  //  izo.red       |" -ForegroundColor Cyan
Write-Host "  +-------------------------------------------------+" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  Folder : $FolderPath" -ForegroundColor Gray
Write-Host ""

$count = 0
Get-ChildItem -Path "$FolderPath\*" -Include *.jpg, *.jpeg, *.png -File -Recurse | ForEach-Object {
    $file = $_.FullName
    Write-Host "  [+] $(Split-Path $file -Leaf)" -ForegroundColor DarkGray
    $count++

    & exiftool -charset utf8 -codedcharacterset=utf8 `
        -Artist="$ARTIST_NAME" `
        -Creator="$CREATOR_CREDIT" `
        -Copyright="$COPYRIGHT_TEXT" `
        -Rights="$COPYRIGHT_TEXT" `
        -URL="$WEBSITE" `
        -Source="$WEBSITE" `
        -Title="$IMAGE_DEFAULT_TITLE" `
        -Description="$IMAGE_DEFAULT_DESCRIPTION" `
        -Caption-Abstract="$IMAGE_DEFAULT_DESCRIPTION" `
        -Keywords="$IMAGE_DEFAULT_KEYWORDS" `
        "$file" -overwrite_original > $null
}

Write-Host ""
Write-Host "  +-------------------------------------------------+" -ForegroundColor DarkCyan
Write-Host "  |                  DONE                           |" -ForegroundColor Green
Write-Host "  +-------------------------------------------------+" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  Images tagged  : $count" -ForegroundColor White
Write-Host "  Artist         : $ARTIST_NAME" -ForegroundColor White
Write-Host "  Copyright      : $COPYRIGHT_TEXT" -ForegroundColor White
Write-Host "  Website        : $WEBSITE" -ForegroundColor White
Write-Host ""
Read-Host "  Press Enter to close"

