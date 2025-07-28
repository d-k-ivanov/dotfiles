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
    exit
}

${function:vc} = { python -m venv venv }
${function:vc3} = { python -m venv venv }
${function:va} = { .\venv\Scripts\activate }
${function:vd} = { deactivate }
${function:vr} = { rmrf venv }
${function:vpi} = { python -m pip install }
${function:vpip} = { python -m pip install --upgrade pip }
${function:vgen} = { python -m pip freeze > .\requirements.txt }
${function:vinsr} = { if (Test-Path requirements.txt) { python -m pip install -r .\requirements.txt } }
${function:vinsd} = { if (Test-Path requirements-dev.txt) { python -m pip install -r .\requirements-dev.txt } }
${function:vinsm} = { if (Test-Path requirements-misc.txt) { python -m pip install -r .\requirements-misc.txt } }
${function:vins} = { if (Test-Path $args[0] -ErrorAction SilentlyContinue) { vpip; python -m pip install -r $args[0] } else { vpip; vinsr; vinsd; vinsm } }

# Basic environment
${function:pip-update} = { python -m pip install --upgrade pip }
${function:ipython-install} = { python -m pip install ipython }

function py_init_environmnet
{
    python -m pip install --upgrade pip
}

function pyclean
{
    [CmdletBinding()]
    param
    (
        [switch] $InstallBaseModules
    )
    [string] $SessionID = [System.Guid]::NewGuid()
    $TempFreezeFile = (Join-Path "${Env:Temp}" "${SessionID}")
    python -m pip freeze > "${TempFreezeFile}"
    python -m pip uninstall -y -r "${TempFreezeFile}"
    Remove-Item -Force "${TempFreezeFile}"
    # python -m pip freeze | %{ $_.split('==')[0] } | %{ python -m pip install --upgrade $_ }
    python -m pip install --upgrade pip
    if ($InstallBaseModules)
    {
        py_init_environmnet
    }
}

${function:srv} = { python -m http.server @args }
if (Get-Command serv.ps1 -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:serv} = { serv.ps1 @args }
}

function get-serpents
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
        "$Env:LOCALAPPDATA\Programs\Python\Python313"
        "$Env:LOCALAPPDATA\Programs\Python\Python312"
        "$Env:LOCALAPPDATA\Programs\Python\Python311"
        "$Env:LOCALAPPDATA\Programs\Python\Python310"
        "$Env:LOCALAPPDATA\Programs\Python\Python39"
        "$Env:LOCALAPPDATA\Programs\Python\Python38"
        "$Env:LOCALAPPDATA\Programs\Python\Python37"
        "$Env:LOCALAPPDATA\Programs\Python\Python36"
        "$Env:LOCALAPPDATA\Programs\Python\Python35"
        "$Env:LOCALAPPDATA\Programs\Python\Python27"
        "$Env:LOCALAPPDATA\Programs\Python\Python26"
        "$Env:LOCALAPPDATA\Programs\Python\Python25"
        "$Env:LOCALAPPDATA\Programs\Python\Python313-32"
        "$Env:LOCALAPPDATA\Programs\Python\Python312-32"
        "$Env:LOCALAPPDATA\Programs\Python\Python311-32"
        "$Env:LOCALAPPDATA\Programs\Python\Python310-32"
        "$Env:LOCALAPPDATA\Programs\Python\Python39-32"
        "$Env:LOCALAPPDATA\Programs\Python\Python38-32"
        "$Env:LOCALAPPDATA\Programs\Python\Python37-32"
        "$Env:LOCALAPPDATA\Programs\Python\Python36-32"
        "$Env:LOCALAPPDATA\Programs\Python\Python35-32"
        "$Env:LOCALAPPDATA\Programs\Python\Python27-32"
        "$Env:LOCALAPPDATA\Programs\Python\Python26-32"
        "$Env:LOCALAPPDATA\Programs\Python\Python25-32"
        'C:\tools\python3'
        'C:\tools\python3_x86'
        'C:\tools\python2'
        'C:\tools\python2_x86'
        'C:\tools\miniforge3'
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

