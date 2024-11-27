<#
.SYNOPSIS
Security (SSH, SSL, GPG etc.) scripts.

.DESCRIPTION
Security (SSH, SSL, GPG etc.) scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red`
    Exit
}

function Set-DropboxLocation
{
    $StorageLocations = @(
        "C:\Dropbox"
        "D:\Dropbox"
        "${env:USERPROFILE}\Dropbox"
    )

    $StorageLocationsValidated = @()
    foreach ($Storage in $StorageLocations)
    {
        if (Test-Path $Storage)
        {
            $StorageLocationsValidated += $Storage
        }
    }

    $Selected = Select-From-List $StorageLocationsValidated 'Dropbox'
    [Environment]::SetEnvironmentVariable("MY_DROPBOX", ${Selected}, "Machine")
    Set-Item -Path Env:MY_DROPBOX -Value ${Selected}
}

function Set-OneDriveLocation
{
    $StorageLocations = @(
        "C:\OneDrive"
        "D:\OneDrive"
        "${env:USERPROFILE}\OneDrive"
    )

    $StorageLocationsValidated = @()
    foreach ($Storage in $StorageLocations)
    {
        if (Test-Path $Storage)
        {
            $StorageLocationsValidated += $Storage
        }
    }

    $Selected = Select-From-List $StorageLocationsValidated 'OneDrive'
    [Environment]::SetEnvironmentVariable("MY_ONEDRIVE", ${Selected}, "Machine")
    Set-Item -Path Env:MY_ONEDRIVE -Value ${Selected}
}
