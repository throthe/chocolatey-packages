$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$url = 'https://www.irfanview.info/files/iview475.zip'
$url64 = 'https://www.irfanview.info/files/iview475_x64.zip'
$checksum = '47390cd8d3ae56f6e17834d49e4bc346187d7a868c94877382c6f21cd260efcb'
$checksum64 = 'b657c6fcb3e758b28cda00c1ded32af97b1441ead522053b4930d7304f0506e7'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'zip'
  url            = $url
  url64bit       = $url64
  softwareName   = 'infranview*'
  checksum       = $checksum
  checksumType   = 'sha256'
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  options        = @{
    Headers = @{
      'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      'Accept'     = '*/*'
      'Referer'    = 'https://www.irfanview.info/download.htm'
    }
  }
}

Install-ChocolateyZipPackage @packageArgs

# Create desktop shortcut
$desktopPath = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktopPath 'IrfanView.lnk'

# Determine the executable based on architecture
$exeName = if ([Environment]::Is64BitOperatingSystem) { 'i_view64.exe' } else { 'i_view32.exe' }
$exePath = Join-Path $toolsDir $exeName

Install-ChocolateyShortcut -ShortcutFilePath $shortcutPath `
  -TargetPath $exePath `
  -Description 'IrfanView'
