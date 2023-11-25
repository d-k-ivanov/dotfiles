<#
.SYNOPSIS
Jekyll scripts.

.DESCRIPTION
Jekyll scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


function jkpost
{
    [CmdletBinding()]
    param (
        [switch] $Force
    )
    bundle exec jekyll build
    git add --all
    git commit -am "Post $(Get-Date -Format "yyyy-dd-MM-HH-mm")"
    if ($Force)
    {
        git push --force
    }
    else
    {
        git push
    }
}

function jkserv
{
    bundle install
    bundle exec jekyll build
    bundle exec jekyll server --incremental --host 0.0.0.0
}
