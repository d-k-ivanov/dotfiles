<#
.SYNOPSIS
Sound scripts.

.DESCRIPTION
Sound scripts.
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

function Stop-Beeper
{
    # sc config beep start= disabled
    net stop beep
}
