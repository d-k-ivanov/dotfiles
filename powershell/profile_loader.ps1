#!/usr/bin/env powershell
# Set-PSDebug -Trace 0

$dotfilesProfileDir = Join-Path $PSScriptRoot "powershell"
$dotfilesModulesDir = Join-Path $PSScriptRoot "Modules"
$dotfilesScriptsDir = Join-Path $PSScriptRoot "Scripts"
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

$local_modules = @(
    "ApplicationCompatibility"
)

$modules = @(
    # "PowerShellGet"
    # "AWSPowerShell" # -- SLOW
    # "CredentialManager"
    # "dbatools" # -- SLOW
    # "OData"
    # "OpenSSHUtils"
    "Posh-Docker"
    "Posh-Git"
    # "Posh-SSH" # - SLOW
    "powershell-yaml"
    "PSReadline"
)

foreach ($module in $local_modules)
{
    Import-Module (Join-Path $dotfilesModulesDir $module)
}

foreach ($module in $modules)
{
    if (Get-Module -ListAvailable -Name ${module})
    {
        # Write-Host "Module $module already exist"
        # Get-Date -Format HH:mm:ss.fff
        Import-Module -Name $module
    }
    else
    {
        Install-Module -Scope AllUsers -Name ${module} -Force
        Write-Host "Module ${module} succesfully installed"
        Import-Module -Name ${module}
    }
}

# Posh git settings
# $GitPromptSettings.EnableFileStatus = $false
$GitPromptSettings.RepositoriesInWhichToDisableFileStatus += "C:\a"         # Dev folder for big repos
$GitPromptSettings.RepositoriesInWhichToDisableFileStatus += "C:\boost"     # Boost libs
$GitPromptSettings.RepositoriesInWhichToDisableFileStatus += "${Env:WORKSPACE}\boost"          # Boost libs
$GitPromptSettings.RepositoriesInWhichToDisableFileStatus += "${Env:WORKSPACE}\UnrealEngine"   # Unreal Engine

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
    Import-Module "$ChocolateyProfile"
}

# Remove Aliases:
If($PSVersionTable.PSVersion.Major -ge '6')
{
    Remove-Alias -Name curl -Force -ErrorAction SilentlyContinue
    Remove-Alias -Name gc   -Force -ErrorAction SilentlyContinue
    Remove-Alias -Name gci  -Force -ErrorAction SilentlyContinue
    Remove-Alias -Name gcm  -Force -ErrorAction SilentlyContinue
    Remove-Alias -Name gl   -Force -ErrorAction SilentlyContinue
    Remove-Alias -Name type -Force -ErrorAction SilentlyContinue
    Remove-Alias -Name wget -Force -ErrorAction SilentlyContinue
}
else
{
    Remove-Item alias:curl -ErrorAction SilentlyContinue
    Remove-Item alias:gc   -ErrorAction SilentlyContinue
    Remove-Item alias:gci  -ErrorAction SilentlyContinue
    Remove-Item alias:gcm  -ErrorAction SilentlyContinue
    Remove-Item alias:gl   -ErrorAction SilentlyContinue
    Remove-Item alias:type -ErrorAction SilentlyContinue
    Remove-Item alias:wget -ErrorAction SilentlyContinue
}

Get-ChildItem "$(Join-Path $PSScriptRoot "Autoload")\*.ps1"   | ForEach-Object { . $_ }
if ([System.Environment]::OSVersion.Platform -eq "Win32NT" )
{
    Get-ChildItem "$(Join-Path $PSScriptRoot "AutoloadWin32NT")\*.ps1"   | ForEach-Object { . $_ }
    $PrivatePSAutoladFolder = $(Join-Path $Env:USERPROFILE ".ps1_autoload")
    $PrivatePSAutoladFolderW = $(Join-Path $Env:USERPROFILE "OneDrive - ${Env:WORK_ONEDRIVE_SUFFIX}\bin\ps_autoload")
}

if ([System.Environment]::OSVersion.Platform -eq "Unix" )
{
    Get-ChildItem "$(Join-Path $PSScriptRoot "AutoloadUnix")\*.ps1"   | ForEach-Object { . $_ }
    $PrivatePSAutoladFolder = $(Join-Path $Env:HOME "OneDrive\bin\ps1_autoload")
    $PrivatePSAutoladFolderW = $(Join-Path $Env:HOME "OneDrive - ${Env:WORK_ONEDRIVE_SUFFIX}\bin\ps_autoload")
}

Get-ChildItem "$(Join-Path $PSScriptRoot "Completion")\*.ps1" | ForEach-Object { . $_ }

If (Test-Path $PrivatePSAutoladFolder)
{
    Get-ChildItem "$PrivatePSAutoladFolder\*.ps1" | ForEach-Object { . $_ }
}

If (Test-Path $PrivatePSAutoladFolderW)
{
    Get-ChildItem "$PrivatePSAutoladFolderW\*.ps1" | ForEach-Object { . $_ }
}

# Invovoke ANSI 256 Color Console
# chcp 65001
# AnsiColors256
AnsiConsole

# Write-Host "Welcome Home:"(Get-WmiObject -Class Win32_UserAccount -Filter "Name = '$env:USERNAME'").FullName
# Write-Host "Welcome Home: $(Split-Path (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object UserName).UserName -Leaf)"
