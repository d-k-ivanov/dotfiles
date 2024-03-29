<#
.SYNOPSIS
JetBrains scripts.

.DESCRIPTION
JetBrains scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Get-JBList
{
    $IdeaPaths = @(
        "${Env:LOCALAPPDATA}\JetBrains\Toolbox\apps\AndroidStudio"
        "${Env:LOCALAPPDATA}\JetBrains\Toolbox\apps\IDEA-U"
        "${Env:LOCALAPPDATA}\JetBrains\Toolbox\apps\IDEA-C"
        "${Env:LOCALAPPDATA}\JetBrains\Toolbox\apps\CLion"
    )
    return $IdeaPaths
}

function Find-JBApps
{
    $apps = Get-JBList

    foreach ($app in $apps)
    {
        if (Test-Path $app)
        {
            Write-Host " -> ${app}"
        }
    }
}

${function:ide}  = { idea ${PWD} @args }
${function:cide} = { clion ${PWD} @args }

function fix_jb_address_already_in_use
{
    net stop winnat
    Sleep -Seconds 2
    net start winnat
}
