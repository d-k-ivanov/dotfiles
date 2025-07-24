<#
.SYNOPSIS
QT scripts.

.DESCRIPTION
QT scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Find-QT
{
    if (Test-Path "C:\Qt")
    {
        $QTVersions = $(((Get-ChildItem "C:\Qt").Name) -match '\d+.\d+.\d+')
    }

    Write-Host "List of QT Toolset on this PC:"
    if ($QTVersions)
    {
        foreach ($v in $QTVersions)
        {
            $CurrentQT = "C:\Qt\" + $v
            (Get-ChildItem $CurrentQT).Name | ForEach-Object {
                if ($_ -match "Src" -Or $_ -match "sha1s.txt")
                {
                    continue
                }
                Write-Host " -"$v" -> "$_
            }
        }
    }
}

function Set-QT
{
    if (Test-Path "C:\Qt")
    {
        $QTVersions = $(((Get-ChildItem "C:\Qt").Name) -match '\d+.\d+.\d+')
    }
    else
    {
        Write-Host "ERROR: QT doesn't installed to path 'C:\Qt'..." -ForegroundColor Red
        break
    }

    $ChoosenQTVersion = Select-From-List $QTVersions "QT Version"

    $CurrentQTPath = "C:\Qt\" + $ChoosenQTVersion
    $QTToolsets = @()
    (Get-ChildItem $CurrentQTPath).Name | ForEach-Object {
        if ($_ -Match "^Src$" -Or $_ -Match "^sha1s.txt$")
        {
            return
        }
        $QTToolsets += $_
    }

    $ChoosenQTToolset = Select-From-List $QTToolsets "QT Toolset"

    [Environment]::SetEnvironmentVariable("QTDIR", "$CurrentQTPath\$ChoosenQTToolset", "Machine")
    [Environment]::SetEnvironmentVariable("QMAKESPEC", "$CurrentQTPath\$ChoosenQTToolset\mkspecs\win32-msvc", "Machine")
    # Set-Env
}

function Use-QT
{
    [CmdletBinding()]
    param
    (
        [ValidateNotNullOrEmpty()]
        [string]$Arch   = "x64"
    )

    if (Test-Path "C:\Qt")
    {
        $QTVersions = $(((Get-ChildItem "C:\Qt").Name) -match '\d+.\d+.\d+')
    }
    else
    {
        Write-Host "ERROR: QT doesn't installed to path 'C:\Qt'..." -ForegroundColor Red
        break
    }

    $ChoosenQTVersion = Select-From-List $QTVersions "QT Version"

    $CurrentQTPath = "C:\Qt\" + $ChoosenQTVersion
    $QTToolsets = @()
    (Get-ChildItem $CurrentQTPath).Name | ForEach-Object {
        if ($_ -Match "^Src$" -Or $_ -Match "^sha1s.txt$")
        {
            return
        }
        $QTToolsets += $_
    }

    $ChoosenQTToolset = Select-From-List $QTToolsets "QT Toolset"
    Write-Host $ChoosenQTVersion
    Write-Host $ChoosenQTToolset

    if ($env:QTDIR)
    {
        Remove-Item Env:QTDIR
    }

    if ($env:QMAKESPEC)
    {
        Remove-Item Env:QMAKESPEC
    }

    if ($env:QMAKE_TARGET.arch)
    {
        Remove-Item Env:QMAKE_TARGET.arch
    }

    Set-Item -Path Env:QTDIR -Value "C:\Qt\${ChoosenQTVersion}\${ChoosenQTToolset}"
    Set-Item -Path Env:QMAKESPEC -Value "C:\Qt\${ChoosenQTVersion}\${ChoosenQTToolset}\mkspecs\win32-msvc"

    if ($Arch -eq "x86")
    {
        Set-Item -Path Env:QMAKE_TARGET.arch -Value "x86"
    }
    else
    {
        Set-Item -Path Env:QMAKE_TARGET.arch -Value "x64"
    }

    Set-Item -Path Env:PATH -Value "${Env:QTDIR}\bin;${Env:PATH}"
}

function Clear-QT
{
    [Environment]::SetEnvironmentVariable("QTDIR", [NullString]::Value, "Machine")
    [Environment]::SetEnvironmentVariable("QMAKESPEC", [NullString]::Value, "Machine")

    if ($env:QTDIR)
    {
        Remove-Item Env:QTDIR
    }

    if ($env:QMAKESPEC)
    {
        Remove-Item Env:QMAKESPEC
    }
    # Set-Env
}

function ConvertFrom-QTProject
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path -Path $_})]
        [string] $Path
    )

    Use-QT
    dev
    qmake -tp vc $Path
}

function ConvertTo-QTProject
{
    [CmdletBinding()]
    param
    (
        [string] $QTProject = ''
    )

    Use-QT
    dev
    qmake -project -o $QTProject
}
