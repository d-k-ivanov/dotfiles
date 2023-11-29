@echo off
setlocal enabledelayedexpansion

:: The code for calculating elapsed time is from StackOverflow... Just a nice-to-have feature
set "startTime=%time: =0%" & rem fix single digit hour

:: set VCPKG_FEATURE_FLAGS=-binarycaching
:: set VCPKG_CONCURRENCY=24
set DEFAULT_TRIPLET=x64-windows
set build_triplet=%DEFAULT_TRIPLET%
set "OUTPUT_DIR=C:\vcpkg\dev"
set vcpkg_library_list="cc-required-libs-windows.txt"

if NOT "%~1" == "" (set build_triplet=%~1)
if NOT "%~2" == "" (set vcpkg_library_list=%~2)

if not exist %CD%\.vcpkg-root exit /b 1

:: Remove vcpkg.exe for smooth upgrades...
del /F/S vcpkg.exe
call bootstrap-vcpkg.bat -disableMetrics || exit /b 1

set /p CURRENT_HASH=<..\vcpkg_hash
if [!CURRENT_HASH!] equ [] (
  @echo File vcpkg_hash was not found. Using latest git revision...
  git rev-parse @ > setup-hash.txt
  set /p CURRENT_HASH=< setup-hash.txt
  del setup-hash.txt
)
:: Here we determine if there have been any changes since the last build

if EXIST "%OUTPUT_DIR%\repo-git-hash.txt" (
    set /p OLD_HASH=< "%OUTPUT_DIR%\repo-git-hash.txt"
) else (
    set OLD_HASH=
)

@REM if "%OLD_HASH%" == "!CURRENT_HASH!" (
@REM 	echo Dependencies are up to date^^! To force export, delete the export dir '%OUTPUT_DIR%'
@REM 	exit /b 0
@REM )
@REM echo vcpkg hash changed from '%OLD_HASH%' to '!CURRENT_HASH!'; will rebuild/reexport...

echo vcpkg old hash: '%OLD_HASH%'
echo vcpkg current hash: '!CURRENT_HASH!'

set libs=
for /f "delims=" %%x in ('type %vcpkg_library_list%') do set "libs=!libs! %%x"
set libs_no_features=%libs:[contrib]=%
:: Here are some locations where things tend to get cached, and how to remove...
:: We can also disable binary caching, if people want that.
:: rd /s/q buildtrees
:: rd /s/q installed
:: rd /s/q vcpkg-export-latest
:: rd /s/q %USERPROFILE%\AppData\Local\vcpkg\archives\

echo ================================================================================
echo ===============      Cleaning up
echo ================================================================================
:: These are stale and need to be removed
set "BUILD_DIR=%CD%\..\build"
if EXIST "%BUILD_DIR%" ( rd /s/q "%BUILD_DIR%" || ((echo Unable to remove build dir '%BUILD_DIR%') && exit /b 1))
if EXIST "%OUTPUT_DIR%" ( rd /s/q "%OUTPUT_DIR%" || ((echo Unable to remove output dir '%OUTPUT_DIR%') && exit /b 1 ))

@REM Uncomment this section to remove currently installed libraries
@REM echo vcpkg remove --recurse yasm:x86-windows
@REM vcpkg remove --recurse yasm:x86-windows || exit /b 1
@REM echo vcpkg remove --recurse --triplet %build_triplet% %libs%
@REM vcpkg remove --recurse --triplet %build_triplet% %libs% || exit /b 1

echo ================================================================================
echo ===============      Building triplet: %build_triplet%
echo ================================================================================
:: yasm (x86 version) is a build dependency for yaml-cpp on Windows...
echo vcpkg install --keep-going --recurse yasm:x86-windows
vcpkg install --keep-going --recurse yasm:x86-windows || exit /b 1

echo vcpkg install --keep-going --recurse --triplet %build_triplet% %libs%
vcpkg install --keep-going --recurse --triplet %build_triplet% %libs% || exit /b 1

:: Incredibuld
:: BuildConsole /command="vcpkg install --keep-going --recurse yasm:x86-windows" || exit /b 1
:: BuildConsole /command="vcpkg install --keep-going --recurse --triplet %build_triplet% %libs%" || exit /b 1

echo ================================================================================
echo ========================   INSTALL COMPLETE   ==================================
echo ================================================================================
echo Exporting %libs_no_features% to %OUTPUT_DIR%
echo --------------------------------------------------------------------------------
vcpkg export --raw --triplet %build_triplet% --output="%OUTPUT_DIR%" %libs_no_features% || exit /b 1
echo !CURRENT_HASH!> "%OUTPUT_DIR%\repo-git-hash.txt"

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

