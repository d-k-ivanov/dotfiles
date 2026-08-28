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

$ninjaVersion = $null
if (Get-Command ninja -ErrorAction SilentlyContinue)
{
    if ((ninja --version 2>$null) -match '\d+\.\d+')
    {
        $ninjaVersion = $Matches[0]
    }
}

if ($ninjaVersion -and ([version] $ninjaVersion -ge [version] '1.12'))
{
    $Env:NINJA_STATUS = "[%w %f/%t %P] "
}
else
{
    $Env:NINJA_STATUS = "[%f/%t] "
}

# CMake Presets
${function:cmake-presets-26}   = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-MSVC-26.json          ${PWD}\CMakePresets.json }
${function:cmake-presets-26d}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-MSVC-26-Debug.json    ${PWD}\CMakePresets.json }
${function:cmake-presets-26r}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-MSVC-26-Release.json  ${PWD}\CMakePresets.json }
${function:cmake-presets-26rd} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-MSVC-26-RelDebug.json ${PWD}\CMakePresets.json }

${function:cmake-presets-22}   = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-MSVC-22.json          ${PWD}\CMakePresets.json }
${function:cmake-presets-22d}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-MSVC-22-Debug.json    ${PWD}\CMakePresets.json }
${function:cmake-presets-22r}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-MSVC-22-Release.json  ${PWD}\CMakePresets.json }
${function:cmake-presets-22rd} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-MSVC-22-RelDebug.json ${PWD}\CMakePresets.json }

${function:cmake-presets-nj}   = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-Ninja.json            ${PWD}\CMakePresets.json }
${function:cmake-presets-nj2}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-Ninja-v2.json         ${PWD}\CMakePresets.json }
${function:cmake-presets-njd}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-Ninja-Debug.json      ${PWD}\CMakePresets.json }
${function:cmake-presets-njr}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-Ninja-Release.json    ${PWD}\CMakePresets.json }
${function:cmake-presets-njrd} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\presets\CMakePresets-Windows-Ninja-RelDebug.json   ${PWD}\CMakePresets.json }

# CMake Presets Aliases
# Set-Alias csp    cmake-presets-nj
# Set-Alias cspnj  cmake-presets-nj
# Set-Alias csp26  cmake-presets-26
# Set-Alias csp22  cmake-presets-22
# Set-Alias csprnj cmake-presets-rnj
# Set-Alias cspr26 cmake-presets-r26
# Set-Alias cspr22 cmake-presets-r22

# CMake Settings
${function:cmake-settings-19}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2019.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-22}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2022.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-26}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2026.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-nj}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-Ninja.json ${PWD}\CMakeSettings.json }

${function:cmake-settings-envs-17} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2017-envs.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-envs-19} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2019-envs.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-envs-22} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2022-envs.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-envs-26} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2026-envs.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-envs-nj} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-Ninja-envs.json ${PWD}\CMakeSettings.json }

# CMake Settings: with Environments

# CMake Settings Aliases
# Set-Alias cs    cmake-settings-26
# Set-Alias csn   cmake-settings-nj
# Set-Alias cs26  cmake-settings-26
# Set-Alias cs22  cmake-settings-22
# Set-Alias cs26e cmake-settings-26-envs
# Set-Alias cs22e cmake-settings-22-envs
# Set-Alias cs19e cmake-settings-19-envs
# Set-Alias cs17e cmake-settings-17-envs

# CMake Generator: Visual Studio 2026
${function:cgen-26}         = { cmake -G "Visual Studio 18 2026" -A x64                  -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }
${function:cgen-26-1444}    = { cmake -G "Visual Studio 18 2026" -A x64 -T version=14.44 -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }
${function:cgen-26-1450}    = { cmake -G "Visual Studio 18 2026" -A x64 -T version=14.50 -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }
${function:cgen-26-1451}    = { cmake -G "Visual Studio 18 2026" -A x64 -T version=14.51 -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }
${function:cgen-26-cl}      = { cmake -G "Visual Studio 18 2026" -A x64 -T ClangCL       -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }
${function:cgen-26-vcpkg}   = { cmake -G "Visual Studio 18 2026" -A x64                  -B build -S $(If ($args[0]) { $args } Else { Get-Location }) $(vcpkg-cmake) }

