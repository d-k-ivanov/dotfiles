<#
.SYNOPSIS
Security (SSH, SSL, GPG etc.) scripts.

.DESCRIPTION
Security (SSH, SSL, GPG etc.) scripts.
#>

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

${function:mount_meta_d} = { encfs ${env:MY_DROPBOX}\.meta M: }
${function:umount_meta_d} = { dokanctl /u M: }
Set-Alias -Name mmmm -Value mount_meta_d
Set-Alias -Name mmmu -Value umount_meta_d

${function:mount_meta_o} = { encfs ${env:MY_ONEDRIVE}\.meta O: }
${function:umount_meta_o} = { dokanctl /u O: }
Set-Alias -Name ooom -Value mount_meta_o
Set-Alias -Name ooou -Value umount_meta_o
