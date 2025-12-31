##########
#region Network Tweaks
##########

# Set current network profile to private (allow file sharing, device discovery, etc.)
Function SetCurrentNetworkPrivate
{
    Write-Output "Setting current network profile to private..."
    Set-NetConnectionProfile -NetworkCategory Private
}

# Set current network profile to public (deny file sharing, device discovery, etc.)
Function SetCurrentNetworkPublic
{
    Write-Output "Setting current network profile to public..."
    Set-NetConnectionProfile -NetworkCategory Public
}

# Set unknown networks profile to private (allow file sharing, device discovery, etc.)
Function SetUnknownNetworksPrivate
{
    Write-Output "Setting unknown networks profile to private..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\010103000F0000F0010000000F0000F0C967A3643C3AD745950DA7859209176EF5B87C875FA20DF21951640E807D7C24"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\010103000F0000F0010000000F0000F0C967A3643C3AD745950DA7859209176EF5B87C875FA20DF21951640E807D7C24" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\010103000F0000F0010000000F0000F0C967A3643C3AD745950DA7859209176EF5B87C875FA20DF21951640E807D7C24" -Name "Category" -Type DWord -Value 1
}

# Set unknown networks profile to public (deny file sharing, device discovery, etc.)
Function SetUnknownNetworksPublic
{
    Write-Output "Setting unknown networks profile to public..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\010103000F0000F0010000000F0000F0C967A3643C3AD745950DA7859209176EF5B87C875FA20DF21951640E807D7C24" -Name "Category" -ErrorAction SilentlyContinue
}

# Disable automatic installation of network devices
Function DisableNetDevicesAutoInst
{
    Write-Output "Disabling automatic installation of network devices..."
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private" -Name "AutoSetup" -Type DWord -Value 0
}

# Enable automatic installation of network devices
Function EnableNetDevicesAutoInst
{
    Write-Output "Enabling automatic installation of network devices..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private" -Name "AutoSetup" -ErrorAction SilentlyContinue
}

# Stop and disable Home Groups services - Not applicable since 1803. Not applicable to Server
Function DisableHomeGroups
{
    Write-Output "Stopping and disabling Home Groups services..."
    If (Get-Service "HomeGroupListener" -ErrorAction SilentlyContinue)
    {
        Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue
        Set-Service "HomeGroupListener" -StartupType Disabled
    }
    If (Get-Service "HomeGroupProvider" -ErrorAction SilentlyContinue)
    {
        Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue
        Set-Service "HomeGroupProvider" -StartupType Disabled
    }
}

# Enable and start Home Groups services - Not applicable since 1803. Not applicable to Server
Function EnableHomeGroups
{
    Write-Output "Starting and enabling Home Groups services..."
    Set-Service "HomeGroupListener" -StartupType Manual
    Set-Service "HomeGroupProvider" -StartupType Manual
    Start-Service "HomeGroupProvider" -WarningAction SilentlyContinue
}

# Disable NetBIOS over TCP/IP on all currently installed network interfaces
Function DisableNetBIOS
{
    Write-Output "Disabling NetBIOS over TCP/IP..."
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces\Tcpip*" -Name "NetbiosOptions" -Type DWord -Value 2
}

# Enable NetBIOS over TCP/IP on all currently installed network interfaces
Function EnableNetBIOS
{
    Write-Output "Enabling NetBIOS over TCP/IP..."
    Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces\Tcpip*" -Name "NetbiosOptions" -Type DWord -Value 0
}

# Disable Link-Local Multicast Name Resolution (LLMNR) protocol
Function DisableLLMNR
{
    Write-Output "Disabling Link-Local Multicast Name Resolution (LLMNR)..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"))
    {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -Type DWord -Value 0
}

# Enable Link-Local Multicast Name Resolution (LLMNR) protocol
Function EnableLLMNR
{
    Write-Output "Enabling Link-Local Multicast Name Resolution (LLMNR)..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -ErrorAction SilentlyContinue
}

# Disable Local-Link Discovery Protocol (LLDP) for all installed network interfaces
Function DisableLLDP
{
    Write-Output "Disabling Local-Link Discovery Protocol (LLDP)..."
    Disable-NetAdapterBinding -Name "*" -ComponentID "ms_lldp"
}

# Enable Local-Link Discovery Protocol (LLDP) for all installed network interfaces
Function EnableLLDP
{
    Write-Output "Enabling Local-Link Discovery Protocol (LLDP)..."
    Enable-NetAdapterBinding -Name "*" -ComponentID "ms_lldp"
}

# Disable Local-Link Topology Discovery (LLTD) for all installed network interfaces
Function DisableLLTD
{
    Write-Output "Disabling Local-Link Topology Discovery (LLTD)..."
    Disable-NetAdapterBinding -Name "*" -ComponentID "ms_lltdio"
    Disable-NetAdapterBinding -Name "*" -ComponentID "ms_rspndr"
}

