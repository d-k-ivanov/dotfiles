<#
.SYNOPSIS
TensorFlow scripts.

.DESCRIPTION
TensorFlow scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function TF_Env_Vars
{
    if (Test-Path ".\venv\Scripts\activate")
    {
        .\venv\Scripts\activate
    }
    else
    {
        Write-Host "ERROR: venv not found. Please execute TF_Build_Env. Exiting..." -ForegroundColor Red
        return
    }

    Set-Item -Path Env:BAZEL_SH           -Value "c:\tools\msys64\usr\bin\bash.exe"
    Set-Item -Path Env:BAZEL_VERSION      -Value "0.26.1"
    Set-Item -Path Env:BUILD_PATH         -Value "tensorflow/tools/ci_build/builds"
    Set-Item -Path Env:GEN_BUILD          -Value "tensorflow/tools/ci_build/builds/BUILD"
    Set-Item -Path Env:GEN_SCRIPT         -Value "tensorflow/tools/ci_build/builds/gen_win_out.sh"
    Set-Item -Path Env:PIP_EXE            -Value "$((Get-Command venv\Scripts\pip.exe ).Source)"
    Set-Item -Path Env:PY_EXE             -Value "$((Get-Command python ).Source)"
    Set-Item -Path Env:PYTHON_BASE_PATH   -Value "$(Get-Command python | Split-Path)"
    Set-Item -Path Env:PYTHON_BIN_PATH    -Value "${Env:PYTHON_BASE_PATH}/python"
    Set-Item -Path Env:PYTHON_LIB_PATH    -Value "${Env:PYTHON_BASE_PATH}/lib/site-packages"
    Set-Item -Path Env:TEMP               -Value "c:\Temp"
    Set-Item -Path Env:TMP                -Value "c:\Temp"
    Set-Item -Path Env:TMPDIR             -Value "c:\Temp"
    Set-Item -Path Env:WIN_OUT            -Value "win.out"
    Set-Item -Path Env:WIN_OUT_TARGET     -Value "gen_win_out"

    Set-Item -Path Env:PATH -Value "${Env:PYTHON_BASE_PATH}\Scripts;${Env:PATH}"
    Set-Item -Path Env:PATH -Value "C:\tools\msys64\usr\bin;${Env:PATH}"
    Set-Item -Path Env:PATH -Value "C:\tools\bazel;${Env:PATH}"
    Set-Item -Path Env:PATH -Value "C:\tools\swig;${Env:PATH}"
    Set-Item -Path Env:PATH -Value "C:\Program Files\Git\cmd;${Env:PATH}"

    # # CMD
    # set BAZEL_SH="c:\tools\msys64\usr\bin\bash.exe"
    # set BAZEL_VERSION="0.26.1"
    # set BUILD_PATH="tensorflow/tools/ci_build/builds"
    # set GEN_BUILD="tensorflow/tools/ci_build/builds/BUILD"
    # set GEN_SCRIPT="tensorflow/tools/ci_build/builds/gen_win_out.sh"
    # set PIP_EXE="C:\a\tensorflow\venv\Scripts\pip.exe"
    # set PY_EXE="C:\a\tensorflow\venv\Scripts\python"
    # set PYTHON_BASE_PATH="C:\a\tensorflow\venv"
    # set PYTHON_BIN_PATH="C:\a\tensorflow\venv\Scripts\python"
    # set PYTHON_LIB_PATH="C:\a\tensorflow\venv\lib\site-packages"
    # set TEMP="c:\Temp"
    # set TMP="c:\Temp"
    # set TMPDIR="c:\Temp"
    # set WIN_OUT="win.out"
    # set WIN_OUT_TARGET="gen_win_out"
    # set PATH="C:\tools\msys64\usr\bin;C:\tools\bazel;C:\tools\swig;C:\Program Files\Git\cmd;%PATH%"

    if ($env:VIRTUAL_ENV)
    {
        deactivate
    }
}

