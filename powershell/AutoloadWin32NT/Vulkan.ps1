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
    Set-Item -Path Env:VK_SDK_PATH -Value ${Selected}
    Set-Item -Path Env:VULKAN_SDK  -Value ${Selected}
    Set-Item -Path Env:PATH -Value "${Env:VULKAN_SDK}\Bin;${Env:PATH}"
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
    [Environment]::SetEnvironmentVariable("VK_SDK_PATH", [NullString]::Value, "Machine")
    [Environment]::SetEnvironmentVariable("VULKAN_SDK",  [NullString]::Value, "Machine")
    if ($Env:VK_SDK_PATH) { Remove-Item Env:VK_SDK_PATH }
    if ($Env:VULKAN_SDK)  { Remove-Item Env:VULKAN_SDK  }
}
