<#
.SYNOPSIS
TeX, LaTeX, TeXLive, MkLatex, etc. scripts.

.DESCRIPTION
TeX, LaTeX, TeXLive, MkLatex, etc. scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

${function:fix-texlive-formats-sys} = { fmtutil-sys --all; updmap }
${function:fix-texlive-formats-usr} = { fmtutil-user --all; updmap }
