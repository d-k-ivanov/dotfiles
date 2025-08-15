<#
.SYNOPSIS
Application scripts.

.DESCRIPTION
Application scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Get-InstalledApps
{
    # Alternative
    # wmic
    # wmic:root\cli>/output:D:\Temp\installed2.txt product get name,version

    $location = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
    Get-ItemProperty $location | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize
}

if (Test-Path "C:\Program Files\Microsoft VS Code\bin")
{
    ${function:e} = { code.cmd @args }
    ${function:vscode} = { code.cmd @args }
}
elseif (Test-Path "C:\Program Files\Microsoft VS Code Insiders\bin")
{
    ${function:e} = { code-insiders.cmd @args }
}
elseif (Test-Path "${env:USERPROFILE}\AppData\Local\Programs\Microsoft VS Code Insiders\bin")
{
    ${function:e} = { code-insiders.cmd @args }
}

${function:ee} = { e . }
${function:ww} = { e ${env:WORKSPACE}\my\workspace }

${function:vssp} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-MSVC-22C.json ${PWD}\CMakePresets.json; e . }
