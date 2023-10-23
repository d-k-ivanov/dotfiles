<#
.SYNOPSIS
Mamba scripts.

.DESCRIPTION
Mamba scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command micromamba -ErrorAction SilentlyContinue | Test-Path)
{
    #region mamba initialize
    (& "micromamba" "shell" "hook" "-s" "powershell") | Out-String | Invoke-Expression
    #endregion
}
