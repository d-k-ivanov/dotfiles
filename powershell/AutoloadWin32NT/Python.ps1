<#
.SYNOPSIS
Python scripts.

.DESCRIPTION
Python scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command python -ErrorAction SilentlyContinue | Test-Path)
{
    # ${function:vc}      = { ($python = Get-Command python | Select-Object -ExpandProperty Definition); python -m venv -p $python venv }
    ${function:vc}      = { ($python = Get-Command python | Select-Object -ExpandProperty Definition); python -m venv venv }
    ${function:va}      = { .\venv\Scripts\activate }
    ${function:vd}      = { deactivate }
    ${function:vr}      = { rmrf venv }
    ${function:vpi}     = { python -m pip install }
    ${function:vpip}    = { python -m pip install --upgrade pip }
    ${function:vgen}    = { python -m pip freeze > .\requirements.txt }
    ${function:vins}    = { vpip; if(Test-Path requirements.txt){ vinsr }; if(Test-Path requirements-dev.txt){ vinsd } }
    ${function:vinsr}   = { python -m pip install -r .\requirements.txt }
    ${function:vinsd}   = { python -m pip install -r .\requirements-dev.txt }

    # Basic environment
    ${function:pip-update}      = { python -m pip install --upgrade pip }
    ${function:ipython-install} = { python -m pip install ipython }

    function py_init_environmnet
    {
        python -m pip install --upgrade pip
        python -m pip install --upgrade flake8
        python -m pip install --upgrade ipython
        python -m pip install --upgrade pytest
        python -m pip install --upgrade cfn-lint
    }

    function pyclean
    {
        [CmdletBinding()]
        param
        (
            [switch] $InstallBaseModules
        )
        [string] $SessionID = [System.Guid]::NewGuid()
        $TempFreezeFile  = (Join-Path "${Env:Temp}" "${SessionID}")
        python -m pip freeze > "${TempFreezeFile}"
        python -m pip uninstall -y -r "${TempFreezeFile}"
        Remove-Item -Force "${TempFreezeFile}"
        # python -m pip freeze | %{ $_.split('==')[0] } | %{ python -m pip install --upgrade $_ }
        python -m pip install --upgrade pip
        if($InstallBaseModules)
        {
            py_init_environmnet
        }
    }

    ${function:srv}  = { python -m http.server @args }
    if (Get-Command serv.ps1 -ErrorAction SilentlyContinue | Test-Path)
    {
        ${function:serv}  = { serv.ps1 @args }
    }
}

function Get-PyList
{
    $serpents = @(
        'C:\Python313'
        'C:\Python312'
        'C:\Python311'
        'C:\Python310'
        'C:\Python39'
        'C:\Python38'
        'C:\Python37'
        'C:\Python36'
        'C:\Python35'
        'C:\Python34'
        'C:\Python27'
        'C:\Python26'
        'C:\Python25'
        'C:\Python38-32'
        'C:\Python37-32'
        'C:\Python36-32'
        'C:\Python35-32'
        'C:\Python34-32'
        'C:\Python27-32'
        'C:\Python26-32'
        'C:\Python25-32'
        "$env:LOCALAPPDATA\Programs\Python\Python313"
        "$env:LOCALAPPDATA\Programs\Python\Python312"
        "$env:LOCALAPPDATA\Programs\Python\Python311"
        "$env:LOCALAPPDATA\Programs\Python\Python310"
        "$env:LOCALAPPDATA\Programs\Python\Python39"
        "$env:LOCALAPPDATA\Programs\Python\Python38"
        "$env:LOCALAPPDATA\Programs\Python\Python37"
        "$env:LOCALAPPDATA\Programs\Python\Python36"
        "$env:LOCALAPPDATA\Programs\Python\Python35"
        "$env:LOCALAPPDATA\Programs\Python\Python27"
        "$env:LOCALAPPDATA\Programs\Python\Python26"
        "$env:LOCALAPPDATA\Programs\Python\Python25"
        "$env:LOCALAPPDATA\Programs\Python\Python313-32"
        "$env:LOCALAPPDATA\Programs\Python\Python312-32"
        "$env:LOCALAPPDATA\Programs\Python\Python311-32"
        "$env:LOCALAPPDATA\Programs\Python\Python310-32"
        "$env:LOCALAPPDATA\Programs\Python\Python39-32"
        "$env:LOCALAPPDATA\Programs\Python\Python38-32"
        "$env:LOCALAPPDATA\Programs\Python\Python37-32"
        "$env:LOCALAPPDATA\Programs\Python\Python36-32"
        "$env:LOCALAPPDATA\Programs\Python\Python35-32"
        "$env:LOCALAPPDATA\Programs\Python\Python27-32"
        "$env:LOCALAPPDATA\Programs\Python\Python26-32"
        "$env:LOCALAPPDATA\Programs\Python\Python25-32"
        'C:\tools\python3'
        'C:\tools\python3_x86'
        'C:\tools\python2'
        'C:\tools\python2_x86'
        'C:\tools\miniconda3'
        'C:\tools\miniconda2'
        'C:\tools\python-embed-x64'
        'C:\tools\python-embed-win32'
        'C:\tools\python-embed-313-x64'
        'C:\tools\python-embed-313-win32'
        'C:\tools\python-embed-312-x64'
        'C:\tools\python-embed-312-win32'
        'C:\tools\python-embed-311-x64'
        'C:\tools\python-embed-311-win32'
        'C:\tools\python-embed-310-x64'
        'C:\tools\python-embed-310-win32'
        'C:\tools\python-embed-39-win32'
        'C:\tools\python-embed-39-x64'
        'C:\tools\python-embed-38-x64'
        'C:\tools\python-embed-38-win32'
    )
    return $serpents
}

