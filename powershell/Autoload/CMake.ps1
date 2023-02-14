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

# CMake Settings
${function:cmake-settings-22}  = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-2022.json       ${PWD}\CMakeSettings.json }
${function:cmake-settings-nj}  = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-Ninja.json      ${PWD}\CMakeSettings.json }
${function:cmake-settings-22e} = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-2022-envs.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-19e} = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-2019-envs.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-17e} = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-2017-envs.json  ${PWD}\CMakeSettings.json }
${function:cmake-settings-nje} = { Copy-Item ${Env:WORKSPACE}\my\dotfiles\data\cmake\CMakeSettings-Ninja-envs.json ${PWD}\CMakeSettings.json }

${function:cgen-22-reldebug} = { cmake -G "Visual Studio 17 2022" -A x64 -B build/x64-RelWithDebInfo -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo @args }
${function:cgen-19-reldebug} = { cmake -G "Visual Studio 16 2019" -A x64 -B build/x64-RelWithDebInfo -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo @args }
${function:cgen-17-reldebug} = { cmake -G "Visual Studio 15 2017" -A x64 -B build/x64-RelWithDebInfo -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo @args }
${function:cgen-17-reldebug} = { cmake -G "Visual Studio 14 2015" -A x64 -B build/x64-RelWithDebInfo -S . -DCMAKE_BUILD_TYPE=RelWithDebInfo @args }

${function:cgen-22-debug} = { cmake -G "Visual Studio 17 2022" -A x64 -B build/x64-Debug -S . -DCMAKE_BUILD_TYPE=Debug @args }
${function:cgen-19-debug} = { cmake -G "Visual Studio 16 2019" -A x64 -B build/x64-Debug -S . -DCMAKE_BUILD_TYPE=Debug @args }
${function:cgen-17-debug} = { cmake -G "Visual Studio 15 2017" -A x64 -B build/x64-Debug -S . -DCMAKE_BUILD_TYPE=Debug @args }
${function:cgen-17-debug} = { cmake -G "Visual Studio 14 2015" -A x64 -B build/x64-Debug -S . -DCMAKE_BUILD_TYPE=Debug @args }
${function:cgen-nj-debug} = { cmake -G "Ninja"                 -A x64 -B build/x64-Debug -S . -DCMAKE_BUILD_TYPE=Debug @args }

${function:cgen-22-release} = { cmake -G "Visual Studio 17 2022" -A x64 -B build/x64-Release -S . -DCMAKE_BUILD_TYPE=Release @args }
${function:cgen-19-release} = { cmake -G "Visual Studio 16 2019" -A x64 -B build/x64-Release -S . -DCMAKE_BUILD_TYPE=Release @args }
${function:cgen-17-release} = { cmake -G "Visual Studio 15 2017" -A x64 -B build/x64-Release -S . -DCMAKE_BUILD_TYPE=Release @args }
${function:cgen-15-release} = { cmake -G "Visual Studio 15 2015" -A x64 -B build/x64-Release -S . -DCMAKE_BUILD_TYPE=Release @args }
${function:cgen-nj-release} = { cmake -G "Ninja"                 -A x64 -B build/x64-Release -S . -DCMAKE_BUILD_TYPE=Release @args }

${function:cgen-nj-multy} = { cmake -G "Ninja Multi-Config" -A x64 -B build -S . @args }

# CMake Aliases
Set-Alias cs cmake-settings-22
Set-Alias csn cmake-settings-nj
Set-Alias cs22 cmake-settings-22
Set-Alias cs22e cmake-settings-22-envs
Set-Alias cs19e cmake-settings-19-envs
Set-Alias cs17e cmake-settings-17-envs
Set-Alias cgen  cgen-22-debug
Set-Alias cgend cgen-22-debug
Set-Alias cgenr cgen-22-release
Set-Alias cgenrd cgen-22-reldebug

# CMake Gen&Build Aliases (Release)
${function:cmake2015x86} = { Set-VC-Vars-All x86; cgen-15-release ; cmake --build build/Release --config "Release" }
${function:cmake2015x64} = { Set-VC-Vars-All x64; cgen-15-release ; cmake --build build/Release --config "Release" }
${function:cmake2017x86} = { Set-VC-Vars-All x86; cgen-17-release ; cmake --build build/Release --config "Release" }
${function:cmake2017x64} = { Set-VC-Vars-All x64; cgen-17-release ; cmake --build build/Release --config "Release" }
${function:cmake2019x86} = { dev32; cgen-19-release ; cmake --build build/Release --config "Release" }
${function:cmake2019x64} = { dev64; cgen-19-release ; cmake --build build/Release --config "Release" }
${function:cmake2022x86} = { dev32; cgen-22-release ; cmake --build build/Release --config "Release" }
${function:cmake2022x64} = { dev64; cgen-22-release ; cmake --build build/Release --config "Release" }

${function:cbuild} = { cmake --build @args }

# CTest
${function:ctest} = { ctest --test-dir build\Debug @args }
${function:ctest-show} = { ctest --test-dir build\Debug -N }
${function:ctest-filter} = { ctest --test-dir build\Debug @args }

${function:ctest-rd} = { ctest --test-dir build\RelDebug @args }
${function:ctest-rd-show} = { ctest --test-dir build\RelDebug -N }
${function:ctest-rd-filter} = { ctest --test-dir build\RelDebug -R @args }

${function:ctest-r} = { ctest --test-dir build\Release @args }
${function:ctest-r-show} = { ctest --test-dir build\Release -N }
${function:ctest-r-filter} = { ctest --test-dir build\Release -R @args }

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
