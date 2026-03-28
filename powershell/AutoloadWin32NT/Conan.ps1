<#
.SYNOPSIS
Conan.io scripts.

.DESCRIPTION
Conan.io scripts.
#>

# Check invocation
if ( $MyInvocation.InvocationName -ne '.' )
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    exit
}

function conan_set_default_profile
{
    # Possible values for msvc profile:
    # $archs = @("x86", "x86_64")
    # $build_types = @("Release", "RelWithDebInfo", "Debug")
    # $cppstds = @(14, 17, 20, 23, 26)
    # $runtimes = @("static", "dynamic")
    # $versions = @(193, 194, 195)

    $archs = @("x86_64")
    $build_types = @("Release", "RelWithDebInfo", "Debug")
    $cppstds = @(20, 23)
    $runtimes = @("static", "dynamic")
    $versions = @(194, 195)

    $profiles = @()
    foreach ($arch in $archs)
    {
        foreach ($build_type in $build_types)
        {
            foreach ($version in $versions)
            {
                foreach ($cppstd in $cppstds)
                {
                    foreach ($runtime in $runtimes)
                    {
                        $display_arch = if ($arch -eq "x86_64") { "x64" } else { "x86" }
                        $label = "$display_arch-$($build_type.ToLower())-msvc-$version-std$cppstd-$runtime"
                        $profiles += [PSCustomObject]@{
                            Label     = $label
                            Arch      = $arch
                            BuildType = $build_type
                            CppStd    = $cppstd
                            Runtime   = $runtime
                            Version   = $version
                        }
                    }
                }
            }
        }
    }

    $profiles = $profiles | Sort-Object -Property Label -Descending

    # Use GUI selection instead of console selection
    # $selected = $profiles | Out-GridView -Title "Select Default Conan Profile" -OutputMode Single
    $selected = $profiles | Out-ConsoleGridView -Title "Select Default Conan Profile" -OutputMode Single

    if (-not $selected)
    {
        Write-Host "No profile selected." -ForegroundColor Yellow
        return
    }

    $profile_content = @"
[settings]
arch=$($selected.Arch)
build_type=$($selected.BuildType)
compiler=msvc
compiler.cppstd=$($selected.CppStd)
compiler.runtime=$($selected.Runtime)
compiler.version=$($selected.Version)
os=Windows

[options]

[buildenv]

[tool_requires]

[conf]
"@

    $conan_home = get_conan_home
    $default_profile_path = Join-Path $conan_home ".conan2\profiles\default"

    $profile_dir = Split-Path $default_profile_path -Parent
    if (-not (Test-Path $profile_dir))
    {
        New-Item -Path $profile_dir -ItemType Directory -Force | Out-Null
    }

    Set-Content -Path $default_profile_path -Value $profile_content -NoNewline
    Write-Host "Default profile set: $($selected.Label)" -ForegroundColor Green
}


function conan_set_vars
{
    [CmdletBinding()]
    param
    (
        [string]$ConanHome = "None",
        [string]$ConanShort = "None"
    )

    # Set Conan Home Path
    if ($ConanHome -ne "None")
    {
        Set-Item -Path Env:CONAN_USER_HOME -Value "${ConanHome}"
        [Environment]::SetEnvironmentVariable("CONAN_USER_HOME", "${Env:CONAN_USER_HOME}", "Machine")
        if (-not (Test-Path "${Env:CONAN_USER_HOME}"))
        {
            New-Item "${Env:CONAN_USER_HOME}" -ItemType Directory -ErrorAction SilentlyContinue
        }
    }

    # Set Conan Home Short Path
    if ($ConanShort -ne "None")
    {
        Set-Item -Path Env:CONAN_USER_HOME_SHORT -Value "${ConanShort}"
        [Environment]::SetEnvironmentVariable("CONAN_USER_HOME_SHORT", "${Env:CONAN_USER_HOME_SHORT}", "Machine")
        if (-not (Test-Path "${Env:CONAN_USER_HOME_SHORT}"))
        {
            New-Item "${Env:CONAN_USER_HOME_SHORT}" -ItemType Directory -ErrorAction SilentlyContinue
        }
    }
    else
    {
        Set-Item -Path Env:CONAN_USER_HOME_SHORT -Value "None"
        [Environment]::SetEnvironmentVariable("CONAN_USER_HOME_SHORT", "${Env:CONAN_USER_HOME_SHORT}", "Machine")
    }

    if ($Env:CONAN_USER_HOME)
    {
        Set-Item -Path Env:CONAN_TRACE_FILE -Value "${Env:CONAN_USER_HOME}\conan.log"
        [Environment]::SetEnvironmentVariable("CONAN_TRACE_FILE", "${Env:CONAN_USER_HOME}\conan.log", "Machine")
    }
    else
    {
        Set-Item -Path Env:CONAN_TRACE_FILE -Value "${Env:USERPROFILE}\.conan\conan.log"
        [Environment]::SetEnvironmentVariable("CONAN_TRACE_FILE", "${Env:USERPROFILE}\.conan\conan.log", "Machine")
    }
}