# CMake Generator: Visual Studio 2022
${function:cgen-22}         = { cmake -G "Visual Studio 17 2022" -A x64                  -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }
${function:cgen-22-1442}    = { cmake -G "Visual Studio 17 2022" -A x64 -T version=14.42 -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }
${function:cgen-22-cl}      = { cmake -G "Visual Studio 17 2022" -A x64 -T ClangCL       -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }
${function:cgen-22-vcpkg}   = { cmake -G "Visual Studio 17 2022" -A x64                  -B build -S $(If ($args[0]) { $args } Else { Get-Location }) $(vcpkg-cmake) }

# CMake Generator: Ninja
${function:cgen-nj-debug}       = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug          }
${function:cgen-nj-release}     = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release        }
${function:cgen-nj-reldebug}    = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }

# CMake Generator: Ninja -PCH +INSTALL
${function:cgen-nj-debug-w}     = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug          -DENABLE_PCH=OFF -DENABLE_INSTALL=ON }
${function:cgen-nj-release-w}   = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release        -DENABLE_PCH=OFF -DENABLE_INSTALL=ON }
${function:cgen-nj-reldebug-w}  = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo -DENABLE_PCH=OFF -DENABLE_INSTALL=ON }

# Clang CL
${function:cgen-nj-debug-cl}    = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug          -DCMAKE_C_COMPILER=clang-cl -DCMAKE_CXX_COMPILER=clang-cl }
${function:cgen-nj-release-cl}  = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release        -DCMAKE_C_COMPILER=clang-cl -DCMAKE_CXX_COMPILER=clang-cl }
${function:cgen-nj-reldebug-cl} = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=clang-cl -DCMAKE_CXX_COMPILER=clang-cl }

${function:cgen-nj-debug-v}     = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug          $(vcpkg-cmake) }
${function:cgen-nj-release-v}   = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release        $(vcpkg-cmake) }
${function:cgen-nj-reldebug-v}  = { cmake -G "Ninja" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo $(vcpkg-cmake) }

# CMake Generator: Ninja Multi-Config
${function:cgen-nj-multi}       = { cmake -G "Ninja Multi-Config" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }
${function:cgen-nj-multi-v}     = { cmake -G "Ninja Multi-Config" -B build -S $(If ($args[0]) { $args } Else { Get-Location }) $(vcpkg-cmake)   }

# CMake Generators: Build Folders: Debug, Release, RelWithDebInfo
${function:cgen-nj-debug-x}    = { cmake -G "Ninja"                        -B build/x64-Debug -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug }
${function:cgen-26-debug-x}    = { cmake -G "Visual Studio 18 2026" -A x64 -B build/x64-Debug -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug }
${function:cgen-22-debug-x}    = { cmake -G "Visual Studio 17 2022" -A x64 -B build/x64-Debug -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug }
${function:cgen-19-debug-x}    = { cmake -G "Visual Studio 16 2019" -A x64 -B build/x64-Debug -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug }
${function:cgen-17-debug-x}    = { cmake -G "Visual Studio 15 2017" -A x64 -B build/x64-Debug -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug }
${function:cgen-15-debug-x}    = { cmake -G "Visual Studio 14 2015" -A x64 -B build/x64-Debug -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Debug }

${function:cgen-nj-release-x}  = { cmake -G "Ninja"                        -B build/x64-Release -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release }
${function:cgen-26-release-x}  = { cmake -G "Visual Studio 18 2026" -A x64 -B build/x64-Release -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release }
${function:cgen-22-release-x}  = { cmake -G "Visual Studio 17 2022" -A x64 -B build/x64-Release -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release }
${function:cgen-19-release-x}  = { cmake -G "Visual Studio 16 2019" -A x64 -B build/x64-Release -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release }
${function:cgen-17-release-x}  = { cmake -G "Visual Studio 15 2017" -A x64 -B build/x64-Release -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release }
${function:cgen-15-release-x}  = { cmake -G "Visual Studio 14 2015" -A x64 -B build/x64-Release -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=Release }

${function:cgen-nj-reldebug-x} = { cmake -G "Ninja"                        -B build/x64-RelWithDebInfo -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }
${function:cgen-26-reldebug-x} = { cmake -G "Visual Studio 18 2026" -A x64 -B build/x64-RelWithDebInfo -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }
${function:cgen-22-reldebug-x} = { cmake -G "Visual Studio 17 2022" -A x64 -B build/x64-RelWithDebInfo -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }
${function:cgen-19-reldebug-x} = { cmake -G "Visual Studio 16 2019" -A x64 -B build/x64-RelWithDebInfo -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }
${function:cgen-17-reldebug-x} = { cmake -G "Visual Studio 15 2017" -A x64 -B build/x64-RelWithDebInfo -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }
${function:cgen-15-reldebug-x} = { cmake -G "Visual Studio 14 2015" -A x64 -B build/x64-RelWithDebInfo -S $(If ($args[0]) { $args } Else { Get-Location }) -DCMAKE_BUILD_TYPE=RelWithDebInfo }

