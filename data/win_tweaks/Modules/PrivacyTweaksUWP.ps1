##########
#region Privacy Tweaks UWP
##########
# Universal Windows Platform (UWP) is an API for common application and device controls unified for all devices capable of running Windows 10.
# UWP applications are running sandboxed and the user can control devices and capabilities available to them.

# Disable UWP apps background access - ie. if UWP apps can download data or update themselves when they aren't used
# Until 1809, Cortana and ShellExperienceHost need to be explicitly excluded as their inclusion breaks start menu search and toast notifications respectively.
Function DisableUWPBackgroundApps
{
    Write-Output "Disabling UWP apps background access..."
    If ([System.Environment]::OSVersion.Version.Build -ge 17763)
    {
        If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
        {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsRunInBackground" -Type DWord -Value 2
    }
    Else
    {
        Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Exclude "Microsoft.Windows.Cortana*", "Microsoft.Windows.ShellExperienceHost*" | ForEach-Object {
            Set-ItemProperty -Path $_.PsPath -Name "Disabled" -Type DWord -Value 1
            Set-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -Type DWord -Value 1
        }
    }
}

# Enable UWP apps background access
Function EnableUWPBackgroundApps
{
    Write-Output "Enabling UWP apps background access..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsRunInBackground" -ErrorAction SilentlyContinue
    Get-ChildItem -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" | ForEach-Object {
        Remove-ItemProperty -Path $_.PsPath -Name "Disabled" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $_.PsPath -Name "DisabledByUser" -ErrorAction SilentlyContinue
    }
}

# Disable access to voice activation from UWP apps
Function DisableUWPVoiceActivation
{
    Write-Output "Disabling access to voice activation from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsActivateWithVoice" -Type DWord -Value 2
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsActivateWithVoiceAboveLock" -Type DWord -Value 2
}

# Enable access to voice activation from UWP apps
Function EnableUWPVoiceActivation
{
    Write-Output "Enabling access to voice activation from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsActivateWithVoice" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsActivateWithVoiceAboveLock" -ErrorAction SilentlyContinue
}

# Disable access to notifications from UWP apps
Function DisableUWPNotifications
{
    Write-Output "Disabling access to notifications from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessNotifications" -Type DWord -Value 2
}

# Enable access to notifications from UWP apps
Function EnableUWPNotifications
{
    Write-Output "Enabling access to notifications from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessNotifications" -ErrorAction SilentlyContinue
}

# Disable access to account info from UWP apps
Function DisableUWPAccountInfo
{
    Write-Output "Disabling access to account info from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo" -Type DWord -Value 2
}

# Enable access to account info from UWP apps
Function EnableUWPAccountInfo
{
    Write-Output "Enabling access to account info from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessAccountInfo" -ErrorAction SilentlyContinue
}

# Disable access to contacts from UWP apps
Function DisableUWPContacts
{
    Write-Output "Disabling access to contacts from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessContacts" -Type DWord -Value 2
}

# Enable access to contacts from UWP apps
Function EnableUWPContacts
{
    Write-Output "Enabling access to contacts from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessContacts" -ErrorAction SilentlyContinue
}

# Disable access to calendar from UWP apps
Function DisableUWPCalendar
{
    Write-Output "Disabling access to calendar from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCalendar" -Type DWord -Value 2
}

# Enable access to calendar from UWP apps
Function EnableUWPCalendar
{
    Write-Output "Enabling access to calendar from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCalendar" -ErrorAction SilentlyContinue
}

# Disable access to phone calls from UWP apps
Function DisableUWPPhoneCalls
{
    Write-Output "Disabling access to phone calls from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessPhone" -Type DWord -Value 2
}

# Enable access to phone calls from UWP apps
Function EnableUWPPhoneCalls
{
    Write-Output "Enabling access to phone calls from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessPhone" -ErrorAction SilentlyContinue
}

# Disable access to call history from UWP apps
Function DisableUWPCallHistory
{
    Write-Output "Disabling access to call history from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCallHistory" -Type DWord -Value 2
}

