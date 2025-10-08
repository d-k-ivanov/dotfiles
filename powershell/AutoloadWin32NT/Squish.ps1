<#
.SYNOPSIS
Squish scripts.

.DESCRIPTION
Squish scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if ($env:SQUISH_PATH)
{
    if (Get-Command "${Env:SQUISH_PATH}\..\python\python" -ErrorAction SilentlyContinue | Test-Path)
    {
        ${function:vc3-squish}  = { & ${Env:SQUISH_PATH}\..\python\python -m venv venv }
    }
}

function Get-SquishList
{
    $mash = @(
        'C:\tools\Squish-x64'
        'C:\tools\Squish-x86'
    )
    return $mash
}

function Set-Squish
{
    $mash = Get-SquishList
    $SquishVersions = @()

    foreach ($squish in $mash)
    {
        if (Test-Path $squish)
        {
            $SquishVersions += $squish
        }
    }

    $ChoosenSquishVersion = Select-From-List $SquishVersions "Squish Version"
    [Environment]::SetEnvironmentVariable("SQUISH_PATH", $ChoosenSquishVersion, "Machine")
    [Environment]::SetEnvironmentVariable("SQUISH_LICENSEKEY_DIR", $ChoosenSquishVersion, "Machine")
    [Environment]::SetEnvironmentVariable("SquishBinDir", "${ChoosenSquishVersion}\bin", "Machine")

    # Set-Env
}

function Clear-Squish
{
    [Environment]::SetEnvironmentVariable("SQUISH_PATH", [NullString]::Value, "Machine")
    if ($env:SQUISH_PATH)
    {
        Remove-Item Env:SQUISH_PATH
    }
    # Set-Env
}
