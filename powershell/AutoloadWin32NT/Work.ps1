<#
.SYNOPSIS
Work Scripts

.DESCRIPTION
Work Scripts
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red`
    Exit
}

function Set-CCVCPKG
{
    ${local:vcpkg_root_path} = "c:\vcpkg"
    ${local:vcpkg_dev_path} = "c:\v"

    [Environment]::SetEnvironmentVariable("CC_VCPKG_ROOT", $vcpkg_root_path , "Machine")
    Set-Item -Path Env:CC_VCPKG_ROOT -Value $vcpkg_root_path
    [Environment]::SetEnvironmentVariable("CC_VCPKG_DEV", $vcpkg_dev_path, "Machine")
    Set-Item -Path Env:CC_VCPKG_DEV -Value $vcpkg_dev_path
}

# === Current === #
${function:ccdev}   = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\dev" -Force}
${function:ccdevm}  = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:WORKSPACE}\vcpkg" -Force}
${function:ccdevs}  = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\shit" -Force}
${function:ccdev5}  = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\a761262edcfa6bb92eab2917ac9c4382138b3bf5" -Force}
${function:ccdev60} = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\fea1b6ae25a41b52e4581ff690c178d4a9224740" -Force}
${function:ccdev61} = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\a761262edcfa6bb92eab2917ac9c4382138b3bf5" -Force}
${function:ccdev70} = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\9c921f33c" -Force}
${function:ccdev71} = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\a101126ba" -Force}
${function:ccdev72} = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\286666521" -Force}
${function:ccdev73} = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\617fb6a9d" -Force}
${function:ccdev74} = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\6ef94459d" -Force}
${function:ccdev80} = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\3f605a228" -Force}
${function:ccdev81} = { New-Item -Path "${Env:CC_VCPKG_DEV}" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\dcc8b01f3" -Force}

${function:ccdevX} = { New-Item -Path ${Env:CC_VCPKG_DEV} -ItemType SymbolicLink -Value ${Env:CC_VCPKG_ROOT}\$args -Force}

# === Legacy  === #
${function:ccdev24} = { New-Item -Path "${Env:USERPROFILE}\vcpkg-export-latest" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\db5bd8485aea62500c09491a959a0fe7cc254e85" -Force}
${function:ccdev25} = { New-Item -Path "${Env:USERPROFILE}\vcpkg-export-latest" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\db5bd8485aea62500c09491a959a0fe7cc254e85" -Force}
${function:ccdev26} = { New-Item -Path "${Env:USERPROFILE}\vcpkg-export-latest" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\8eaa6567bc1462280ce5200dc06391e847b5fd83" -Force}
${function:ccdev3}  = { New-Item -Path "${Env:USERPROFILE}\vcpkg-export-latest" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\a761262edcfa6bb92eab2917ac9c4382138b3bf5" -Force}
${function:ccdev4}  = { New-Item -Path "${Env:USERPROFILE}\vcpkg-export-latest" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\a761262edcfa6bb92eab2917ac9c4382138b3bf5" -Force}
${function:ccdev5l} = { New-Item -Path "${Env:USERPROFILE}\vcpkg-export-latest" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\a761262edcfa6bb92eab2917ac9c4382138b3bf5" -Force}
${function:ccdev6l} = { New-Item -Path "${Env:USERPROFILE}\vcpkg-export-latest" -ItemType SymbolicLink -Value "${Env:CC_VCPKG_ROOT}\fea1b6ae25a41b52e4581ff690c178d4a9224740" -Force}

# ${function:ccdev5} = { C:\Windows\System32\cmd /c mklink /d "${Env:USERPROFILE}\vcpkg-export-latest" "${Env:USERPROFILE}\vcpkg-export-5.0" }
# ${function:ccdev6} = { C:\Windows\System32\cmd /c mklink /d "${Env:USERPROFILE}\vcpkg-export-latest" "${Env:USERPROFILE}\vcpkg-export-6.0" }
