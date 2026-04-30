chcp 65001 | Out-Null
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Generates and installs the right-click context menu for apply-copyright.ps1.
# Run this once after cloning or moving the folder.

$scriptPath = (Resolve-Path "$PSScriptRoot\apply-copyright.ps1").Path
$regPath    = $scriptPath -replace '\\', '\\'

$regContent = @"
Windows Registry Editor Version 5.00

; Right-click ON a folder
[HKEY_CURRENT_USER\SOFTWARE\Classes\Directory\shell\ApplyCopyright]
@="Apply Copyright"

[HKEY_CURRENT_USER\SOFTWARE\Classes\Directory\shell\ApplyCopyright\command]
@="powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \"& '$regPath' '%1'\""

; Right-click INSIDE a folder (background)
[HKEY_CURRENT_USER\SOFTWARE\Classes\Directory\Background\shell\ApplyCopyright]
@="Apply Copyright Here"

[HKEY_CURRENT_USER\SOFTWARE\Classes\Directory\Background\shell\ApplyCopyright\command]
@="powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \"& '$regPath' '%V'\""
"@

$regFile = "$PSScriptRoot\copyright_context_menu.reg"
Set-Content $regFile -Value $regContent -Encoding ASCII

Start-Process "regedit.exe" -ArgumentList "/s `"$regFile`"" -Wait

Write-Host ""
Write-Host "  Context menu installed." -ForegroundColor Green
Write-Host "  Script path: $scriptPath" -ForegroundColor DarkGray
Write-Host ""
Read-Host "  Press Enter to close"

