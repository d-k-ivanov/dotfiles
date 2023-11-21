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


function Get-OptiX
{
    $SDKLocations = @(
        'C:\Nvidia'
        'D:\Nvidia'
        'C:\ProgramData\NVIDIA Corporation'
        'C:\Program Files\NVIDIA Corporation'
        'C:\Program Files (x86)\NVIDIA Corporation'
        'D:\ProgramData\NVIDIA Corporation'
        'D:\Program Files\NVIDIA Corporation'
        'D:\Program Files (x86)\NVIDIA Corporation'
    )

    $SDKs = @()
    foreach ($SDK in $SDKLocations)
    {
        if (Test-Path $SDK)
        {
            $Result = (Get-ChildItem ${SDK} -Filter "*OptiX*" -File -Recurse -Include optix.h).FullName
            if ($Result)
            {
                $SDKs += (Get-Item $Result).Directory.Parent.FullName
            }
        }
    }

    return $SDKs
}

function Set-OptiX
{
    $Selected = Select-From-List $(Get-OptiX) 'Nvidia OptiX'
    [Environment]::SetEnvironmentVariable("OptiX_INSTALL_DIR", ${Selected}, "Machine")
    $Env:OptiX_INSTALL_DIR = ${Selected}
}

function Get-DevIL
{
    $Locations = @(
        'C:\Nvidia\DevIL'
        'D:\Nvidia\DevIL'
    )

    $LIBs = @()
    foreach ($SubFolder in $Locations)
    {
        if (Test-Path $SubFolder)
        {
            $((Get-ChildItem $SubFolder -Directory).FullName | ForEach-Object { $LIBs += $_ })
        }
    }

    $LIBsValidated = @()
    foreach ($LIB in $LIBs)
    {
        if (Test-Path "${LIB}\include\IL\DevIL.i")
        {
            $LIBsValidated  += $LIB
        }
    }

    return $LIBsValidated
}

function Set-DevIL
{
    $Selected = Select-From-List $(Get-DevIL) 'Developers Image Library (DevIL)'
    [Environment]::SetEnvironmentVariable("DEVIL_PATH",     "${Selected}",                   "Machine")
    [Environment]::SetEnvironmentVariable("IL_INCLUDE_DIR", "${Selected}\include",         "Machine")
    [Environment]::SetEnvironmentVariable("IL_LIBRARIES",   "${Selected}\lib\x64\Release", "Machine")
    [Environment]::SetEnvironmentVariable("ILU_LIBRARIES",  "${Selected}\lib\x64\Release", "Machine")
    [Environment]::SetEnvironmentVariable("ILUT_LIBRARIES", "${Selected}\lib\x64\Release", "Machine")
    $Env:DEVIL_PATH     = "${Selected}"
    $Env:IL_INCLUDE_DIR = "${Selected}\include"
    $Env:IL_LIBRARIES   = "${Selected}\lib\x64\Release"
    $Env:ILU_LIBRARIES  = "${Selected}\lib\x64\Release"
    $Env:ILUT_LIBRARIES = "${Selected}\lib\x64\Release"
}
