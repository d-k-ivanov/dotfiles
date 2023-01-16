<#
.SYNOPSIS
PowerShell modules scripts.

.DESCRIPTION
PowerShell modules scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

$ModulesDir = Join-Path (Get-Item $PSScriptRoot).Parent.FullName "Modules"

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
    Import-Module (Join-Path $ModulesDir $module)
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
# $GitPromptSettings.RepositoriesInWhichToDisableFileStatus += "${Env:WORKSPACE}\clearcorrect\all_projects\cc-dev"   # Heavy work project

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
    Import-Module "$ChocolateyProfile"
}

function Get-Manually-Installed-Modules
{
    Get-Module -ListAvailable |
    Where-Object ModuleBase -like $env:ProgramFiles\WindowsPowerShell\Modules\* |
    Sort-Object -Property Name, Version -Descending |
    Get-Unique -PipelineVariable Module |
    ForEach-Object {
        if (-not(Test-Path -Path "$($_.ModuleBase)\PSGetModuleInfo.xml"))
        {
            Find-Module -Name $_.Name -OutVariable Repo -ErrorAction SilentlyContinue |
            Compare-Object -ReferenceObject $_ -Property Name, Version |
            Where-Object SideIndicator -eq '=>' |
            Select-Object -Property Name, Version, @{label='Repository';expression={$Repo.Repository}}, @{label='InstalledVersion';expression={$Module.Version}}
        }
    }
}
