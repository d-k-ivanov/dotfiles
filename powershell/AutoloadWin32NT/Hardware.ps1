<#
.SYNOPSIS
Hardware scripts.

.DESCRIPTION
Hardware scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# http://xkcd.com/530/
Set-Alias mute Set-SoundMute
Set-Alias unmute Set-SoundUnmute

# Power
${function:Set-Power-Max}       = { powercfg.exe /SETACTIVE SCHEME_MIN }
${function:Set-Power-Balanced}  = { powercfg.exe /SETACTIVE SCHEME_BALANCED }
${function:Set-Power-Min}       = { powercfg.exe /SETACTIVE SCHEME_MAX }
${function:Add-Power-ULT}       = { powercfg.exe -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 }

function Get-MouseHorizontalScrollDirection
{
    Write-Host "`nSelect the Mouse's Device ID:`n"
    $Selected = Select-From-List $((Get-PnpDevice -Class Mouse -PresentOnly -Status OK).InstanceId) 'Mouse Device ID'

    $currentMode = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\${Selected}\Device Parameters").FlipFlopHScroll
    Write-Host "`nFlipFlopHScroll for the Mouse ${Selected} is set to ${currentMode}`n"
}

function Set-MouseHorizontalScrollDirection
{
    Write-Host "`nSelect the Mouse's Device ID:`n"
    $Selected = Select-From-List $((Get-PnpDevice -Class Mouse -PresentOnly -Status OK).InstanceId) 'Mouse Device ID'

    Write-Host "`nSelect the FlipFlopHScroll Mode:`n"
    $Mode = Select-From-List $(0,1) 'Mouse Device ID'
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\${Selected}\Device Parameters" -Name FlipFlopHScroll -Value $Mode

    $currentMode = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\${Selected}\Device Parameters").FlipFlopHScroll
    Write-Host "`nFlipFlopHScroll for the Mouse ${Selected} is set to ${currentMode}`n"
}

function Get-MouseVerticallScrollDirection
{
    Write-Host "`nSelect the Mouse's Device ID:`n"
    $Selected = Select-From-List $((Get-PnpDevice -Class Mouse -PresentOnly -Status OK).InstanceId) 'Mouse Device ID'

    $currentMode = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\${Selected}\Device Parameters").FlipFlopWheel
    Write-Host "`nFlipFlopWheel for the Mouse ${Selected} is set to ${currentMode}`n"
}


function Set-MouseVerticallScrollDirection
{
    Write-Host "`nSelect the Mouse's Device ID:`n"
    $Selected = Select-From-List $((Get-PnpDevice -Class Mouse -PresentOnly -Status OK).InstanceId) 'Mouse Device ID'

    Write-Host "`nSelect the FlipFlopWheel Mode:`n"
    $Mode = Select-From-List $(0,1) 'Mouse Device ID'
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\${Selected}\Device Parameters" -Name FlipFlopWheel -Value $Mode

    $currentMode = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Enum\${Selected}\Device Parameters").FlipFlopWheel
    Write-Host "`nFlipFlopWheel for the Mouse ${Selected} is set to ${currentMode}`n"
}
