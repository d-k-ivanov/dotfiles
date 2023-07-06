<#
.SYNOPSIS
Package scripts.

.DESCRIPTION
Package scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Remove-WAPP
{
    if ($args.Count -ne 1)
    {
        Write-Host "Usage: rm-wapp <package_mask>"
    }
    else
    {
        Get-AppxPackage *$($args[0].ToString())* | Remove-AppxPackage
    }
}

function Get-WAPP
{
    if ($args.Count -ne 1)
    {
        Write-Host "Usage: get-wapp <package_mask>"
    }
    else
    {
        Get-AppxPackage *$($args[0].ToString())*
    }
}

function Install-WAPP
{
    Get-AppxPackage *$($args[0].ToString())* | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
}

function Install-WAPP-All
{
    Get-AppxPackage -AllUsers| ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
}

function Download-AppxPackage
{
    [CmdletBinding()]
    param (
        [string]$Uri,
        [string]$Path = "."
    )

    process
    {
        $Path = (Resolve-Path $Path).Path
        #Get Urls to download
        $WebResponse = Invoke-WebRequest -UseBasicParsing -Method 'POST' -Uri 'https://store.rg-adguard.net/api/GetFiles' -Body "type=url&url=$Uri&ring=Retail" -ContentType 'application/x-www-form-urlencoded'
        $LinksMatch = $WebResponse.Links | Where-Object { $_ -like '*.appx*' } | Where-Object { $_ -like '*_neutral_*' -or $_ -like "*_" + $env:PROCESSOR_ARCHITECTURE.Replace("AMD", "X").Replace("IA", "X") + "_*" } | Select-String -Pattern '(?<=a href=").+(?=" r)'
        $DownloadLinks = $LinksMatch.matches.value

        function Resolve-NameConflict
        {
            #Accepts Path to a FILE and changes it so there are no name conflicts
            param(
                [string]$Path
            )
            $newPath = $Path
            if (Test-Path $Path)
            {
                $i = 0;
                $item = (Get-Item $Path)
                while (Test-Path $newPath)
                {
                    $i += 1;
                    $newPath = Join-Path $item.DirectoryName ($item.BaseName + "($i)" + $item.Extension)
                }
            }
            return $newPath
        }
        #Download Urls
        foreach ($url in $DownloadLinks)
        {
            $FileRequest = Invoke-WebRequest -Uri $url -UseBasicParsing #-Method Head
            $FileName = ($FileRequest.Headers["Content-Disposition"] | Select-String -Pattern  '(?<=filename=).+').matches.value
            $FilePath = Join-Path $Path $FileName; $FilePath = Resolve-NameConflict($FilePath)
            [System.IO.File]::WriteAllBytes($FilePath, $FileRequest.content)
            Write-Output $FilePath
        }
    }
}
