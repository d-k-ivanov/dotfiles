<#
.SYNOPSIS
Processes scripts.

.DESCRIPTION
Processes scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

${function:killall} = { Get-Process @args | Stop-Process }

function psef()
{
    Get-Process @args -IncludeUserName | Format-Table `
    ProcessName,
    Id,
    UserName,
    @{Label = "CPU(s)"; Expression = {if ($_.CPU) {$_.CPU.ToString("N")}}},
    @{Label = "VM(M)";  Expression = {[int]($_.VM  / 1MB)}},
    @{Label = "WS(K)";  Expression = {[int]($_.WS  / 1024)}},
    @{Label = "PM(K)";  Expression = {[int]($_.PM  / 1024)}},
    @{Label = "NPM(K)"; Expression = {[int]($_.NPM / 1024)}},
    Path -AutoSize
}
