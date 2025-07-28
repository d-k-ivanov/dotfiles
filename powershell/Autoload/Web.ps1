<#
.SYNOPSIS
Web scripts.

.DESCRIPTION
Web scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command curl -ErrorAction SilentlyContinue | Test-Path)
{
    # Gzip-enabled `curl`
    ${function:gurl}    = { curl --compressed @args }

}
else
{
    # Gzip-enabled `curl`
    ${function:gurl} = { Invoke-WebRequest -TransferEncoding GZip @args }
}

# Weather
${function:wet}     = { curl http://wttr.in/$args }
${function:wet2}    = { curl http://v2.wttr.in/$args }
${function:wetM}    = { wet Malaga }
${function:wetM2}   = { wet2 Malaga }

# Download a file into a temporary folder
function curlex($url)
{
    $uri = new-object system.uri $url
    $filename = $uri.segments | Select-Object -Last 1
    $path = join-path $env:Temp $filename
    if ( test-path $path ) { Remove-Item -Force $path }
    (new-object net.webclient).DownloadFile($url, $path)
    return new-object io.fileinfo $path
}
