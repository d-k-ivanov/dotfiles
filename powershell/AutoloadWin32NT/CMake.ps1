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
# Set-Alias csp22  cmake-presets-22
# Set-Alias csprnj cmake-presets-rnj
# Set-Alias cspr22 cmake-presets-r22

# CMake Settings
${function:cmake-settings-19}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2019.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-22}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2022.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-nj}  = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-Ninja.json ${PWD}\CMakeSettings.json }

${function:cmake-settings-envs-17} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2017-envs.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-envs-19} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2019-envs.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-envs-22} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-2022-envs.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-envs-nj} = { Copy-Item ${Env:USERPROFILE}\.config\cmake\settings\CMakeSettings-Ninja-envs.json ${PWD}\CMakeSettings.json }

# CMake Settings: with Environments

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
${function:cgen-nj-multy}   = { cmake -G "Ninja Multi-Config"    -A x64            -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }

# CMake Generator: MSVC Specific versions
${function:cgen-22-1442}    = { cmake -G "Visual Studio 17 2022" -A x64 -T version=14.42 -B build -S $(If ($args[0]) { $args } Else { Get-Location }) }

# CMake Generator: Find Vcpkg
${function:cgen-22-v}       = { cmake -G "Visual Studio 17 2022" -A x64 -B build -S $(If ($args[0]) { $args } Else { Get-Location }) $(vcpkg-cmake) }
${function:cgen-nj-multy-v} = { cmake -G "Ninja Multi-Config"    -A x64 -B build -S $(If ($args[0]) { $args } Else { Get-Location }) $(vcpkg-cmake) }

# CMake Generators: Build Types
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
${function:cbuild}   = { cmake --build build @args }

${function:cbuilddb} = { cmake --build build --config Debug          @args }
${function:cbuildrl} = { cmake --build build --config Release        @args }
${function:cbuildrd} = { cmake --build build --config RelWithDebInfo @args }

# ${function:cbuilddb} = { cmake --build build/x64-Debug          --config Debug          @args }
# ${function:cbuildrl} = { cmake --build build/x64-Release        --config Release        @args }
# ${function:cbuildrd} = { cmake --build build/x64-RelWithDebInfo --config RelWithDebInfo @args }

${function:cgenbuld} = { cgen-22; cbuildrd }
Set-Alias cgb cgenbuld

# CTest
${function:cc-ctest}            = { ctest --test-dir build @args    }
${function:cc-ctest-show}       = { ctest --test-dir build -N       }
${function:cc-ctest-filter}     = { ctest --test-dir build -R @args }

${function:cc-ctest-r}         = { ctest --test-dir build/x64-Release @args    }
${function:cc-ctest-r-show}    = { ctest --test-dir build/x64-Release -N       }
${function:cc-ctest-r-filter}  = { ctest --test-dir build/x64-Release -R @args }

${function:cc-ctest-d}         = { ctest --test-dir build/x64-Debug @args    }
${function:cc-ctest-d-show}    = { ctest --test-dir build/x64-Debug -N       }
${function:cc-ctest-d-filter}  = { ctest --test-dir build/x64-Debug -R @args }

${function:cc-ctest-rd}        = { ctest --test-dir build/x64-RelWithDebInfo @args    }
${function:cc-ctest-rd-show}   = { ctest --test-dir build/x64-RelWithDebInfo -N       }
${function:cc-ctest-rd-filter} = { ctest --test-dir build/x64-RelWithDebInfo -R @args }
