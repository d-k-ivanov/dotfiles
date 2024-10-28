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
    ${function:vc}      = { ($python = Get-Command python | Select-Object -ExpandProperty Definition); python -m venv venv }
    ${function:va}      = { .\venv\Scripts\activate }
    ${function:vd}      = { deactivate }
    ${function:vr}      = { rmrf venv }
    ${function:vpi}     = { python -m pip install  }
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
