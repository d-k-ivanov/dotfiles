<#
.SYNOPSIS
Browser scripts.

.DESCRIPTION
Browser scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

${function:just-the-browser} = { & ([scriptblock]::Create((irm "https://raw.githubusercontent.com/corbindavenport/just-the-browser/refs/tags/v1.2/main.ps1")))}