function conan_clean_vars
{
    [Environment]::SetEnvironmentVariable("CONAN_USER_HOME", [NullString]::Value, "Machine")
    [Environment]::SetEnvironmentVariable("CONAN_USER_HOME_SHORT", [NullString]::Value, "Machine")
    [Environment]::SetEnvironmentVariable("CONAN_TRACE_FILE", [NullString]::Value, "Machine")
    if ($env:CONAN_USER_HOME)
    {
        Remove-Item Env:CONAN_USER_HOME
    }
    if ($env:CONAN_USER_HOME_SHORT)
    {
        Remove-Item Env:CONAN_USER_HOME
    }
    if ($env:CONAN_TRACE_FILE)
    {
        Remove-Item Env:CONAN_USER_HOME
    }
}

# Variables
$conan_env_path = 'c:\tools\conan_env'

function conan_symlinks
{
    [CmdletBinding()]
    param (
        [string] $ForceVersion = "None"
    )

    if ($ForceVersion -eq "2" -or ($ForceVersion -eq "None" -and (conan --version | Select-String -Pattern "Conan version 2" -Quiet)))
    {
        if ($Env:CONAN_USER_HOME)
        {
            $conan_my_path = Join-Path $Env:USERPROFILE ".conan2_my"
            $conan_config = Join-Path $Env:CONAN_USER_HOME ".conan2\conan.conf"
            $conan_hooks = Join-Path $Env:CONAN_USER_HOME ".conan2\hooks"
            $conan_profiles = Join-Path $Env:CONAN_USER_HOME ".conan2\profiles"
        }
        else
        {
            $conan_my_path = Join-Path $Env:USERPROFILE ".conan2_my"
            $conan_config = Join-Path $Env:USERPROFILE ".conan2\conan.conf"
            $conan_hooks = Join-Path $Env:USERPROFILE ".conan2\hooks"
            $conan_profiles = Join-Path $Env:USERPROFILE ".conan2\profiles"
        }
    }
    elseif ($ForceVersion -eq "1" -or ($ForceVersion -eq "None" -and (conan --version | Select-String -Pattern "Conan version 1" -Quiet)))
    {
        if ($Env:CONAN_USER_HOME)
        {
            $conan_my_path = Join-Path $Env:USERPROFILE ".conan_my"
            $conan_config = Join-Path $Env:CONAN_USER_HOME ".conan\conan.conf"
            $conan_hooks = Join-Path $Env:CONAN_USER_HOME ".conan\hooks"
            $conan_profiles = Join-Path $Env:CONAN_USER_HOME ".conan\profiles"
        }
        else
        {
            $conan_my_path = Join-Path $Env:USERPROFILE ".conan_my"
            $conan_config = Join-Path $Env:USERPROFILE ".conan\conan.conf"
            $conan_hooks = Join-Path $Env:USERPROFILE ".conan\hooks"
            $conan_profiles = Join-Path $Env:USERPROFILE ".conan\profiles"
        }
    }
    else
    {
        Write-Host "Error: Unsupported Conan version. Please specify version 1 or 2." -ForegroundColor Red
        return
    }

    if (-not (Test-Path $conan_hooks))
    {
        New-Item "${conan_hooks}" -ItemType Directory -ErrorAction SilentlyContinue
    }

    if (-not (Test-Path $conan_profiles))
    {
        New-Item "${conan_profiles}" -ItemType Directory -ErrorAction SilentlyContinue
    }

    if (Test-Path $conan_my_path)
    {
        Remove-Item -Force -Confirm:$false "${conan_config}" -ErrorAction SilentlyContinue
        cmd.exe /c mklink "${conan_config}" "${conan_my_path}\conan.conf"

        Get-ChildItem "${conan_my_path}\hooks" | ForEach-Object {
            Remove-Item -Force -Confirm:$false "${conan_hooks}\$($_.Name)" -ErrorAction SilentlyContinue
            cmd.exe /c mklink "${conan_hooks}\$($_.Name)" "$($_.FullName)"
        }

        Get-ChildItem "${conan_my_path}\profiles" | ForEach-Object {
            Remove-Item -Force -Confirm:$false "${conan_profiles}\$($_.Name)" -ErrorAction SilentlyContinue
            cmd.exe /c mklink "${conan_profiles}\$($_.Name)" "$($_.FullName)"
        }
    }
}

