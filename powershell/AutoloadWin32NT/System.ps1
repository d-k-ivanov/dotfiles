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
Set-Alias emptytrash EmptyRecycleBin

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
        $win32os = Get-CimInstance -ClassName Win32_OperatingSystem
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

# TMP
# Dism /Unmount-Image /?
# Dism /Unmount-Image /MountDir:C:\Temp\WIM /Commit
# Dism /Unmount-Image /MountDir:C:\Temp\WIM /Discard

# Dism /Mount-Image /ImageFile:C:\Temp\install.wim /Name:"Windows 10 Pro" /MountDir:C:\Temp\WIM
# Dism /Mount-Image /ImageFile:C:\Temp\install.wim /Name:"Windows 10 Pro" /MountDir:C:\Temp\WIM /ReadOnly

# Dism /Image:C:\Temp\WIM /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /All

# Dism /Image:C:\Temp\WIM /Get-Features
# Dism /Get-ImageInfo /ImageFile:C:\Temp\install.wim

# DISM /Image:C:\Temp\WIM /Cleanup-Image /RestoreHealth
# Dism /Online /Cleanup-Image /RestoreHealth /Source:wim:H:\sources\install.wim:1 /limitaccess ?????
#

function dism-sys-repair
{
    DISM.exe /Online /Cleanup-image /Restorehealth
    sfc /scannow
    cmd /c 'findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >"%userprofile%\Desktop\sfcdetails.txt"'

    # cat "${Env:USERPROFILE}\Desktop\sfcdetails.txt"

    # Check:
    # %WinDir%\WinSxS\Temp
    # %WinDir%\Logs\CBS\CBS.log

    # Replace a corrupted system file:
    # takeown /f Path_And_File_Name
    # icacls Path_And_File_Name /GRANT ADMINISTRATORS:F
    # copy Source_File Destination
}

function dism-hyperv-repair
{
    dism.exe /Online /Disable-Feature:Microsoft-Hyper-V
    Get-HnsNetwork | Remove-HnsNetwork
    netsh int ipv4 add excludedportrange protocol=tcp startport=50051 numberofports=1
    netsh int ipv4 set dynamic tcp start=49152 num=16384
    dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All
}
