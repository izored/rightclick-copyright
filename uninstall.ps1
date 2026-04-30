chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Removes the right-click context menu entries added by install.ps1.

$keys = @(
    "HKCU:\SOFTWARE\Classes\Directory\shell\ApplyCopyright",
    "HKCU:\SOFTWARE\Classes\Directory\Background\shell\ApplyCopyright"
)

foreach ($key in $keys) {
    if (Test-Path $key) {
        Remove-Item $key -Recurse -Force
        Write-Host "  Removed: $key" -ForegroundColor DarkGray
    } else {
        Write-Host "  Not found (already removed?): $key" -ForegroundColor DarkYellow
    }
}

Write-Host ""
Write-Host "  Context menu uninstalled." -ForegroundColor Green
Write-Host ""
Read-Host "  Press Enter to close"
