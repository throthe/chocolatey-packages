$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$url64 = 'https://github.com/lencx/Noi/releases/download/v1.1.0/Noi.msi' 

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'MSI'
  url64bit       = $url64
  softwareName   = 'noi*'
  checksum64     = '25780b556f6854c7906b3e339a807dbaf01c3892b05aa95c1bd6358495415346'
  checksumType64 = 'sha256' #default is checksumType

  # MSI
  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ADDDESKTOPICON=1" 
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 