function List-Py
{
    $serpents = Get-PyList

    Write-Host "List of Python interpretators on this PC:"
    foreach ($snake in $serpents)
    {
        $snakeBin = (Join-Path $snake "python.exe")
        if (Test-Path $snakeBin)
        {
            Write-Host "- [$($( & $snakeBin --version 2>&1) -replace '\D+(\d+...)','$1')] -> $snake"
        }
    }
}

function Set-Py
{
    $serpents = Get-PyList
    $ValidatedSerpents = @()
    $Versions = @()
    foreach ($snake in $serpents)
    {
        $snakeBin = (Join-Path $snake "python.exe")
        if (Test-Path $snakeBin)
        {
            $ValidatedSerpents += $snake
            $Versions += "$($( & $snakeBin --version 2>&1) -replace '\D+(\d+...)','$1')"
        }
    }
    $ChoosenVersion = Select-From-List $ValidatedSerpents "Python Version" $Versions
    [Environment]::SetEnvironmentVariable("PYTHON_PATH", $ChoosenVersion, "Machine")
    Set-Item -Path Env:PYTHON_PATH -Value "$ChoosenVersion"

    # [Environment]::SetEnvironmentVariable("PYTHONPATH", "${ChoosenVersion}\Lib\;${ChoosenVersion}\DLLs\", "Machine")
    # Set-Item -Path Env:PYTHONPATH -Value "${ChoosenVersion}\Lib\;${ChoosenVersion}\DLLs\"
    # Set-Env
}

function Set-Py-Double
{
    Set-Item -Path Env:PATH -Value "C:\tools\python2;C:\tools\python3;${Env:PATH}"
}

function Clear-Py
{
    [Environment]::SetEnvironmentVariable("PYTHON_PATH", $null, "Machine")
    if ($env:PYTHON_PATH)
    {
        Remove-Item Env:PYTHON_PATH
    }

    [Environment]::SetEnvironmentVariable("PYTHONPATH", $null, "Machine")
    if ($env:PYTHONPATH)
    {
        Remove-Item Env:PYTHONPATH
    }
    # Set-Env
}

function pyenv-enable
{
    Clear-Py
    $PyEnvLocation = "${env:USERPROFILE}\.pyenv\pyenv-win"
    [Environment]::SetEnvironmentVariable("PYENV", $PyEnvLocation, "User")
    Set-Item -Path Env:PYENV -Value "$PyEnvLocation"
    # Set-Env
}

function pyenv-disable
{
    [Environment]::SetEnvironmentVariable("PYENV", $null, "User")
    if ($env:PYENV)
    {
        Remove-Item Env:PYENV
    }
    # Set-Env
}

