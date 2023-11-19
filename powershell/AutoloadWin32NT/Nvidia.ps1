<#
.SYNOPSIS
Nvidia scripts.

.DESCRIPTION
Nvidia scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Get-NVAPIList
{
    $APILocations = @(
        'C:\NVAPI'
        'C:\Nvidia\NVAPI'
        'D:\NVAPI'
        'D:\Nvidia\NVAPI'
    )

    $APIs = @()
    foreach ($API in $APILocations)
    {
        if (Test-Path $API)
        {
            $((Get-ChildItem $API -Directory).FullName | ForEach-Object { $APIs += $_ })
        }
    }

    $APIValidated = @()
    foreach ($API in $APIs)
    {
        if (Test-Path "${API}\nvapi.h")
        {
            $APIValidated  += $API
        }
    }

    return $APIValidated
}

function Set-NVAPI
{
    $Selected = Select-From-List $(Get-NVAPIList) 'Nvidia API'
    [Environment]::SetEnvironmentVariable("NVAPI_LOCATION", ${Selected}, "Machine")
    $Env:NVAPI_LOCATION = ${Selected}
}

function Get-NsightAfterMath
{
    $APILocations = @(
        'C:\NsightAftermath'
        'C:\Nvidia\NsightAftermath'
        'D:\NsightAftermath'
        'D:\Nvidia\NsightAftermath'
    )

    $APIs = @()
    foreach ($API in $APILocations)
    {
        if (Test-Path $API)
        {
            $((Get-ChildItem $API -Directory).FullName | ForEach-Object { $APIs += $_ })
        }
    }

    $APIValidated = @()
    foreach ($API in $APIs)
    {
        if (Test-Path "${API}\include\GFSDK_Aftermath.h")
        {
            $APIValidated  += $API
        }
    }

    return $APIValidated
}

function Set-NsightAfterMath
{
    $Selected = Select-From-List $(Get-NsightAfterMath) 'Nvidia API'
    [Environment]::SetEnvironmentVariable("NSIGHT_AFTERMATH_SDK", ${Selected}, "Machine")
    $Env:NSIGHT_AFTERMATH_SDK = ${Selected}
}
