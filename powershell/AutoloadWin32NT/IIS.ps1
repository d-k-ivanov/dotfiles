<#
.SYNOPSIS
IIS scripts.

.DESCRIPTION
IIS scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# Start IIS Express Server with an optional path and port
function Start-IISExpress
{
    [CmdletBinding()]
    param
    (
        [String] $path = (Get-Location).Path,
        [Int32]  $port = 3000
    )
    if ((Test-Path "${Env:ProgramFiles}\IIS Express\iisexpress.exe") -or (Test-Path "${Env:ProgramFiles(x86)}\IIS Express\iisexpress.exe"))
    {
        $iisExpress = Resolve-Path "${Env:ProgramFiles}\IIS Express\iisexpress.exe" -ErrorAction SilentlyContinue
        if (-Not $iisExpress) { $iisExpress = Get-Item "${Env:ProgramFiles(x86)}\IIS Express\iisexpress.exe" }
        & $iisExpress @("/path:${path}") /port:$port
    }
    else
    {
        Write-Warning "Unable to find iisexpress.exe"
    }
}