function list-py
{
    $serpents = get-serpents

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

function set-py
{
    clear-py
    $serpents = get-serpents
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

    $Env:PATH = "${Env:PYTHON_PATH}\Scripts;${Env:PYTHON_PATH};$Env:PATH"

    # Set-Env
}

function enable-py
{
    $serpents = get-serpents
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
    Set-Item -Path Env:PYTHON_PATH -Value "$ChoosenVersion"

    $Env:PATH = "${Env:PYTHON_PATH}\Scripts;${Env:PYTHON_PATH};$Env:PATH"
}

function set-py-double
{
    Set-Item -Path Env:PATH -Value "C:\tools\python2;C:\tools\python3;${Env:PATH}"
}

function clear-py
{
    [Environment]::SetEnvironmentVariable("PYTHON_PATH", [NullString]::Value, "User")
    [Environment]::SetEnvironmentVariable("PYTHON_PATH", [NullString]::Value, "Machine")
    if ($Env:PYTHON_PATH)
    {
        $path = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')
        $path = $path -replace [regex]::Escape("${Env:PYTHON_PATH}\Scripts;"), ''
        $path = $path -replace [regex]::Escape("${Env:PYTHON_PATH};"), ''
        [System.Environment]::SetEnvironmentVariable('PATH', $path, 'Machine')

        $path = [System.Environment]::GetEnvironmentVariable('PATH', 'User')
        $path = $path -replace [regex]::Escape("${Env:PYTHON_PATH}\Scripts;"), ''
        $path = $path -replace [regex]::Escape("${Env:PYTHON_PATH};"), ''
        [System.Environment]::SetEnvironmentVariable('PATH', $path, 'User')

        $Env:PATH = $Env:PATH -replace [regex]::Escape("${Env:PYTHON_PATH}\Scripts;"), ''
        $Env:PATH = $Env:PATH -replace [regex]::Escape("${Env:PYTHON_PATH};"), ''

        Remove-Item Env:PYTHON_PATH
    }

    [Environment]::SetEnvironmentVariable("PYENV", [NullString]::Value, "User")
    [Environment]::SetEnvironmentVariable("PYENV", [NullString]::Value, "Machine")
    [Environment]::SetEnvironmentVariable("PYENV_HOME", [NullString]::Value, "User")
    [Environment]::SetEnvironmentVariable("PYENV_HOME", [NullString]::Value, "Machine")
    [Environment]::SetEnvironmentVariable("PYENV_ROOT", [NullString]::Value, "User")
    [Environment]::SetEnvironmentVariable("PYENV_ROOT", [NullString]::Value, "Machine")

    if ($Env:PYENV)
    {
        $path = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')
        $path = $path -replace [regex]::Escape("${Env:PYENV}\bin;"), ''
        $path = $path -replace [regex]::Escape("${Env:PYENV}\shims;"), ''
        [System.Environment]::SetEnvironmentVariable('PATH', $path, 'Machine')

        $path = [System.Environment]::GetEnvironmentVariable('PATH', 'User')
        $path = $path -replace [regex]::Escape("${Env:PYENV}\bin;"), ''
        $path = $path -replace [regex]::Escape("${Env:PYENV}\shims;"), ''
        [System.Environment]::SetEnvironmentVariable('PATH', $path, 'User')

        $Env:PATH = $Env:PATH -replace [regex]::Escape("${Env:PYENV}\bin;"), ''
        $Env:PATH = $Env:PATH -replace [regex]::Escape("${Env:PYENV}\shims;"), ''

        Remove-Item Env:PYENV
        Remove-Item Env:PYENV_HOME
        Remove-Item Env:PYENV_ROOT
    }
}

function pyenv-set
{
    clear-py
    $PyEnvLocation = "${Env:USERPROFILE}\.pyenv\pyenv-win"

    [Environment]::SetEnvironmentVariable("PYENV", $PyEnvLocation, "User")
    [Environment]::SetEnvironmentVariable("PYENV_HOME", $PyEnvLocation, "User")
    [Environment]::SetEnvironmentVariable("PYENV_ROOT", $PyEnvLocation, "User")

    Set-Item -Path Env:PYENV -Value "$PyEnvLocation"
    Set-Item -Path Env:PYENV_HOME -Value "$PyEnvLocation"
    Set-Item -Path Env:PYENV_ROOT -Value "$PyEnvLocation"

    $Env:PATH = "${Env:PYENV}\bin;${Env:PYENV}\shims;$Env:PATH"
    # Set-Env
}

function pyenv-enable
{
    $PyEnvLocation = "${Env:USERPROFILE}\.pyenv\pyenv-win"

    Set-Item -Path Env:PYENV -Value "$PyEnvLocation"
    Set-Item -Path Env:PYENV_HOME -Value "$PyEnvLocation"
    Set-Item -Path Env:PYENV_ROOT -Value "$PyEnvLocation"

    # PATH
    $Env:PATH = "${Env:PYENV}\bin;${Env:PYENV}\shims;$Env:PATH"
}

function pyenv-disable
{

    if ($Env:PYENV)
    {
        $Env:PATH = $Env:PATH -replace [regex]::Escape("${Env:PYENV}\bin;"), ''
        $Env:PATH = $Env:PATH -replace [regex]::Escape("${Env:PYENV}\shims;"), ''
        Remove-Item Env:PYENV
    }
    if ($Env:PYENV_HOME)
    {
        Remove-Item Env:PYENV_HOME
    }
    if ($Env:PYENV_ROOT)
    {
        Remove-Item Env:PYENV_ROOT
    }
}
