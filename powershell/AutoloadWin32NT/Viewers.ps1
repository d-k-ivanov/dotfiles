<#
.SYNOPSIS
View scripts.

.DESCRIPTION
View scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function lesscsv([string] $FilePath)
{
    if (-not (Test-Path $FilePath -PathType Leaf))
    {
        Write-Host "File not found: $FilePath" -ForegroundColor Red
        return 1
    }

    Get-Content $FilePath |
        ConvertFrom-Csv |
        Format-Table -Property * -AutoSize |
        Out-String -Width ([int]::MaxValue - 1) |
        less -#2 -N -S
}
