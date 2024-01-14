<#
.SYNOPSIS
VCPKG scripts.

.DESCRIPTION
VCPKG scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

$Env:VCPKG_DISABLE_METRICS = 1
# $Env:VCPKG_FEATURE_FLAGS = "versions"

function Get-VCPKGList
{
    $Directories = @(
        "${env:WORKSPACE}\vcpkg"
        "${env:WORKSPACE}\vcpkg-gh"
        "c:\v"
        "d:\v"
    )

    $GroupDirectories = @(
        "c:\vcpkg"
        "d:\vcpkg"
    )

    $Output = @()
    foreach ($Directory in $Directories)
    {
        if (Test-Path $Directory)
        {
            $Result = (Get-ChildItem ${Directory} -File -Recurse -Depth 1 -Include .vcpkg-root).FullName
            foreach ($p in $Result)
            {
                $Output += (Get-Item $p).Directory.FullName
            }
        }
    }

    foreach ($Directory in $GroupDirectories)
    {
        if (Test-Path $Directory)
        {
            $Result = (Get-ChildItem ${Directory} -File -Recurse -Depth 2 -Include .vcpkg-root).FullName
            foreach ($p in $Result)
            {
                $Output += (Get-Item $p).Directory.FullName
            }
        }
    }

    return $Output
}

function Set-VCPKG
{
    $Selected = Select-From-List $(Get-VCPKGList) 'available VCPKG locations'
    [Environment]::SetEnvironmentVariable("MY_VCPKG_ROOT", ${Selected}, "Machine")
    Set-Item -Path Env:MY_VCPKG_ROOT -Value ${Selected}
    Set-Item -Path Env:PATH -Value "${Selected};${Env:PATH}"
}

function Use-VCPKG
{
    $Selected = Select-From-List $(Get-VCPKGList) 'available VCPKG locations'
    Set-Item -Path Env:PATH -Value "${Selected};${Env:PATH}"
}

${function:vcpkg-remove}        = { vcpkg remove            --triplet x64-windows @args }
${function:vcpkg-remove-r}      = { vcpkg remove  --recurse --triplet x64-windows @args }
${function:vcpkg-install}       = { vcpkg install           --triplet x64-windows @args }
${function:vcpkg-install-r}     = { vcpkg install --recurse --triplet x64-windows @args }

${function:vcpkg-remove-x86}    = { vcpkg remove            --triplet x86-windows @args }
${function:vcpkg-remove-x86-r}  = { vcpkg remove  --recurse --triplet x86-windows @args }
${function:vcpkg-install-x86}   = { vcpkg install           --triplet x86-windows @args }
${function:vcpkg-install-x86-r} = { vcpkg install --recurse --triplet x86-windows @args }

function vcpkg-cmake
{
    # $vcpkgPath = (Get-Item (Get-Command vcpkg.exe -ErrorAction SilentlyContinue).Path).Directory.FullName
    # $vcpkNixPath = ($vcpkgPath -replace "\\","/").ToLower().Trim("/")
    $vcpkNixPath = ($env:MY_VCPKG_ROOT -replace "\\", "/").ToLower().Trim("/")
    Write-Output "-DCMAKE_TOOLCHAIN_FILE=${vcpkNixPath}/scripts/buildsystems/vcpkg.cmake"
}
