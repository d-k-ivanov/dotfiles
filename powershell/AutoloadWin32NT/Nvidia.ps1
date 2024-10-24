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

function NsightLegacyDebugger-On
{
    [Environment]::SetEnvironmentVariable("CUDBG_USE_LEGACY_DEBUGGER", 1, "Machine")
    Set-Item -Path Env:CUDBG_USE_LEGACY_DEBUGGER -Value 1
}

function NsightLegacyDebugger-Off
{
    [Environment]::SetEnvironmentVariable("CUDBG_USE_LEGACY_DEBUGGER", $null, "Machine")
    if ($Env:CUDBG_USE_LEGACY_DEBUGGER)
    {
        Remove-Item Env:CUDBG_USE_LEGACY_DEBUGGER
    }
}

function NsightCUDADebugger-On
{
    [Environment]::SetEnvironmentVariable("NSIGHT_CUDA_DEBUGGER", 1, "Machine")
    Set-Item -Path Env:NSIGHT_CUDA_DEBUGGER -Value 1
}

function NsightCUDADebugger-Off
{
    [Environment]::SetEnvironmentVariable("NSIGHT_CUDA_DEBUGGER", $null, "Machine")
    if ($Env:NSIGHT_CUDA_DEBUGGER)
    {
        Remove-Item Env:CUDBG_USE_LEGACY_DEBUGGER
    }
}

function NsightDebuggerPreemption-On
{
    [Environment]::SetEnvironmentVariable("CUDA_DEBUGGER_SOFTWARE_PREEMPTION", 1, "Machine")
    Set-Item -Path Env:CUDA_DEBUGGER_SOFTWARE_PREEMPTION -Value 1
}


function NsightDebuggerPreemption-Off
{
    [Environment]::SetEnvironmentVariable("CUDA_DEBUGGER_SOFTWARE_PREEMPTION", $null, "Machine")
    if ($Env:CUDA_DEBUGGER_SOFTWARE_PREEMPTION)
    {
        Remove-Item Env:CUDBG_USE_LEGACY_DEBUGGER
    }
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
    Set-Item -Path Env:NVAPI_LOCATION -Value ${Selected}
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
    Set-Item -Path Env:NSIGHT_AFTERMATH_SDK -Value ${Selected}
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
    Set-Item -Path Env:OptiX_INSTALL_DIR -Value ${Selected}
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
    [Environment]::SetEnvironmentVariable("DEVIL_PATH",     "${Selected}",                 "Machine")
    [Environment]::SetEnvironmentVariable("IL_INCLUDE_DIR", "${Selected}\include",         "Machine")
    [Environment]::SetEnvironmentVariable("IL_LIBRARIES",   "${Selected}\lib\x64\Release", "Machine")
    [Environment]::SetEnvironmentVariable("ILU_LIBRARIES",  "${Selected}\lib\x64\Release", "Machine")
    [Environment]::SetEnvironmentVariable("ILUT_LIBRARIES", "${Selected}\lib\x64\Release", "Machine")
    Set-Item -Path Env:DEVIL_PATH     -Value "${Selected}"
    Set-Item -Path Env:IL_INCLUDE_DIR -Value "${Selected}\include"
    Set-Item -Path Env:IL_LIBRARIES   -Value "${Selected}\lib\x64\Release"
    Set-Item -Path Env:ILU_LIBRARIES  -Value "${Selected}\lib\x64\Release"
    Set-Item -Path Env:ILUT_LIBRARIES -Value "${Selected}\lib\x64\Release"
}

function Get-CuDNN
{
    $Locations = @(
        'C:\Nvidia\cudnn'
        'C:\Program Files\NVIDIA\CUDNN'
        'D:\Nvidia\cudnn'
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
        if (Test-Path "${LIB}\include\cudnn.h")
        {
            $LIBsValidated  += $LIB
        }
    }

    return $LIBsValidated
}

function Set-CuDNN
{
    $Selected = Select-From-List $(Get-CuDNN) 'CUDA Deep Neural Network library (CuDNN)'
    [Environment]::SetEnvironmentVariable("CUDNN",             "${Selected}",         "Machine")
    [Environment]::SetEnvironmentVariable("CUDNN_PATH",        "${Selected}",         "Machine")
    [Environment]::SetEnvironmentVariable("CUDNN_ROOT_DIR",    "${Selected}",         "Machine")
    [Environment]::SetEnvironmentVariable("CUDNN_DLL_DIR",     "${Selected}\bin",     "Machine")
    [Environment]::SetEnvironmentVariable("CUDNN_INCLUDE_DIR", "${Selected}\include", "Machine")
    [Environment]::SetEnvironmentVariable("CUDNN_LIBRARY",     "${Selected}\lib\x64", "Machine")
    Set-Item -Path Env:CUDNN             -Value "${Selected}"
    Set-Item -Path Env:CUDNN_PATH        -Value "${Selected}"
    Set-Item -Path Env:CUDNN_ROOT_DIR    -Value "${Selected}"
    Set-Item -Path Env:CUDNN_DLL_DIR     -Value "${Selected}\bin"
    Set-Item -Path Env:CUDNN_INCLUDE_DIR -Value "${Selected}\include"
    Set-Item -Path Env:CUDNN_LIBRARY     -Value "${Selected}\lib\x64"
}

function UnSet-CuDNN
{
    [Environment]::SetEnvironmentVariable("CUDNN",             $null, "Machine")
    [Environment]::SetEnvironmentVariable("CUDNN_PATH",        $null, "Machine")
    [Environment]::SetEnvironmentVariable("CUDNN_ROOT_DIR",    $null, "Machine")
    [Environment]::SetEnvironmentVariable("CUDNN_DLL_DIR",     $null, "Machine")
    [Environment]::SetEnvironmentVariable("CUDNN_INCLUDE_DIR", $null, "Machine")
    [Environment]::SetEnvironmentVariable("CUDNN_LIBRARY",     $null, "Machine")
    Remove-Item Env:CUDNN
    Remove-Item Env:CUDNN_PATH
    Remove-Item Env:CUDNN_ROOT_DIR
    Remove-Item Env:CUDNN_DLL_DIR
    Remove-Item Env:CUDNN_INCLUDE_DIR
    Remove-Item Env:CUDNN_LIBRARY
}
