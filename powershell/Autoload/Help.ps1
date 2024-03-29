<#
.SYNOPSIS
Information and Help scripts.

.DESCRIPTION
Information and Help scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# Get help from cheat.sh
function cht
{
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$Language,
        [Parameter(Mandatory=$true,ValueFromRemainingArguments=$true)]
        [psobject[]]$SearchString
    )
    $site = "cheat.sh/" + $Language + "/" + ($SearchString -join '+')

    if (Get-Command curl -ErrorAction SilentlyContinue | Test-Path)
    {
        curl $site
    }
}

# Show command definiton
Remove-Item alias:type -ErrorAction SilentlyContinue
${function:type}  = { if ($args[0] -and -Not $args[1]) { (Get-Command ${args}).Definition } else {Write-Host "Wrong command!`nUsage: show <command>"}}
Set-Alias show type
