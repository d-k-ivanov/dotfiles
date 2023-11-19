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
    Exit
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
            $SDKValidated  += $SDK
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
            if ($($SDK -Match '\d+.\d+.\d+.\d+'))
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
    $Env:VK_SDK_PATH = ${Selected}
    $Env:VULKAN_SDK = ${Selected}
    $Env:PATH = "${Env:VULKAN_SDK}\Bin;${Env:PATH}"
}

function Get-VulkanSDK
{
    if ($($Env:VULKAN_SDK -Match '\d+.\d+.\d+.\d+'))
    {
        Write-Host " - $($Matches[0]) --> $Env:VULKAN_SDK"
    }
}

function Clear-VulkanSDK
{
    [Environment]::SetEnvironmentVariable("VK_SDK_PATH", $null, "Machine")
    [Environment]::SetEnvironmentVariable("VULKAN_SDK", $null, "Machine")
    if ($Env:VK_SDK_PATH) { Remove-Item Env:VK_SDK_PATH }
    if ($Env:VULKAN_SDK)  { Remove-Item Env:VULKAN_SDK  }
}
