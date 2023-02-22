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

${function:vcpkg-remove}        = { vcpkg remove            --triplet x64-linux @args }
${function:vcpkg-remove-r}      = { vcpkg remove  --recurse --triplet x64-linux @args }
${function:vcpkg-install}       = { vcpkg install           --triplet x64-linux @args }
${function:vcpkg-install-r}     = { vcpkg install --recurse --triplet x64-linux @args }

${function:vcpkg-remove-osx}    = { vcpkg remove            --triplet x64-osx   @args }
${function:vcpkg-remove-osx-r}  = { vcpkg remove  --recurse --triplet x64-osx   @args }
${function:vcpkg-install-osx}   = { vcpkg install           --triplet x64-osx   @args }
${function:vcpkg-install-osx-r} = { vcpkg install --recurse --triplet x64-osx   @args }
