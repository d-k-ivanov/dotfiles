<#
.SYNOPSIS
AI Python Scripts.

.DESCRIPTION
AI Python Scripts.
#>

# Check invocation
if ( $MyInvocation.InvocationName -ne '.' )
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

$ai_venv_path = 'c:\tools\ai_venv'

function aivenv_activate
{
    if (Test-Path "${ai_venv_path}/Scripts/activate.ps1")
    {
        Write-Host "Activating AI virtual environment at ${ai_venv_path}..." -ForegroundColor Yellow
        & $( Join-Path "${ai_venv_path}" 'Scripts\activate.ps1' )
    }
    else
    {
        Write-Host "AI virtual environment not found at ${ai_venv_path}. Initializing..." -ForegroundColor Red
        aivenv_init
    }
}
Set-Alias ai aivenv_activate

function aivenv_deactivate
{
    if (${Env:VIRTUAL_ENV})
    {
        deactivate
    }
}
Set-Alias aid aivenv_deactivate

function aivenv_rm
{
    aivenv_deactivate
    if ( Test-Path "${ai_venv_path}" )
    {
        Remove-Item -Recurse -Force "${ai_venv_path}"
    }
}
Set-Alias air aivenv_rm

function aivenv_init
{
    if (Test-Path "${ai_venv_path}/Scripts/activate.ps1")
    {
        aivenv_activate
        return
    }

    python -m venv "${ai_venv_path}"
    & $( Join-Path "${ai_venv_path}" 'Scripts\activate.ps1' )

    python -m pip install --upgrade pip

    python -m pip install --upgrade anthropic
    python -m pip install --upgrade black
    python -m pip install --upgrade google-genai
    python -m pip install --upgrade httpx==0.27.2
    python -m pip install --upgrade ollama
    python -m pip install --upgrade openai
    python -m pip install --upgrade pyperclip
}
Set-Alias aii aivenv_init

function aivenv_update
{
    if ( Test-Path "${ai_venv_path}" )
    {
        aivenv_activate
        [string] $SessionID = [System.Guid]::NewGuid()
        $TempFreezeFile = Join-Path "${Env:Temp}" "${SessionID}"
        python -m pip freeze --all | ForEach-Object { $_.split('==')[0] } >> "${TempFreezeFile}"
        python -m pip install --upgrade -r "${TempFreezeFile}"
        Remove-Item -Force "${TempFreezeFile}"
    }
    else
    {
        aivenv_init
    }
}
Set-Alias aiu aivenv_update
