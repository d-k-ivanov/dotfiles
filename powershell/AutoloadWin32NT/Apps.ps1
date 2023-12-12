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
    ${function:icode}  = {code.cmd @args}
    ${function:vscode} = {code.cmd @args}
}
elseif (Test-Path "C:\Program Files\Microsoft VS Code Insiders\bin")
{
    ${function:icode} = {code-insiders.cmd @args}
}
elseif (Test-Path "${env:USERPROFILE}\AppData\Local\Programs\Microsoft VS Code Insiders\bin")
{
    ${function:icode} = {code-insiders.cmd @args}
}

${function:ic} = { icode . }
${function:ww} = { icode ${env:MY_DROPBOX}\Workspace }