# Enable access to call history from UWP apps
Function EnableUWPCallHistory
{
    Write-Output "Enabling access to call history from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessCallHistory" -ErrorAction SilentlyContinue
}

# Disable access to email from UWP apps
Function DisableUWPEmail
{
    Write-Output "Disabling access to email from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessEmail" -Type DWord -Value 2
}

# Enable access to email from UWP apps
Function EnableUWPEmail
{
    Write-Output "Enabling access to email from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessEmail" -ErrorAction SilentlyContinue
}

# Disable access to tasks from UWP apps
Function DisableUWPTasks
{
    Write-Output "Disabling access to tasks from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessTasks" -Type DWord -Value 2
}

# Enable access to tasks from UWP apps
Function EnableUWPTasks
{
    Write-Output "Enabling access to tasks from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessTasks" -ErrorAction SilentlyContinue
}

# Disable access to messaging (SMS, MMS) from UWP apps
Function DisableUWPMessaging
{
    Write-Output "Disabling access to messaging from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessMessaging" -Type DWord -Value 2
}

# Enable access to messaging from UWP apps
Function EnableUWPMessaging
{
    Write-Output "Enabling access to messaging from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessMessaging" -ErrorAction SilentlyContinue
}

# Disable access to radios (e.g. Bluetooth) from UWP apps
Function DisableUWPRadios
{
    Write-Output "Disabling access to radios from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessRadios" -Type DWord -Value 2
}

# Enable access to radios from UWP apps
Function EnableUWPRadios
{
    Write-Output "Enabling access to radios from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsAccessRadios" -ErrorAction SilentlyContinue
}

# Disable access to other devices (unpaired, beacons, TVs etc.) from UWP apps
Function DisableUWPOtherDevices
{
    Write-Output "Disabling access to other devices from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsSyncWithDevices" -Type DWord -Value 2
}

# Enable access to other devices from UWP apps
Function EnableUWPOtherDevices
{
    Write-Output "Enabling access to other devices from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsSyncWithDevices" -ErrorAction SilentlyContinue
}

# Disable access to diagnostic information from UWP apps
Function DisableUWPDiagInfo
{
    Write-Output "Disabling access to diagnostic information from UWP apps..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsGetDiagnosticInfo" -Type DWord -Value 2
}

# Enable access to diagnostic information from UWP apps
Function EnableUWPDiagInfo
{
    Write-Output "Enabling access to diagnostic information from UWP apps..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsGetDiagnosticInfo" -ErrorAction SilentlyContinue
}

# Disable access to libraries and file system from UWP apps
Function DisableUWPFileSystem
{
    Write-Output "Disabling access to libraries and file system from UWP apps..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" -Name "Value" -Type String -Value "Deny"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" -Name "Value" -Type String -Value "Deny"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" -Name "Value" -Type String -Value "Deny"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" -Name "Value" -Type String -Value "Deny"
}

# Enable access to libraries and file system from UWP apps
Function EnableUWPFileSystem
{
    Write-Output "Enabling access to libraries and file system from UWP apps..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" -Name "Value" -Type String -Value "Allow"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" -Name "Value" -Type String -Value "Allow"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" -Name "Value" -Type String -Value "Allow"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" -Name "Value" -Type String -Value "Allow"
}

# Disable UWP apps swap file
# This disables creation and use of swapfile.sys and frees 256 MB of disk space. Swapfile.sys is used only by UWP apps. The tweak has no effect on the real swap in pagefile.sys.
Function DisableUWPSwapFile
{
    Write-Output "Disabling UWP apps swap file..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "SwapfileControl" -Type Dword -Value 0
}

# Enable UWP apps swap file
Function EnableUWPSwapFile
{
    Write-Output "Enabling UWP apps swap file..."
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "SwapfileControl" -ErrorAction SilentlyContinue
}

##########
#endregion Privacy Tweaks UWP
##########
