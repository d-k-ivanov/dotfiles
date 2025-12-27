<#
.SYNOPSIS
Logging scripts.

.DESCRIPTION
Logging scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    exit
}

### Info
function WriteInfo($message)
{
    Write-Host $message
}

function LogInfo($message)
{
    WriteInfo "$(Get-Date -UFormat '%Y-%M-%d-%H-%m-%S') $message"
}

### Highlighted
function WriteInfoHighlighted($message)
{
    Write-Host "$message" -ForegroundColor Cyan
}

function LogInfoHighlighted($message)
{
    WriteInfoHighlighted "$(Get-Date -UFormat '%Y-%M-%d-%H-%m-%S') $message"
}

### Success
function WriteSuccess($message)
{
    Write-Host "$message" -ForegroundColor Green
}

function LogSuccess($message)
{
    WriteSuccess "$(Get-Date -UFormat '%Y-%M-%d-%H-%m-%S') $message"
}

### Error
function WriteError($message)
{
    Write-Host "$message" -ForegroundColor Red
}

function LogError($message)
{
    WriteError "$(Get-Date -UFormat '%Y-%M-%d-%H-%m-%S') $message"
}

### Critical
function WriteCritical($message)
{
    Write-Host "$message. Exiting..." -ForegroundColor Red
    exit
}

function LogCritical($message)
{
    WriteCritical "$(Get-Date -UFormat '%Y-%M-%d-%H-%m-%S') $message"
}
