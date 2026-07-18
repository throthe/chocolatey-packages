$ErrorActionPreference = 'Stop' # stop on all errors

# Remove desktop shortcut
$desktopPath = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktopPath 'IrfanView.lnk'
if (Test-Path $shortcutPath) {
  Remove-Item $shortcutPath -Force
  Write-Host 'Removed desktop shortcut'
}
