##########
#region Gamer's Tweaks
##########

# Disable mouse pointer acceleration
function DisableMouseAcceleration
{
    Write-Output "Disabling mouse pointer acceleration..."
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "SmoothMouseXCurve" -Type Binary -Value ([byte[]](0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x15, 0x6e, 0x00, `
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, `
                0x29, 0xdc, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x28, 0x00, 0x00, 0x00, 0x00, 0x00))
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "SmoothMouseYCurve" -Type Binary -Value ([byte[]](0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfd, 0x11, 0x01, `
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x24, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, `
                0x00, 0xfc, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc0, 0xbb, 0x01, 0x00, 0x00, 0x00, 0x00))
}

# Enable mouse pointer acceleration
function EnableMouseAcceleration
{
    Write-Output "Enabling mouse pointer acceleration for 100 dpi..."
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSensitivity" -Type String -Value "10"
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "SmoothMouseXCurve" -Type Binary -Value ([byte[]](0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0xCC, 0x0C, `
                0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x99, 0x19, 0x00, 0x00, 0x00, 0x00, 0x00, `
                0x40, 0x66, 0x26, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x33, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00))
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "SmoothMouseYCurve" -Type Binary -Value ([byte[]](0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, `
                0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, `
                0x00, 0x00, 0xA8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE0, 0x00, 0x00, 0x00, 0x00, 0x00))
}

# Enable low ram
# Svchost.exe is known as "Service Host" or "Host Process for Windows Services".
# It’s a system process which is used by several Windows services since the release
# of Windows 2000 operating system. In previous Windows versions, several similar
# services were combined into a single svchost.exe process to reduce overall system
# resources consumption. But since the release of Windows 10 Creators Update, this
# behavior has been changed. Now in newer Windows 10 versions, the services which
# were grouped in previous Windows versions, are separated and run in their own Svchost process.
function DisableSVHostSplitThreshold
{
    # (default)   380000   #
    #  4 GB      4194304   #    16 GB     16777216
    #  6 GB      6291456   #    24 GB     25165824
    #  8 GB      8388608   #    32 GB     33554432
    # 12 GB     12582912   #    64 GB     67108864
    Write-Output "Disabling svhost split threshold..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value 33554432
}

# Disable low ram
function EnableSVHostSplitThreshold
{
    Write-Output "Enabling svhost split threshold..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value 380000
}

function DisablePageFileEncryption
{
    Write-Output "Disabling page file encryption..."
    fsutil behavior set encryptpagingfile 0 | Out-Null
}

function EnablePageFileEncryption
{
    Write-Output "Enabling page file encryption..."
    fsutil behavior set encryptpagingfile 1 | Out-Null
}

# The Heartbeat of Windows
function DisableTimeStampInterval
{
    Write-Output "Disabling TimeStampInterval..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" -Name "TimeStampInterval" -Type DWord -Value 0
}

function EnableTimeStampInterval
{
    Write-Output "Enabling TimeStampInterval..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Reliability" -Name "TimeStampInterval" -Type DWord -Value 1
}

##########
#endregion Gamer's Tweaks
##########
