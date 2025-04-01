<#
.SYNOPSIS
WSL scripts.

.DESCRIPTION
WSL scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

${function:bash-wsl}    = { conemu-cyg-64.exe --wsl -cur_console:h0 }

function Find-WSL()
{
    wslconfig /l @args
}

function Remove-WSL()
{
    wslconfig /u @args
}

function Set-WSL()
{
    wslconfig /s @args
}

function Stop-WSL()
{
    wslconfig /t @args
}

function Update-WSL()
{
    wslconfig /upgrade @args
}

function Get-WSL-UUID()
{
    Get-ChildItem -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss
}

function Get-WSL-UUID-Short()
{
    (Get-ChildItem -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss).Name
}
function List-WSLDistros()
{
    wsl --list -v
}

function wsl-fix-anyconnect()
{
    Get-NetAdapter | Where-Object {$_.InterfaceDescription -Match "Cisco AnyConnect"} | Set-NetIPInterface -InterfaceMetric 4000
    Get-NetIPInterface -InterfaceAlias "vEthernet (WSL)" | Set-NetIPInterface -InterfaceMetric 1
}

###
# Get-DnsClientServerAddress -AddressFamily IPv6 | Where-Object ServerAddresses -NE "{}" | Select-Object -ExpandProperty InterfaceAlias
# Get-NetAdapterBinding -ComponentID ms_tcpip6 | Where-Object Name -In (Get-DnsClientServerAddress -AddressFamily IPv6 | Where-Object ServerAddresses -NE "{}" | Select-Object -ExpandProperty InterfaceAlias)
# Disable-NetAdapterBinding -Name ".............." -ComponentID ms_tcpip6 -PassThru
# Disable-NetAdapterBinding -Name ".............." -ComponentID ms_tcpip6 -PassThru
# Disable-NetAdapterBinding -Name ".............." -ComponentID ms_tcpip6 -PassThru
# Disable-NetAdapterBinding -Name ".............." -ComponentID ms_tcpip6 -PassThru

function wsl-shrink-vhdx()
{
    wsl --shutdown
    wsl --manage Ubuntu-24.04 --set-sparse false
    Optimize-VHD -Path "${$Env:LOCALAPPDATA}\Packages\CanonicalGroupLimited.Ubuntu24.04LTS_79rhkp1fndgsc\LocalState\ext4.vhdx" -Mode Full
}
