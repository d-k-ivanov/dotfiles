<#
.SYNOPSIS
Vulkan scripts.

.DESCRIPTION
Vulkan scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    exit
}

function Get-VulkanSDKList
{
    $SDKLocations = @(
        'C:\VulkanSDK'
        'D:\VulkanSDK'
    )

    $SDKs = @()
    foreach ($SDK in $SDKLocations)
    {
        if (Test-Path $SDK)
        {
            $((Get-ChildItem $SDK -Directory).FullName | ForEach-Object { $SDKs += $_ })
        }
    }

    $SDKValidated = @()
    foreach ($SDK in $SDKs)
    {
        if (Test-Path $SDK)
        {
            $SDKValidated += $SDK
        }
    }

    return $SDKValidated
}

function List-VulkanSDK
{
    $SDKs = Get-VulkanSDKList

    if ($SDKs)
    {
        Write-Host "List of Vulkan SDKs on this PC:"
        foreach ($SDK in $SDKs)
        {
            if ($($SDK -match '\d+.\d+.\d+.\d+'))
            {
                Write-Host " - $($Matches[0]) --> $SDK"
            }
        }
    }
    else
    {
        Write-Host "Vulkan SDKs on this PC has NOT found!" -ForegroundColor Red
    }
}

function Set-VulkanSDK
{
    $Selected = Select-From-List $(Get-VulkanSDKList) 'Vulkan SDK'
    [Environment]::SetEnvironmentVariable("VK_SDK_PATH", ${Selected}, "Machine")
    [Environment]::SetEnvironmentVariable("VULKAN_SDK", ${Selected}, "Machine")

    Set-Item -Path Env:VK_SDK_PATH -Value ${Selected}
    Set-Item -Path Env:VULKAN_SDK  -Value ${Selected}
    Set-Item -Path Env:PATH -Value "${Env:VULKAN_SDK}\Bin;${Env:PATH}"

    # Set VULKAN_HOME and VULKAN_DOWNLOAD
    $VulkanHome = Split-Path -Path ${Selected} -Parent
    [Environment]::SetEnvironmentVariable("VUKAN_HOME", ${VulkanHome}, "Machine")
    [Environment]::SetEnvironmentVariable("VUKAN_DOWNLOAD", "${VulkanHome}\Releases", "Machine")
    Set-Item -Path Env:VUKAN_HOME     -Value ${VulkanHome}
    Set-Item -Path Env:VUKAN_DOWNLOAD -Value "${VulkanHome}\Releases"
}

function Get-VulkanSDK
{
    if ($($Env:VULKAN_SDK -match '\d+.\d+.\d+.\d+'))
    {
        Write-Host " - $($Matches[0]) --> $Env:VULKAN_SDK"
    }
}

function Clear-VulkanSDK
{
    [Environment]::SetEnvironmentVariable("VK_SDK_PATH", [NullString]::Value, "Machine")
    [Environment]::SetEnvironmentVariable("VULKAN_SDK", [NullString]::Value, "Machine")
    if ($Env:VK_SDK_PATH) { Remove-Item Env:VK_SDK_PATH }
    if ($Env:VULKAN_SDK) { Remove-Item Env:VULKAN_SDK }

    # Clear VULKAN_HOME and VULKAN_DOWNLOAD
    [Environment]::SetEnvironmentVariable("VUKAN_HOME", [NullString]::Value, "Machine")
    [Environment]::SetEnvironmentVariable("VUKAN_DOWNLOAD", [NullString]::Value, "Machine")
    if ($Env:VUKAN_HOME) { Remove-Item Env:VUKAN_HOME }
    if ($Env:VUKAN_DOWNLOAD) { Remove-Item Env:VUKAN_DOWNLOAD }
}
