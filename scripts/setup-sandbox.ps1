# Define the folder to be mapped
$MappedFolder = (Get-Location).Path
$FolderName = Split-Path -Leaf $MappedFolder
Write-Host "Current folder name: $FolderName"
Write-Host "Mapping folder path: $MappedFolder"

$SandboxConfigPath = "$env:TEMP\SandboxConfig.wsb"
$SandboxBaseMappingPath = 'C:\Users\WDAGUtilityAccount\Desktop'
$InstallChocoScriptPath = "$SandboxBaseMappingPath\$FolderName\install-choco.ps1"
$PowershellPath = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'

# Check if Windows Sandbox is installed
$feature = Get-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM

if ($feature.State -ne 'Enabled') {
  Write-Host 'Windows Sandbox is not enabled. Enabling now...'
  Enable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM -NoRestart
  Write-Host 'Windows Sandbox has been enabled.'
    
  # Check if restart is required
  if ($feature.RestartRequired -eq $true) {
    Write-Host 'A restart is required to apply changes.'
    $restart = Read-Host 'Would you like to restart now? (Y/N)'
    if ($restart -eq 'Y') {
      Restart-Computer
    }
    else {
      Write-Host 'Please restart manually to complete the installation.'
    }
  }
}
else {
  Write-Host 'Windows Sandbox is already enabled.' -ForegroundColor Green
}

# Create Windows Sandbox configuration file
$wsbContent = @"
<Configuration>
    <Networking>Enable</Networking>
    <MappedFolders>
        <MappedFolder>
            <HostFolder>$MappedFolder</HostFolder>
            <ReadOnly>false</ReadOnly>
        </MappedFolder>
    </MappedFolders>
    <LogonCommand>
        <Command>$PowershellPath -ExecutionPolicy Bypass -File $InstallChocoScriptPath -TranscriptFolder $SandboxBaseMappingPath</Command>
    </LogonCommand>
</Configuration>
"@

# Save the configuration file
$wsbContent | Out-File -Encoding ASCII $SandboxConfigPath
Write-Host "Sandbox configuration file created at: $SandboxConfigPath" -ForegroundColor Green

# Launch Windows Sandbox
Write-Host 'Launching Windows Sandbox...' -ForegroundColor Green
Start-Process -FilePath "$SandboxConfigPath"
