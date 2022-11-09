<#
.SYNOPSIS
R Project scripts.

.DESCRIPTION
R Project scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# R aliases
if (Get-Command R.exe -ErrorAction SilentlyContinue | Test-Path)
{
    Set-Alias -Name R -Value R.exe -Force -Option AllScope
    ${function:rver} = { echo 'paste0(version[c("major","minor")], collapse = ".")' | R.exe --no-save --no-echo }
}

function Get-RProjectPaths
{

    $rPaths = @(
        'C:\Program Files\R\'
        'C:\Program Files\Microsoft\R Open\'
    )

    $rProjects = @()
    foreach ($rPath in $rPaths)
    {
        if (Test-Path $rPath)
        {

            $((Get-ChildItem $rPath).FullName | ForEach-Object { $rProjects += $(Join-Path $_ "\bin\x64") })
            $((Get-ChildItem $rPath).FullName | ForEach-Object { $rProjects += $(Join-Path $_ "\bin\i386")})
        }
    }

    $rProjectValidated = @()
    foreach ($rProject in $rProjects)
    {
        if (Test-Path $rProject)
        {
            $rProjectValidated  += $rProject
        }
    }

    return $rProjectValidated
}

function Find-RProjects
{
    $rPathList = Get-RProjectPaths

    Write-Host "List of R interpretators on this PC:"
    foreach ($r in $rPathList)
    {
        $rBin = (Join-Path $r "R.exe")

        if (Test-Path $rBin)
        {
            Write-Host "- [$($(& $rBin --version 2>&1)[0] -replace '\D+(\d.\d.\d+)\D.*','$1')] -> $r"
        }
    }
}

function Set-RProject
{
    $rPathList = Get-RProjectPaths
    $ValidatedVersions = @()
    $Versions = @()

    foreach ($r in $rPathList)
    {
        $rBin = (Join-Path $r "R.exe")

        if (Test-Path $rBin)
        {
            $ValidatedVersions += $r
            $Versions += "$($(& $rBin --version 2>&1)[0] -replace '\D+(\d.\d.\d+)\D.*','$1')"
        }
    }

    $ChoosenVersion = Select-From-List $ValidatedVersions "R Prokect Version" $Versions
    [Environment]::SetEnvironmentVariable("RPROJECT_PATH", $ChoosenVersion, "Machine")
    Set-Item -Path Env:RPROJECT_PATH -Value "$ChoosenVersion"
    # Set-Env
}

function Clear-RProject
{
    [Environment]::SetEnvironmentVariable("RPROJECT_PATH", $null, "Machine")
    if ($env:RPROJECT_PATH)
    {
        Remove-Item Env:RPROJECT_PATH
    }
    # Set-Env
}

function r_install_package
{
    # installed.packages(), remove.packages()
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $True,ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [String[]]$Packages
    )
    $cmd  = "Rscript --no-site-file --slave --no-save --no-restore-history "
    $cmd += "-e `"install.packages(pkgs="
    $cmd += "c("
    foreach ($package in $Packages)
    {
        if ($package -ne $Packages[-1])
        {
            $cmd += "'$package',"
        }
        else
        {
            $cmd += "'$package'"
        }
    }
    $cmd += ")"
    $cmd += ", repos='http://cran.rstudio.com')"
    $cmd += "`""
    # Write-Host $cmd -ForegroundColor Yellow
    Invoke-Expression "$cmd"
}
