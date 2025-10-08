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
        "${Env:WORKSPACE}\vcpkg"
        "${Env:WORKSPACE}\vcpkg-cc"
        "${Env:WORKSPACE}\vcpkg-gh"
        "c:\j\v"
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
    [Environment]::SetEnvironmentVariable("VCPKG_ROOT", ${Selected}, "Machine")
    Set-Item -Path Env:VCPKG_ROOT -Value ${Selected}
    Set-Item -Path Env:PATH -Value "${Selected};${Env:PATH}"
}

function Use-VCPKG
{
    $Selected = Select-From-List $(Get-VCPKGList) 'available VCPKG locations'
    Set-Item -Path Env:PATH -Value "${Selected};${Env:PATH}"
}

function Unset-VCPKG
{
    [Environment]::SetEnvironmentVariable("VCPKG_ROOT", [NullString]::Value, "Machine")
    if ($env:VCPKG_ROOT)
    {
        Remove-Item Env:VCPKG_ROOT
    }
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
    $vcpkNixPath = ($env:VCPKG_ROOT -replace "\\", "/").ToLower().Trim("/")
    Write-Output "-DCMAKE_TOOLCHAIN_FILE=${vcpkNixPath}/scripts/buildsystems/vcpkg.cmake"
}

function vcpkg-batch-install
{
    $BuildTriplet = "x64-windows"
    $Packages = @(
        "3dxware"
        "assimp"
        "boost"
        "catch2"
        "cgal"
        "dirent"
        "draco"
        "eigen3"
        "embree3"
        "fakeit"
        "fmt"
        "freeglut"
        "glad"
        "glew"
        "glfw3"
        "glib"
        "glm"
        "gts"
        "imgui[docking-experimental,glfw-binding,opengl3-binding,vulkan-binding]"
        "imguizmo"
        "libjpeg-turbo"
        "lodepng"
        "ode"
        "opencv4[contrib]"
        "openssl"
        "pugixml"
        "qt3d"
        "qtbase"
        "qtsvg"
        "qttools"
        "qt5-3d"
        "qt5-base"
        "qt5-tools"
        "quazip"
        "quazip5"
        "spdlog"
        "stb"
        "vtk"
        "vulkan"
        "yaml-cpp"
    )

    foreach ($Package in $Packages)
    {
        vcpkg install --keep-going --recurse --triplet $BuildTriplet $Package
    }
}

function vcpkg-patch-info
{
    Write-Host "`n`tStage the changes:" -ForegroundColor Yellow
    Write-Host "`tgit add . or git add <path-to-file>`n" -ForegroundColor Green

    Write-Host "`tCreate a git patch" -ForegroundColor Yellow
    $Package = Split-Path -leaf -path $(Get-Location)
    Write-Host "`tgit diff --cached --binary > ${Env:VCPKG_ROOT}\overlay\ports\${Package}\000N-patch-name.diff`n"  -ForegroundColor Green
}
