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

${function:vcpkg-remove}        = { vcpkg remove            --triplet x64-windows @args }
${function:vcpkg-remove-r}      = { vcpkg remove  --recurse --triplet x64-windows @args }
${function:vcpkg-install}       = { vcpkg install           --triplet x64-windows @args }
${function:vcpkg-install-r}     = { vcpkg install --recurse --triplet x64-windows @args }

${function:vcpkg-remove-x86}    = { vcpkg remove            --triplet x86-windows @args }
${function:vcpkg-remove-x86-r}  = { vcpkg remove  --recurse --triplet x86-windows @args }
${function:vcpkg-install-x86}   = { vcpkg install           --triplet x86-windows @args }
${function:vcpkg-install-x86-r} = { vcpkg install --recurse --triplet x86-windows @args }
