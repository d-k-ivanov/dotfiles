<#
.SYNOPSIS
Ruby scripts.

.DESCRIPTION
Ruby scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Get-Rubies
{
    $RubyLocations = @(
        'C:\tools\'
    )
    $Rubies = @()
    foreach ($location in $RubyLocations)
    {
        $Rubies += (Get-ChildItem ${location} -Directory -Filter "*ruby*").FullName
    }

    $RubiesValidated = @()
    foreach ($ruby in $Rubies)
    {
        if (Test-Path "${ruby}\bin")
        {
            if ($ruby -match "jruby")
            {
                $RubiesValidated += (Join-Path $ruby "bin\jruby.exe")
            }
            else
            {
                $RubiesValidated += (Join-Path $ruby "bin\ruby.exe")
            }
        }
    }
    return $RubiesValidated
}

function List-Rubies
{
    $Rubies = Get-Rubies

    Write-Host "List of Ruby interpretators on this PC:"
    foreach ($ruby in $Rubies)
    {
        if (Test-Path $ruby)
        {
            Write-Host "- [$($( & $ruby --version 2>&1) -replace '\D+(\d.\d.\d+)\D.*','$1')] -> $ruby"
        }
    }
}

function Set-Ruby
{
    $Rubies = Get-Rubies
    $ValidatedRubies = @()
    $Versions = @()
    foreach ($ruby in $Rubies)
    {
        if (Test-Path $ruby)
        {
            $ValidatedRubies += $ruby
            $Versions += "$($( & $ruby --version 2>&1) -replace '\D+(\d.\d.\d+)\D.*','$1')"
        }
    }
    $ChoosenVersion = Split-Path -parent $(Select-From-List $ValidatedRubies "Ruby Version" $Versions)
    [Environment]::SetEnvironmentVariable("RUBY_PATH", $ChoosenVersion, "Machine")
    Set-Item -Path Env:RUBY_PATH -Value "$ChoosenVersion"
    # Set-Env
}

function Clear-Ruby
{
    [Environment]::SetEnvironmentVariable("RUBY_PATH", $null, "Machine")
    if ($env:RUBY_PATH)
    {
        Remove-Item Env:RUBY_PATH
    }
    # Set-Env
}
