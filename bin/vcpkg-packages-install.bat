@echo off
setlocal enabledelayedexpansion

:: The code for calculating elapsed time is from StackOverflow... Just a nice-to-have feature
set "startTime=%time: =0%" & rem fix single digit hour

:: set VCPKG_FEATURE_FLAGS=-binarycaching
:: set VCPKG_CONCURRENCY=24
set DEFAULT_TRIPLET=x64-windows
set build_triplet=%DEFAULT_TRIPLET%
set vcpkg_library_list="%~dp0vcpkg-packages.txt"

if NOT "%~2" == "" (set build_triplet=%~1)
if NOT "%~3" == "" (set vcpkg_library_list=%~2)

if not exist %CD%\.vcpkg-root exit /b 1

:: Remove vcpkg.exe for smooth upgrades...
del /F/S vcpkg.exe
call bootstrap-vcpkg.bat -disableMetrics || exit /b 1

set libs=
for /f "delims=" %%x in ('type %vcpkg_library_list%') do set "libs=!libs! %%x"

set libs_no_features=
for /f "delims=" %%x in ('type %vcpkg_library_list%') do (
    for /f "tokens=1 delims=[" %%a in ("%%x") do set "libs_no_features=!libs_no_features! %%a"
)

if "%~1" == "force" (
    echo ================================================================================
    echo ===============      Cleaning up
    echo ================================================================================

    echo vcpkg remove --recurse yasm:x86-windows
    vcpkg remove --recurse yasm:x86-windows || exit /b 1
    echo vcpkg remove --recurse --triplet %build_triplet% %libs_no_features%
    vcpkg remove --recurse --triplet %build_triplet% %libs_no_features% || exit /b 1
)

echo ================================================================================
echo ===============      Building triplet: %build_triplet%
echo ================================================================================
:: yasm (x86 version) is a build dependency for yaml-cpp on Windows...
if "%~1" == "force" (
    echo vcpkg install --keep-going --recurse --no-binarycaching yasm:x86-windows
    vcpkg install --keep-going --recurse --no-binarycaching yasm:x86-windows || exit /b 1
) else (
    echo vcpkg install --keep-going --recurse yasm:x86-windows
    vcpkg install --keep-going --recurse yasm:x86-windows || exit /b 1
)

if "%~1" == "force" (
    echo vcpkg install --keep-going --recurse --no-binarycaching --triplet %build_triplet% %libs%
    vcpkg install --keep-going --recurse --no-binarycaching --triplet %build_triplet% %libs% || exit /b 1
) else (
    echo vcpkg install --keep-going --recurse --triplet %build_triplet% %libs%
    vcpkg install --keep-going --recurse --triplet %build_triplet% %libs% || exit /b 1
)

:: Incredibuld
:: BuildConsole /command="vcpkg install --keep-going --recurse yasm:x86-windows" || exit /b 1
:: BuildConsole /command="vcpkg install --keep-going --recurse --triplet %build_triplet% %libs%" || exit /b 1

:: The mess below calculates elapsed time
set "endTime=%time: =0%" & rem fix single digit hour

rem Regional format fix with just one aditional line
for /f "tokens=1-3 delims=0123456789" %%i in ("%endTime%") do set "COLON=%%i" & set "DOT=%%k"

rem Get elapsed time:
set "end=!endTime:%DOT%=%%100)*100+1!" & set "start=!startTime:%DOT%=%%100)*100+1!"
set /A "elap=((((10!end:%COLON%=%%100)*60+1!%%100)-((((10!start:%COLON%=%%100)*60+1!%%100)"

rem Fix 24 hours
set /A "elap=!elap:-=8640000-!"

rem Convert elapsed time to HH:MM:SS:CC format:
set /A "cc=elap%%100+100,elap/=100,ss=elap%%60+100,elap/=60,mm=elap%%60+100,hh=elap/60+100"

echo Build Started:       %startTime%
echo Build Ended:         %endTime%
echo Build Elapsed Time:  %hh:~1%%COLON%%mm:~1%%COLON%%ss:~1%%DOT%%cc:~1% & rem display as regional
echo Delete your build directory if it still exists.
endlocal