function TF_Build_Env
{
    $python_bin = $((Get-Command python -ErrorAction SilentlyContinue).Source)
    if ($python_bin)
    {
        $cmd = $(Write-Output "$python_bin -m venv venv")
        Invoke-Expression $cmd
    }
    else
    {
        Write-Host "ERROR: Python not found. Exiting..." -ForegroundColor Red
        return
    }

    TF_Env_Vars

    if (Test-Path ".\venv\Scripts\activate")
    {
        .\venv\Scripts\activate
    }
    else
    {
        Write-Host "ERROR: venv not found. Exiting..." -ForegroundColor Red
        return
    }

    if ($env:VIRTUAL_ENV)
    {
        # wget.exe -q https://github.com/bazelbuild/bazel/releases/download/${Env:BAZEL_VERSION}/bazel-${Env:BAZEL_VERSION}-windows-x86_64.exe -O C:/tools/bazel/bazel.exe
        # bazel version``

        pacman -S --noconfirm patch

        python -m pip install setuptools --upgrade
        python -m pip install future --no-deps
        python -m pip install tf-estimator-nightly --no-deps
        python -m pip install numpy --upgrade --no-deps
        python -m pip install opt_einsum --upgrade
        python -m pip install pandas --upgrade --no-deps
        python -m pip install protobuf --upgrade --no-deps
        python -m pip install keras_applications==1.0.8 --upgrade --no-deps
        python -m pip install keras_preprocessing==1.1.0 --upgrade --no-deps
        python -m pip install wrapt --upgrade --no-deps
        python -m pip install six wheel flake8
    }
    else
    {
        Write-Host "ERROR: Not in virtual environment. Exiting..." -ForegroundColor Red
        return
    }
}

function TF_Build
{
    [CmdletBinding()]
    param
    (
        [ValidateNotNullOrEmpty()]
        [string]$Arch   = "x64"
    )

    if ($env:VIRTUAL_ENV)
    {
        deactivate
    }

    TF_Env_Vars
    Set-VC-Vars-All $Arch 8.1

    if (Test-Path ".\venv\Scripts\activate")
    {
        .\venv\Scripts\activate
    }
    else
    {
        Write-Host "ERROR: venv not found. Exiting..." -ForegroundColor Red
        return
    }

    if ($env:VIRTUAL_ENV)
    {
        if (Test-Path ".\configure.py")
        {
            python .\configure.py
        }
        else
        {
            Write-Host "ERROR: configure.py not found. Please go to tensorflow source dir. Exiting..." -ForegroundColor Red
            return
        }

        # --cpu x86_32_windows or x64_windows
        # bazel --output_user_root={$Env:TMPDIR} test --config opt //tensorflow/tools/lib_package:libtensorflow_test
        # bazel --output_user_root={$Env:TMPDIR} build --config opt //tensorflow/tools/lib_package:libtensorflow
        # bazel --output_user_root={$Env:TMPDIR} build -c opt --copt=/arch:AVX --announce_rc tensorflow:tensorflow.dll tensorflow:tensorflow_dll_import_lib tensorflow/tools/lib_package:clicenses_generate tensorflow/java:tensorflow_jni.dll tensorflow/tools/lib_package:jnilicenses_generate
        # bazel --output_user_root={$Env:TMPDIR} build --cpu x86_32_windows -c opt --copt=/arch:AVX --announce_rc tensorflow:tensorflow.dll tensorflow:tensorflow_dll_import_lib tensorflow/tools/lib_package:clicenses_generate tensorflow/java:tensorflow_jni.dll tensorflow/tools/lib_package:jnilicenses_generate
        bazel --output_user_root={$Env:TMPDIR} build            `
            -c opt --copt=/arch:AVX --announce_rc               `
            tensorflow:tensorflow.dll                           `
            tensorflow:tensorflow_dll_import_lib                `
            tensorflow/tools/lib_package:clicenses_generate     `
            tensorflow/java:tensorflow_jni.dll                  `
            tensorflow/tools/lib_package:jnilicenses_generate
    }
    else
    {
        Write-Host "ERROR: Not in virtual environment. Exiting..." -ForegroundColor Red
        return
    }
}
