<#
.SYNOPSIS
Keyboard scripts.

.DESCRIPTION
Keyboard scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

Function EnableDifferentInputMethodForEachApp
{
    $prefMask = (Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask').UserPreferencesMask
    if (($prefMask[4] -band 0x80) -eq 0)
    {
        $prefMask[4] = ($prefMask[4] -bor 0x80)
        New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value $prefMask -PropertyType ([Microsoft.Win32.RegistryValueKind]::Binary) -Force | Out-Null
    }
}
