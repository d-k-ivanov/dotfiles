<#
.SYNOPSIS
NodeJS' scripts.

.DESCRIPTION
NodeJS' scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# Increase NODE memory local limit
# $Env:NODE_OPTIONS = "--max-old-space-size=4096"

if (Get-Command npm -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:npm-update}               = { npm install npm@latest -g }

    ${function:npm-list-local}           = { npm list        --depth 0 }
    ${function:npm-list-global}          = { npm list     -g --depth 0 }
    ${function:npm-list-local-outdated}  = { npm outdated    --depth=0 }
    ${function:npm-list-global-outdated} = { npm outdated -g --depth=0 }
    ${function:npm-update-local}         = { npm update      }
    ${function:npm-update-global}        = { npm update   -g }

    ${function:npm-update-packagejson}   = { if (-Not (Get-Command ncu.ps1 -ErrorAction SilentlyContinue | Test-Path)) { npm i -g npm-check-updates }; ncu.ps1 -u}
}

# TypeScript
if (Get-Command tsc -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:tsc-all} = { Get-ChildItem -Path src-ts -Filter "*.ts" | % { tsc -strict -target ES2022 --outDir public_html/js $_ } }
    ${function:tsc-all-here} = { Get-ChildItem -Path src-ts -Filter "*.ts" | % { tsc -strict -target ES2022 --outDir $_ } }
    ${function:tsc-build} = { tsc -strict -target ES2022 --outDir public_html/js @args }
    ${function:tsc-build-here} = { tsc -strict -target ES2022 @args }

}
