#!/usr/bin/env powershell
# Set-PSDebug -Trace 0

$dotfilesProfileDir = Join-Path $PSScriptRoot "powershell"
$dotfilesModulesDir = Join-Path $dotfilesProfileDir "Modules"
$dotfilesScriptsDir = Join-Path $dotfilesProfileDir "Scripts"
$profileDir         = Split-Path -Parent $profile

$DeafaultVersionTls = [Net.ServicePointManager]::SecurityProtocol
$AvailableSecurityProtocols = [enum]::GetValues('Net.SecurityProtocolType') | Where-Object { $_ -ge 'Tls' }
$AvailableSecurityProtocols.ForEach({
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor $_
})

# $OutputEncoding = [System.Console]::OutputEncoding = [System.Console]::InputEncoding = [System.Text.Encoding]::UTF8
# $PSDefaultParameterValues['*:Encoding'] = 'utf8'
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'

# if (-Not ($env:ConEmuANSI) -And -Not ($env:RELOADED_TRUE)) {
#   #Write-Host "$PID.pid"
#   $env:RELOADED_TRUE = 1
#   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell"
#   $newProcess.Arguments = "-nologo"
#   [System.Diagnostics.Process]::Start($newProcess)
#   Stop-Process -Id $PID
# }

Get-ChildItem "$(Join-Path $PSScriptRoot "Autoload")\*.ps1" | ForEach-Object { . $_ }
Get-ChildItem "$(Join-Path $PSScriptRoot "Completion")\*.ps1" | ForEach-Object { . $_ }

$PrivatePSAutoladFolder = $(Join-Path $Env:USERPROFILE "OneDrive\bin\ps_autoload")
If (Test-Path $PrivatePSAutoladFolder)
{
    Get-ChildItem "$PrivatePSAutoladFolder\*.ps1" | ForEach-Object { . $_ }
}

# Loading Cmder Profile
# if (Get-Command cmder.exe -ErrorAction SilentlyContinue | Test-Path) {
#   $cmder_home = Get-Command cmder.exe | Select-Object -ExpandProperty Definition | Split-Path
#   if (Test-Path (Join-Path $cmder_home "vendor\profile.ps1"   ))  { . (Join-Path $cmder_home "vendor\profile.ps1")      }
# }

# Invovoke ANSI 256 Color Console
# AnsiColors256
AnsiConsole

# Write-Host "Welcome Home:"(Get-WmiObject -Class Win32_UserAccount -Filter "Name = '$env:USERNAME'").FullName
# Write-Host "Welcome Home: $(Split-Path (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object UserName).UserName -Leaf)"
