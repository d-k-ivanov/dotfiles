<#
.SYNOPSIS
MSYS scripts.

.DESCRIPTION
MSYS scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Use-Msys2
{
    [CmdletBinding()]
    param
    (
        [string] $toolchain = 'mingw64'
    )
    $msys_path = $(Get-Command msys2.exe -ErrorAction SilentlyContinue | Split-Path)

    if ($msys_path)
    {
        $msys_bin_path  = $(Join-Path $msys_path "usr\bin")
        $toolchain_bin_path = $(Join-Path $msys_path "${toolchain}\bin")
        Set-Item -Path Env:PATH -Value "${msys_bin_path};${toolchain_bin_path};${Env:PATH}"
    }
    else
    {
        Write-Host "ERROR: MSYS2 not found. Exiting..." -ForegroundColor Red
        return
    }
}
