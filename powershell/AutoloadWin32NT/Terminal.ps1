
<#
.SYNOPSIS
Terminal scripts.

.DESCRIPTION
Terminal scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

${function:wt_ps} = { wt -p pwsh `; split-pane -p pwsh }
${function:wt_ws} = { wt -p pwsh `; split-pane -p pwsh `; new-tab wsl }
