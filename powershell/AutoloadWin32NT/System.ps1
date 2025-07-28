<#
.SYNOPSIS
System scripts.

.DESCRIPTION
System scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    exit
}

# Empty the Recycle Bin on all drives
function EmptyRecycleBin
{
    $RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
    $RecBin.Items() | ForEach-Object { Remove-Item $_.Path -Recurse -Confirm:$false }
}
Set-Alias emptytrash Empty-RecycleBin

# Update installed Ruby Gems, NPM, and their installed packages.
function Update-System()
{
    # Install-WindowsUpdate -IgnoreUserInput -IgnoreReboot -AcceptAll
    Update-Module
    Update-Help -Force
    # scoop update
    gem update --system
    gem update
    npm install npm -g
    npm update -g
    cup all -y
}
Set-Alias update System-Update

function Get-WindowsKey
{
    ## function to retrieve the Windows Product Key from any PC
    ## by Jakob Bindslet (jakob@bindslet.dk)
    param
    (
        $targets = "."
    )
    $hklm = 2147483650
    $regPath = "Software\Microsoft\Windows NT\CurrentVersion"
    $regValue = "DigitalProductId"
    foreach ($target in $targets)
    {
        $productKey = $null
        $win32os = $null
        $wmi = [WMIClass]"\\$target\root\default:stdRegProv"
        $data = $wmi.GetBinaryValue($hklm, $regPath, $regValue)
        $binArray = ($data.uValue)[52..66]
        $charsArray = "B", "C", "D", "F", "G", "H", "J", "K", "M", "P", "Q", "R", "T", "V", "W", "X", "Y", "2", "3", "4", "6", "7", "8", "9"

        ## decrypt base24 encoded binary data
        for ($i = 24; $i -ge 0; $i--)
        {
            $k = 0
            for ($j = 14; $j -ge 0; $j--)
            {
                $k = $k * 256 -bxor $binArray[$j]
                $binArray[$j] = [math]::truncate($k / 24)
                $k = $k % 24
            }

            $productKey = $charsArray[$k] + $productKey
            if (($i % 5 -eq 0) -and ($i -ne 0))
            {
                $productKey = "-" + $productKey
            }
        }

        # Write-host "Here:" + $productKey
        $win32os = Get-WmiObject Win32_OperatingSystem -computer $target
        $obj = New-Object Object
        $obj | Add-Member Noteproperty Computer -Value $target
        $obj | Add-Member Noteproperty Caption -Value $win32os.Caption
        $obj | Add-Member Noteproperty CSDVersion -Value $win32os.CSDVersion
        $obj | Add-Member Noteproperty OSArch -Value $win32os.OSArchitecture
        $obj | Add-Member Noteproperty BuildNumber -Value $win32os.BuildNumber
        $obj | Add-Member Noteproperty RegisteredTo -Value $win32os.RegisteredUser
        $obj | Add-Member Noteproperty ProductID -Value $win32os.SerialNumber
        $obj | Add-Member Noteproperty ProductKey -Value $productkey
        $obj
    }
}

function  Get-WindowsBuildNumber
{
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    return [int]($os.BuildNumber)
}

function Get-WinFeatures
{
    Get-WindowsOptionalFeature -Online | Format-Table
}

function Get-WinFeatureInfo
{
    param
    (
        [String] $FeatureName
    )
    dism /online /Get-FeatureInfo /FeatureName:$FeatureName
}

function Get-SystemInfo
{
    Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property *
}
