<#
.SYNOPSIS
Cmake scripts.

.DESCRIPTION
Cmake scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# CMake Presets
${function:cmake-presets-nj}  = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakePresets-Ninja.json          ${PWD}\CMakePresets.json }
${function:cmake-presets-22}  = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakePresets-MSVC-22.json        ${PWD}\CMakePresets.json }
${function:cmake-presets-rnj} = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakePresets-RelDebug-Ninja.json ${PWD}\CMakePresets.json }
${function:cmake-presets-r22} = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakePresets-RelDebug-MSVC.json  ${PWD}\CMakePresets.json }

# CMake Presets Aliases
# Set-Alias csp    cmake-presets-nj
# Set-Alias cspnj  cmake-presets-nj
# Set-Alias csp22  cmake-presets-22
# Set-Alias csprnj cmake-presets-rnj
# Set-Alias cspr22 cmake-presets-r22

# CMake Settings
${function:cmake-settings-22}  = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-2022.json         ${PWD}\CMakeSettings.json }
${function:cmake-settings-nj}  = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-Ninja.json        ${PWD}\CMakeSettings.json }
${function:cmake-settings-22e} = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-2022-envs.json    ${PWD}\CMakeSettings.json }
${function:cmake-settings-19e} = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-2019-envs.json    ${PWD}\CMakeSettings.json }
${function:cmake-settings-17e} = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-2017-envs.json    ${PWD}\CMakeSettings.json }
${function:cmake-settings-nje} = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-Ninja-envs.json   ${PWD}\CMakeSettings.json }

# CMake Settings Aliases
# Set-Alias cs    cmake-settings-22
# Set-Alias csn   cmake-settings-nj
# Set-Alias cs22  cmake-settings-22
# Set-Alias cs22e cmake-settings-22-envs
# Set-Alias cs19e cmake-settings-19-envs
# Set-Alias cs17e cmake-settings-17-envs

# CMake Generators
${function:cgen-22}         = { cmake -G "Visual Studio 17 2022" -A x64            -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }
${function:cgen-22-cl}      = { cmake -G "Visual Studio 17 2022" -A x64 -T ClangCL -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }
${function:cgen-nj-multy}   = { cmake -G "Ninja Multi-Config" -A x64               -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }

${function:cgen-22-v}       = { cmake -G "Visual Studio 17 2022" -A x64 -B build -S $(If ($args[0]) { $args } Else { Get-Location }) $(vcpkg-cmake) }
${function:cgen-nj-multy-v} = { cmake -G "Ninja Multi-Config"    -A x64 -B build -S $(If ($args[0]) { $args } Else { Get-Location }) $(vcpkg-cmake) }

${function:cgen-debug-nj} = { cmake -G "Ninja"                        -B build/x64-Debug -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug }
${function:cgen-debug-22} = { cmake -G "Visual Studio 17 2022" -A x64 -B build/x64-Debug -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug }
${function:cgen-debug-19} = { cmake -G "Visual Studio 16 2019" -A x64 -B build/x64-Debug -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug }
${function:cgen-debug-17} = { cmake -G "Visual Studio 15 2017" -A x64 -B build/x64-Debug -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug }
${function:cgen-debug-15} = { cmake -G "Visual Studio 14 2015" -A x64 -B build/x64-Debug -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug }

${function:cgen-release-nj} = { cmake -G "Ninja"                        -B build/x64-Release -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release }
${function:cgen-release-22} = { cmake -G "Visual Studio 17 2022" -A x64 -B build/x64-Release -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release }
${function:cgen-release-19} = { cmake -G "Visual Studio 16 2019" -A x64 -B build/x64-Release -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release }
${function:cgen-release-17} = { cmake -G "Visual Studio 15 2017" -A x64 -B build/x64-Release -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release }
${function:cgen-release-15} = { cmake -G "Visual Studio 15 2015" -A x64 -B build/x64-Release -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release }

${function:cgen-reldebug-nj} = { cmake -G "Ninja"                        -B build/x64-RelWithDebInfo -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }
${function:cgen-reldebug-22} = { cmake -G "Visual Studio 17 2022" -A x64 -B build/x64-RelWithDebInfo -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }
${function:cgen-reldebug-19} = { cmake -G "Visual Studio 16 2019" -A x64 -B build/x64-RelWithDebInfo -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }
${function:cgen-reldebug-17} = { cmake -G "Visual Studio 15 2017" -A x64 -B build/x64-RelWithDebInfo -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }
${function:cgen-reldebug-15} = { cmake -G "Visual Studio 14 2015" -A x64 -B build/x64-RelWithDebInfo -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }

# CMake Generators Aliases
Set-Alias cgen   cgen-22
Set-Alias cgenv  cgen-22-v
Set-Alias cgencl cgen-22-cl
Set-Alias cgend  cgen-debug-22
Set-Alias cgenr  cgen-release-22
Set-Alias cgenrd cgen-reldebug-22

# CMake Gen&Build Aliases (Release)
${function:cmake2022x86} = { dev32; cgen-release-22; cmake --build build/x64-Release --config "Release" }
${function:cmake2022x64} = { dev64; cgen-release-22; cmake --build build/x64-Release --config "Release" }
${function:cmake2019x86} = { dev32; cgen-release-19; cmake --build build/x64-Release --config "Release" }
${function:cmake2019x64} = { dev64; cgen-release-19; cmake --build build/x64-Release --config "Release" }
${function:cmake2017x86} = { Set-VC-Vars-All x86; cgen-release-17; cmake --build build/x64-Release --config "Release" }
${function:cmake2017x64} = { Set-VC-Vars-All x64; cgen-release-17; cmake --build build/x64-Release --config "Release" }
${function:cmake2015x86} = { Set-VC-Vars-All x86; cgen-release-15; cmake --build build/x64-Release --config "Release" }
${function:cmake2015x64} = { Set-VC-Vars-All x64; cgen-release-15; cmake --build build/x64-Release --config "Release" }

# CMake Build Aliases
${function:cbuild}   = { cmake --build @args }
${function:cbuilddb} = { cmake --build --config Debug          @args build/x64-Debug          }
${function:cbuildrl} = { cmake --build --config Release        @args build/x64-Release        }
${function:cbuildrd} = { cmake --build --config RelWithDebInfo @args build/x64-RelWithDebInfo }

# CTest
${function:ctest}            = { ctest --test-dir build @args    }
${function:ctest-show}       = { ctest --test-dir build -N       }
${function:ctest-filter}     = { ctest --test-dir build -R @args }

${function:ctest-r}         = { ctest --test-dir build/x64-Release @args    }
${function:ctest-r-show}    = { ctest --test-dir build/x64-Release -N       }
${function:ctest-r-filter}  = { ctest --test-dir build/x64-Release -R @args }

${function:ctest-d}         = { ctest --test-dir build/x64-Debug @args    }
${function:ctest-d-show}    = { ctest --test-dir build/x64-Debug -N       }
${function:ctest-d-filter}  = { ctest --test-dir build/x64-Debug -R @args }

${function:ctest-rd}        = { ctest --test-dir build/x64-RelWithDebInfo @args    }
${function:ctest-rd-show}   = { ctest --test-dir build/x64-RelWithDebInfo -N       }
${function:ctest-rd-filter} = { ctest --test-dir build/x64-RelWithDebInfo -R @args }

function ccc
{
    [CmdletBinding()]
    param([switch] $Shared)

    New-Item build -ItemType Directory -ErrorAction SilentlyContinue
    Set-Location build
    dev
    if ($Shared) { conan_install -Shared } else { conan_install }
    cmake_gen
    cmake_build
}
