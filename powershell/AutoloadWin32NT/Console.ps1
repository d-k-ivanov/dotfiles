<#
.SYNOPSIS
Console scripts.

.DESCRIPTION
Console scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# Clear screen
Set-Alias c Clear-Host

function Get-ConsoleCP
{
    return ($(chcp) -replace '[^0-9]','')
}
