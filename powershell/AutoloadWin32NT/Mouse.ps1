<#
.SYNOPSIS
Mouse scripts.

.DESCRIPTION
Mouse scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

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
