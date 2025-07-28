<#
.SYNOPSIS
Jupyter scripts.

.DESCRIPTION
Jupyter scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

${function:jpn} = { jupyter notebook @args }

function jpinstall
{
    [CmdletBinding()]
    param
    (
        [switch]$ReInstall
    )

    if (-Not (Get-Command python -ErrorAction SilentlyContinue | Test-Path))
    {
        Write-Host "ERROR: Python doesn't found in system Path. Exiting..." -ForegroundColor Red
        break
    }

    $jenvDir = Join-Path $env:USERPROFILE .jpenv
    if ($ReInstall -And (Test-Path $jenvDir))
    {
        Remove-Item -Recurse -Force $jenvDir
    }

    if (-Not (Test-Path $jenvDir))
    {
        $python = Get-Command python | Select-Object -ExpandProperty Definition
        python -m pip install --upgrade pip
        python -m venv $jenvDir
    }

    # Set-Location $jenvDir
    & $jenvDir\Scripts\activate.ps1
    python -m pip install --upgrade pip
    python -m pip install --upgrade autopep8
    python -m pip install --upgrade ipython
    python -m pip install --upgrade jupyter
    python -m pip install --upgrade matplotlib
    python -m pip install --upgrade nltk
    python -m pip install --upgrade numpy
    python -m pip install --upgrade numpy-stl
    python -m pip install --upgrade pandas
    python -m pip install --upgrade PyQt5
    python -m pip install --upgrade scipy
    python -m pip install --upgrade seaborn
    python -m pip install --upgrade sklearn
    # python -m pip install --upgrade powershell_kernel
    # python -m powershell_kernel.install

    # For inlined interactice plots:
    # python -m pip install --upgrade ipympl
    # jupyter nbextension install --py --symlink --sys-prefix --overwrite ipympl
    # jupyter nbextension enable --py --sys-prefix ipympl

    deactivate
}

function jpactivate
{
    [CmdletBinding()]
    param
    (
        [switch]$ReInstall
    )

    if (-Not (Get-Command python -ErrorAction SilentlyContinue | Test-Path))
    {
        Write-Host "ERROR: Python doesn't found in system Path. Exiting..." -ForegroundColor Red
        break
    }

    $jenvDir = Join-Path $env:USERPROFILE .jpenv
    if ($ReInstall -And (Test-Path $jenvDir))
    {
        Remove-Item -Recurse -Force $jenvDir
    }

    if (-Not (Test-Path $jenvDir))
    {
        jpinstall
    }

    # Set-Location $jenvDir
    & $jenvDir\Scripts\activate.ps1
}
Set-Alias jj jpactivate

function jpweb
{
    [CmdletBinding()]
    param
    (
        [string]$NoteBookPath = $null,
        [string]$Command = "notebook",
        [Int]$Port = 8888,
        [switch]$ReInstall,
        [switch]$KeepEnv
    )

    if (-Not (Get-Command python -ErrorAction SilentlyContinue | Test-Path))
    {
        Write-Host "ERROR: Python doesn't found in system Path. Exiting..." -ForegroundColor Red
        break
    }

    $jenvDir = Join-Path $env:USERPROFILE .jpenv
    if ($ReInstall -And (Test-Path $jenvDir))
    {
        Remove-Item -Recurse -Force $jenvDir
    }

    if (-Not (Test-Path $jenvDir))
    {
        jpinstall
    }

    & $jenvDir\Scripts\activate.ps1

    if ($NoteBookPath)
    {
        jupyter $Command --port $Port $NoteBookPath
    }
    else
    {
        jupyter $Command --port $Port
    }

    if (-Not $KeepEnv)
    {
        deactivate
    }
}

function jpremove
{
    $jenvDir = Join-Path $env:USERPROFILE .jpenv
    if (Test-Path $jenvDir)
    {
        $title    = "Removing Jupiter Environment: $jenvDir"
        $question = 'Are you sure you want to remove it?'
        $choices  = '&Yes', '&No'

        $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
        if ($decision -eq 0)
        {
            Remove-Item -Recurse -Force $jenvDir
        }
        else
        {
            Write-Host 'cancelled'
        }
    }
    else
    {
        Write-Host "ERROR: Jupiter Environment: $jenvDir doesn't exist. Exiting..." -ForegroundColor Yellow
    }
}