function conan_env_init
{
    [CmdletBinding()]
    param (
        [ValidateSet("1", "2")]
        [string] $Version = "None"
    )

    $python = Get-Command python | Select-Object -ExpandProperty Definition
    python -m pip install --upgrade pip
    python -m venv "${conan_env_path}"
    & $(Join-Path "${conan_env_path}" 'Scripts\activate.ps1')
    python -m pip install --upgrade pip

    if ($Version -eq "None")
    {
        # Check if conan pacage is already (python -m pip list) do nothing, else install specific version
        if (python -m pip list | Select-String -Pattern "conan" -Quiet)
        {
            Write-Host "Conan is already installed. Skipping installation." -ForegroundColor Yellow
        }
        else
        {
            python -m pip install --upgrade conan
        }
    }
    else
    {
        python -m pip install --upgrade --force-reinstall "conan==${Version}.*"
    }
}

function conan_env_cd
{
    if ( Test-Path "${conan_env_path}" )
    {
        cd "${conan_env_path}"
    }
}

function conan_env_activate
{
    if ( Test-Path "${conan_env_path}" )
    {
        & $( Join-Path "${conan_env_path}" 'Scripts\activate.ps1' )
    }
    else
    {
        cenv_init
    }
}

function conan_env_deactivate
{
    if (${Env:VIRTUAL_ENV})
    {
        deactivate
    }
}

function conan_env_update
{
    if ( Test-Path "${conan_env_path}" )
    {
        cenv_activate
        [string] $SessionID = [System.Guid]::NewGuid()
        $TempFreezeFile = Join-Path "${Env:Temp}" "${SessionID}"
        python -m pip freeze --all | ForEach-Object { $_.split('==')[0] } >> "${TempFreezeFile}"
        python -m pip install --upgrade -r "${TempFreezeFile}"
        Remove-Item -Force "${TempFreezeFile}"
        # python -m pip freeze | %{ $_.split('==')[0] } | %{ python -m pip install --upgrade $_ }
    }
    else
    {
        cenv_init
    }
}

function conan_env_remove
{
    conan_env_deactivate
    if ( Test-Path "${conan_env_path}" )
    {
        Remove-Item -Recurse -Force "${conan_env_path}"
    }
}

function conan_add_remote
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Organization,
        [string]$Remote = 'conan-local',
        [string]$Repo = 'conan-local'
    )
    conan remote add ${Remote} https://${Organization}.jfrog.io/artifactory/api/conan/${Repo}
}

function conan_set_env_password
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [SecureString]$Password
    )
    Set-Item -Path Env:CONAN_PASSWORD -Value "${Password}"
}

function conan_remote_auth
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Username,
        [Parameter(Mandatory = $true)]
        [SecureString]$Password,
        [string]$Remote = 'conan-local'
    )
    conan user -p ${Password} -r ${Remote} ${Username}
}

function get_conan_home
{
    if (${Env:CONAN_USER_HOME})
    {
        return ${Env:CONAN_USER_HOME}
    }
    else
    {
        return ${Env:USERPROFILE}
    }
}

function conan1_install
{
    [CmdletBinding()]
    param
    (
        [string] $PathToConanFile = '.',
        [string] $Configuration = 'release',
        [string] $Arch = 'x64',
        [string] $MSVCVer = '17',
        [switch] $Shared
    )

    cenv_activate
    $conan_home = get_conan_home

    if ($Shared)
    {
        conan install "$PathToConanFile" -pr "${conan_home}\.conan\profiles\windows-msvc-${MSVCVer}-shared-${Configuration}-${Arch}" --build=missing
    }
    else
    {
        conan install "$PathToConanFile" -pr "${conan_home}\.conan\profiles\windows-msvc-${MSVCVer}-static-${Configuration}-${Arch}" --build=missing
    }
}

function conan2_install
{
    [CmdletBinding()]
    param
    (
        [string] $PathToConanFile = '.',
        [string] $Configuration = 'release',
        [string] $Arch = 'x64',
        [string] $MSVCVer = '14.5',
        [switch] $Shared
    )

    cenv_activate
    $conan_home = get_conan_home

    if ($Shared)
    {
        conan install "$PathToConanFile" -pr "${conan_home}\.conan2\profiles\windows-msvc-${MSVCVer}-shared-${Configuration}-${Arch}.ini" --build=missing
    }
    else
    {
        conan install "$PathToConanFile" -pr "${conan_home}\.conan2\profiles\windows-msvc-${MSVCVer}-static-${Configuration}-${Arch}.ini" --build=missing
    }
}
