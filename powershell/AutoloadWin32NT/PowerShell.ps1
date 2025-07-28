<#
.SYNOPSIS
PowerShell scripts.

.DESCRIPTION
PowerShell scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    exit
}

# Sudo
function sudo()
{
    if ($args.Length -eq 1)
    {
        Start-Process $args[0] -Verb "runAs"
    }

    if ($args.Length -gt 1)
    {
        Start-Process $args[0] -ArgumentList $args[1..$args.Length] -Verb "runAs"
    }
}

function Reload-Powershell
{
    function Invoke-PowerShell
    {
        if ($PSVersionTable.PSEdition -eq "Core")
        {
            pwsh -ExecutionPolicy Bypass -NoLogo -NoExit
        }
        else
        {
            powershell -ExecutionPolicy Bypass -NoLogo -NoExit
        }
    }

    # $parentProcessId = (Get-WmiObject Win32_Process -Filter "ProcessId=$PID").ParentProcessId
    # $parentProcessName = (Get-WmiObject Win32_Process -Filter "ProcessId=$parentProcessId").ProcessName

    if ($host.Name -eq 'ConsoleHost')
    {
        Invoke-PowerShell
    }
    else
    {
        Write-Warning 'Only usable while in the PowerShell console host'
    }
    exit
}
Set-Alias reload Reload-Powershell

function Restart-Powershell
{
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
    $newProcess.Arguments = "-nologo"
    [System.Diagnostics.Process]::Start($newProcess)
    exit
}

function Refresh-Powershell
{
    . $profile
}
Set-Alias refresh Refresh-Powershell

function Get-DuplicatedModules
{
    Get-InstalledModule | ForEach-Object {
        $latestVersion = $PSItem.Version

        Write-Host "$($PSItem.Name) - $($PSItem.Version)" -ForegroundColor Green

        Get-InstalledModule $PSItem.Name -AllVersions |
        Where-Object Version -NE $latestVersion       | ForEach-Object {
            Write-Host "- $($PSItem.Name) - $($PSItem.Version)" -ForegroundColor Magenta
        }
    }
}

function Uninstall-DuplicatedModules
{
    Get-InstalledModule | ForEach-Object {
        $latestVersion = $PSItem.Version

        Write-Host "$($PSItem.Name) - $($PSItem.Version)" -ForegroundColor Green

        Get-InstalledModule $PSItem.Name -AllVersions |
        Where-Object Version -NE $latestVersion       | ForEach-Object {
            Write-Host "- Uninstalling version $($PSItem.Version)..." -ForegroundColor Magenta -NoNewline
            $PSItem | Uninstall-Module -Force
            Write-Host "done"
        }
    }
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