# Enable Local-Link Topology Discovery (LLTD) for all installed network interfaces
Function EnableLLTD
{
    Write-Output "Enabling Local-Link Topology Discovery (LLTD)..."
    Enable-NetAdapterBinding -Name "*" -ComponentID "ms_lltdio"
    Enable-NetAdapterBinding -Name "*" -ComponentID "ms_rspndr"
}

# Disable Client for Microsoft Networks for all installed network interfaces
Function DisableMSNetClient
{
    Write-Output "Disabling Client for Microsoft Networks..."
    Disable-NetAdapterBinding -Name "*" -ComponentID "ms_msclient"
}

# Enable Client for Microsoft Networks for all installed network interfaces
Function EnableMSNetClient
{
    Write-Output "Enabling Client for Microsoft Networks..."
    Enable-NetAdapterBinding -Name "*" -ComponentID "ms_msclient"
}

# Disable Quality of Service (QoS) packet scheduler for all installed network interfaces
Function DisableQoS
{
    Write-Output "Disabling Quality of Service (QoS) packet scheduler..."
    Disable-NetAdapterBinding -Name "*" -ComponentID "ms_pacer"
}

# Enable Quality of Service (QoS) packet scheduler for all installed network interfaces
Function EnableQoS
{
    Write-Output "Enabling Quality of Service (QoS) packet scheduler..."
    Enable-NetAdapterBinding -Name "*" -ComponentID "ms_pacer"
}

# Disable IPv4 stack for all installed network interfaces
Function DisableIPv4
{
    Write-Output "Disabling IPv4 stack..."
    Disable-NetAdapterBinding -Name "*" -ComponentID "ms_tcpip"
}

# Enable IPv4 stack for all installed network interfaces
Function EnableIPv4
{
    Write-Output "Enabling IPv4 stack..."
    Enable-NetAdapterBinding -Name "*" -ComponentID "ms_tcpip"
}

# Disable IPv6 stack for all installed network interfaces
Function DisableIPv6
{
    Write-Output "Disabling IPv6 stack..."
    Disable-NetAdapterBinding -Name "*" -ComponentID "ms_tcpip6"
}

# Enable IPv6 stack for all installed network interfaces
Function EnableIPv6
{
    Write-Output "Enabling IPv6 stack..."
    Enable-NetAdapterBinding -Name "*" -ComponentID "ms_tcpip6"
}

# Disable Network Connectivity Status Indicator active test
# Note: This may reduce the ability of OS and other components to determine internet access, however protects against a specific type of zero-click attack.
Function DisableNCSIProbe
{
    Write-Output "Disabling Network Connectivity Status Indicator (NCSI) active test..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" -Name "NoActiveProbe" -Type DWord -Value 1
}

# Enable Network Connectivity Status Indicator active test
Function EnableNCSIProbe
{
    Write-Output "Enabling Network Connectivity Status Indicator (NCSI) active test..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" -Name "NoActiveProbe" -ErrorAction SilentlyContinue
}

# Disable Internet Connection Sharing (e.g. mobile hotspot)
Function DisableConnectionSharing
{
    Write-Output "Disabling Internet Connection Sharing..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections" -Name "NC_ShowSharedAccessUI" -Type DWord -Value 0
}

# Enable Internet Connection Sharing (e.g. mobile hotspot)
Function EnableConnectionSharing
{
    Write-Output "Enabling Internet Connection Sharing..."
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections" -Name "NC_ShowSharedAccessUI" -ErrorAction SilentlyContinue
}

# Disable Remote Assistance - Not applicable to Server (unless Remote Assistance is explicitly installed)
Function DisableRemoteAssistance
{
    Write-Output "Disabling Remote Assistance..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0
    Get-WindowsCapability -Online | Where-Object { $_.Name -like "App.Support.QuickAssist*" } | Remove-WindowsCapability -Online | Out-Null
}

# Enable Remote Assistance - Not applicable to Server (unless Remote Assistance is explicitly installed)
Function EnableRemoteAssistance
{
    Write-Output "Enabling Remote Assistance..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 1
    Get-WindowsCapability -Online | Where-Object { $_.Name -like "App.Support.QuickAssist*" } | Add-WindowsCapability -Online | Out-Null
}

# Enable Remote Desktop
Function EnableRemoteDesktop
{
    Write-Output "Enabling Remote Desktop..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value 0
    Enable-NetFirewallRule -Name "RemoteDesktop*"
}

# Disable Remote Desktop
Function DisableRemoteDesktop
{
    Write-Output "Disabling Remote Desktop..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value 1
    Disable-NetFirewallRule -Name "RemoteDesktop*"
}

##########
#endregion Network Tweaks
##########