# CMake Build
${function:cbuild-debug}    = { cmake --build build --config Debug          @args }
${function:cbuild-release}  = { cmake --build build --config Release        @args }
${function:cbuild-reldebug} = { cmake --build build --config RelWithDebInfo @args }

${function:cbuild-debug-x}    = { cmake --build build/x64-Debug          --config Debug          @args }
${function:cbuild-release-x}  = { cmake --build build/x64-Release        --config Release        @args }
${function:cbuild-reldebug-x} = { cmake --build build/x64-RelWithDebInfo --config RelWithDebInfo @args }

${function:cgenbuild}   = { cgen-nj-reldebug; cbuild-reldebug }
${function:cgenbuild-w} = { cgen-nj-reldebug-w; cbuild-reldebug }
${function:cgenbuild-x} = { cgen-nj-reldebug-x; cbuild-reldebug-x }


# CMake Aliases
Set-Alias cbuild cbuild-reldebug
Set-Alias cgb       cgenbuild
Set-Alias cgbw      cgenbuild-w
Set-Alias cgen      cgen-nj-reldebug
Set-Alias cgenw     cgen-nj-reldebug-w
Set-Alias cgencl    cgen-nj-reldebug-cl
Set-Alias cgend     cgen-nj-debug
Set-Alias cgendw    cgen-nj-debug-w
Set-Alias cgenr     cgen-nj-release
Set-Alias cgenrw    cgen-nj-release-w
Set-Alias cgenrd    cgen-nj-reldebug
Set-Alias cgenrdw   cgen-nj-reldebug-w
Set-Alias cgenv     cgen-nj-reldebug-v

# CMake Gen&Build Aliases (Release)
${function:cmake2026x86} = { dev32; cgen-release-26; cmake --build build/x64-Release --config "Release" }
${function:cmake2026x64} = { dev64; cgen-release-26; cmake --build build/x64-Release --config "Release" }
${function:cmake2022x86} = { dev32; cgen-release-22; cmake --build build/x64-Release --config "Release" }
${function:cmake2022x64} = { dev64; cgen-release-22; cmake --build build/x64-Release --config "Release" }
${function:cmake2019x86} = { dev32; cgen-release-19; cmake --build build/x64-Release --config "Release" }
${function:cmake2019x64} = { dev64; cgen-release-19; cmake --build build/x64-Release --config "Release" }
${function:cmake2017x86} = { Set-VC-Vars-All x86; cgen-release-17; cmake --build build/x64-Release --config "Release" }
${function:cmake2017x64} = { Set-VC-Vars-All x64; cgen-release-17; cmake --build build/x64-Release --config "Release" }
${function:cmake2015x86} = { Set-VC-Vars-All x86; cgen-release-15; cmake --build build/x64-Release --config "Release" }
${function:cmake2015x64} = { Set-VC-Vars-All x64; cgen-release-15; cmake --build build/x64-Release --config "Release" }

# CTest
${function:cc-ctest}            = { ctest --test-dir build @args    }
${function:cc-ctest-show}       = { ctest --test-dir build -N       }
${function:cc-ctest-filter}     = { ctest --test-dir build -R @args }

${function:cc-ctest-r}          = { ctest --test-dir build/x64-Release @args    }
${function:cc-ctest-r-show}     = { ctest --test-dir build/x64-Release -N       }
${function:cc-ctest-r-filter}   = { ctest --test-dir build/x64-Release -R @args }

${function:cc-ctest-d}          = { ctest --test-dir build/x64-Debug @args    }
${function:cc-ctest-d-show}     = { ctest --test-dir build/x64-Debug -N       }
${function:cc-ctest-d-filter}   = { ctest --test-dir build/x64-Debug -R @args }

${function:cc-ctest-rd}         = { ctest --test-dir build/x64-RelWithDebInfo @args    }
${function:cc-ctest-rd-show}    = { ctest --test-dir build/x64-RelWithDebInfo -N       }
${function:cc-ctest-rd-filter}  = { ctest --test-dir build/x64-RelWithDebInfo -R @args }
