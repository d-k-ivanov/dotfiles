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

function jkinit
{
    bundle install
    bundle exec jekyll build
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
    if (Test-Path -Path "_site")
    {
        Remove-Item -Recurse -Force -Path "_site"
    }
    bundle exec jekyll server --incremental --host 0.0.0.0
}
