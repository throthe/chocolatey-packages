param (
  [string]$TranscriptFolder = '.\'
)

# Ensure the transcript folder exists
if (!(Test-Path $TranscriptFolder)) {
  New-Item -ItemType Directory -Path $TranscriptFolder | Out-Null
}

# Enable logging in the specified folder
$TranscriptPath = "$TranscriptFolder\sandbox-install.log"
Start-Transcript -Path $TranscriptPath -Append


if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  Write-Host 'Chocolatey is not installed. Installing now...'
  Set-ExecutionPolicy Bypass -Scope Process -Force
  Invoke-WebRequest -Uri 'https://community.chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression
}
else {
  Write-Host 'Chocolatey is already installed. Skipping installation.'
}


# Install Notepad++ via Chocolatey
Write-Host 'Installing Notepad++...'
choco install notepadplusplus -y

Write-Host 'Setup completed.'
Stop-Transcript
