<#
.SYNOPSIS
FastBuild environment.

.DESCRIPTION
FastBuild environment.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# FASTBUILD_TEMP_PATH              - Override system temp path for FASTBuild to use.
# FASTBUILD_BROKERAGE_PATH         - Set location of the Brokerage Path for distributed compilation.
# FASTBUILD_WORKERS                - Set the list of workers explicitly.
# FASTBUILD_CACHE_PATH             - Set the location of the cache.
# FASTBUILD_CACHE_PATH_MOUNT_POINT - Set the path to be verified as a mount point. (OSX & Linux)
# FASTBUILD_CACHE_MODE             - Set the cache mode.
function Set-FastBuildEnv
{
    [CmdletBinding()]
    param
    (
        [string] $Workers = "172.16.37.111"
    )

    # [Environment]::SetEnvironmentVariable("FASTBUILD_TEMP_PATH", "c:\f\tmp\", "Machine")
    # Set-Item -Path Env:FASTBUILD_TEMP_PATH -Value "c:\f\tmp\"

    # \\172.16.37.111\workers or local path
    # [Environment]::SetEnvironmentVariable("FASTBUILD_BROKERAGE_PATH", "c:\f\workers", "Machine")
    # Set-Item -Path Env:FASTBUILD_BROKERAGE_PATH -Value "c:\f\workers"

    [Environment]::SetEnvironmentVariable("FASTBUILD_WORKERS", ${Workers}, "Machine")
    Set-Item -Path Env:FASTBUILD_WORKERS -Value ${Workers}

    # [Environment]::SetEnvironmentVariable("FASTBUILD_CACHE_PATH_MOUNT_POINT", "???", "Machine")
    # Set-Item -Path Env:FASTBUILD_CACHE_PATH_MOUNT_POINT -Value "???"

    # [Environment]::SetEnvironmentVariable("FASTBUILD_CACHE_MODE", "-cache[read|write]", "Machine")
    # Set-Item -Path Env:FASTBUILD_CACHE_MODE -Value "-cache[read|write]"
}

function Unset-FastBuildEnv
{
    # [Environment]::SetEnvironmentVariable("FASTBUILD_TEMP_PATH", [NullString]::Value, "Machine")
    if ($Env:FASTBUILD_TEMP_PATH)
    {
        Remove-Item -Path Env:FASTBUILD_TEMP_PATH
    }

    # \\172.16.37.111\workers or local path
    # [Environment]::SetEnvironmentVariable("FASTBUILD_BROKERAGE_PATH", [NullString]::Value, "Machine")
    # if ($Env:FASTBUILD_BROKERAGE_PATH)
    # {
    #     Remove-Item -Path Env:FASTBUILD_BROKERAGE_PATH
    # }

    [Environment]::SetEnvironmentVariable("FASTBUILD_WORKERS", [NullString]::Value, "Machine")
    if ($Env:FASTBUILD_WORKERS)
    {
        Remove-Item -Path Env:FASTBUILD_WORKERS
    }

    # [Environment]::SetEnvironmentVariable("FASTBUILD_CACHE_PATH_MOUNT_POINT", [NullString]::Value, "Machine")
    # if ($Env:FASTBUILD_CACHE_PATH_MOUNT_POINT)
    # {
    #     Remove-Item -Path Env:FASTBUILD_CACHE_PATH_MOUNT_POINT
    # }

    # [Environment]::SetEnvironmentVariable("FASTBUILD_CACHE_MODE", [NullString]::Value, "Machine")
    # if ($Env:FASTBUILD_CACHE_MODE)
    # {
    #     Remove-Item -Path Env:FASTBUILD_CACHE_MODE
    # }
}
