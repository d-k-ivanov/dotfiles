<#
.SYNOPSIS
CPP scripts.

.DESCRIPTION
CPP scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command cppcheck -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:cppck} = { cppcheck -j8 --enable=all --force  @args }
    ${function:cppcki} = { cppck --inline-suppr @args }
    ${function:cppckif} = { cppcki --suppressions-list=cppcheck-suppressions.txt @args }

    ${function:cppckxml} = { cppck --xml --xml-version=2 @args 2>cppcheck.xml }
    ${function:cppckixml} = { cppcki --xml --xml-version=2 @args 2>cppcheck.xml }
    ${function:cppckifxml} = { cppckif --xml --xml-version=2 @args 2>cppcheck.xml }
    ${function:cppckifxmlg} = { cppckif --xml --xml-version=2 @args 2>cppcheck.xml; cppcheckgui cppcheck.xml}
}
