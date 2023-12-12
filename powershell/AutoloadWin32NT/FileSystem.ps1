<#
.SYNOPSIS
Filesystem scripts.

.DESCRIPTION
Filesystem scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

Remove-Item alias:cd -ErrorAction SilentlyContinue
${function:cd} = {
    if ($args -eq '-')
    {
        $tmpLocation = $env:OLDPWD
        $env:OLDPWD = Get-Location
        Set-Location $tmpLocation
    }
    else
    {
        $env:OLDPWD = Get-Location
        Set-Location @args
    }
    $env:PWD = Get-Location
}

# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...}     = { Set-Location ..\..             }
${function:....}    = { Set-Location ..\..\..          }
${function:.....}   = { Set-Location ..\..\..\..       }
${function:......}  = { Set-Location ..\..\..\..\..    }
${function:.......} = { Set-Location ..\..\..\..\..\.. }

# Navigation Shortcuts
${function:drop}    = { Set-Location ${env:MY_DROPBOX}                                  }
${function:desk}    = { Set-Location ~\Desktop                                          }
${function:docs}    = { Set-Location ~\Documents                                        }
${function:down}    = { Set-Location ~\Downloads                                        }
${function:ws}      = { Set-Location ${Env:WORKSPACE}                                   }
${function:wsm}     = { Set-Location ${Env:WORKSPACE}\my                                }
${function:wsdf}    = { Set-Location ${Env:WORKSPACE}\my\dotfiles                       }
${function:wsdfp}   = { Set-Location ${Env:WORKSPACE}\my\dotfiles-private               }
${function:wsdsc}   = { Set-Location ${Env:WORKSPACE}\my\workstations\windows           }
${function:wsconf}  = { Set-Location ${Env:WORKSPACE}\my\workstations\windows           }
${function:wsmisc}  = { Set-Location ${Env:WORKSPACE}\misc                              }
${function:wst}     = { Set-Location ${Env:WORKSPACE}\tmp                               }
${function:wsue}    = { Set-Location ${Env:WORKSPACE}\ue                                }
${function:wsv}     = { Set-Location ${Env:WORKSPACE}\vcpkg-gh                          }
${function:wsws}    = { Set-Location ${env:MY_ONEDRIVE}\Workspace                       }

# ClearCorrect Shortcuts
${function:wsc}     = { Set-Location ${Env:WORKSPACE}\clearcorrect                      }
${function:wscl}    = { Set-Location ${Env:WORKSPACE}\clearcorrect\clinical             }
${function:wscc}    = { Set-Location ${Env:WORKSPACE}\clearcorrect\clinical\cc-dev      }
${function:wscc1}   = { Set-Location ${Env:WORKSPACE}\clearcorrect\clinical\cc-dev1     }
${function:wscc2}   = { Set-Location ${Env:WORKSPACE}\clearcorrect\clinical\cc-dev2     }
${function:wscc3}   = { Set-Location ${Env:WORKSPACE}\clearcorrect\clinical\cc-dev3     }
${function:wscc4}   = { Set-Location ${Env:WORKSPACE}\clearcorrect\clinical\cc-dev4     }
${function:wsccv}   = { Set-Location ${Env:WORKSPACE}\vcpkg                             }
${function:wsce}    = { Set-Location ${Env:WORKSPACE}\clearcorrect\exporters            }

# IRQ Shortcuts
${function:wsi}     = { Set-Location ${Env:WORKSPACE}\irq                               }
${function:wsic}    = { Set-Location ${Env:WORKSPACE}\irq\common                        }
${function:wsid}    = { Set-Location ${Env:WORKSPACE}\irq\devops                        }
${function:wsim}    = { Set-Location ${Env:WORKSPACE}\irq\ml                            }
${function:wsimm}   = { Set-Location ${Env:WORKSPACE}\irq\ml\irqml                      }

# Create a new directory and enter it
function New-DirectoryAndSet ([String] $path) { New-Item $path -ItemType Directory -ErrorAction SilentlyContinue; Set-Location $path}
Set-Alias mkd New-DirectoryAndSet

function Get-DuList
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Precision',
        Justification = 'False positive as rule does not know that ForEach-Object operates within the same scope')]
    param
    (
        [ValidateNotNullOrEmpty()]
        [string]$Path = $(Get-Location),
        [ValidateNotNullOrEmpty()]
        [string]$Precision = 5
    )
    # $null = $Precision
    Get-ChildItem ${Path} -Force | ForEach-Object {
        "{0} {1:N${Precision}} MB" -f ($_.Name), ((Get-ChildItem $(Join-Path ${Path} ${_}) -Force -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
    }
}
Set-Alias dul Get-DuList

# Determine size of a file or total size of a directory
function Get-DiskUsage([string] $Path=(Get-Location).Path)
{
    Convert-ToDiskSize `
        ( `
            Get-ChildItem $Path -Force -Recurse -ErrorAction SilentlyContinue `
            | Measure-Object -Property length -sum -ErrorAction SilentlyContinue
        ).Sum `
        1
}

function Convert-ToDiskSize
{
    param
    (
        $bytes,
        $precision='0'
    )

    foreach ($size in ("B","K","M","G","T"))
    {
        if (($bytes -lt 1000) -or ($size -eq "T"))
        {
            $bytes = ($bytes).tostring("F0" + "$precision")
            return "${bytes}${size}"
        }
        else
        {
            $bytes /= 1KB
        }
    }
}
Set-Alias du Get-DiskUsage

# Directory Listing: Use `ls` if available
if (Get-Command busybox -ErrorAction SilentlyContinue | Test-Path)
{
    Remove-Item alias:ls -ErrorAction SilentlyContinue
    # Set `ls` to call `ls` and always use --color
    # ${function:ls} = { busybox ls --color --group-directories-first @args }
    ${function:ls}      = { busybox ls --group-directories-first @args }
    # List all files in long format
    ${function:l}       = { ls -CFhH  @args }
    # List all files in long format, including hidden files
    ${function:la}      = { ls -alhH  @args }
    ${function:ll}      = { ls -alFhH @args }
    ${function:fls}     = { ls -lH    @args | busybox grep -v ^d }
    ${function:flsa}    = { ls -laH   @args | busybox grep -v ^d }
    ${function:dirs}    = { ls -lH    @args | busybox grep ^d }
    ${function:dirsa}   = { ls -laH   @args | busybox grep ^d }
    # List only directories
    ${function:lsd}     = { Get-ChildItem -Directory -Force @args }
    # List directories recursively
    ${function:llr}     = { lsd | ForEach-Object{ll $_ @args} }
}
else
{
    # List all files, including hidden files
    ${function:la}      = { Get-ChildItem -Force @args }
    # List only directories
    ${function:lsd}     = { Get-ChildItem -Directory -Force @args }
    # List directories recursively
    ${function:llr}     = { lsd | ForEach-Object{la $_ @args} }
}

${function:lsf}         = { Get-ChildItem . | ForEach-Object{ $_.Name } }

function  llf()
{
    if ($Args[0])
    {
        $path = $Args[0]
    }
    else
    {
        $path = "."
    }

    if ($Args[1])
    {
        $pattern = ".*$($Args[1]).*"
    }
    else
    {
        $pattern = ''
    }

    Get-ChildItem "$path" | ForEach-Object {
        if ($_.Name -match "$pattern")
        {
            $_.FullName
        }
    }
}

function Remove-File-Recursively
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'FileName',
        Justification = 'False positive as rule does not know that ForEach-Object operates within the same scope')]
    param
    (
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [string]$PathToFolderTree,
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [string]$FileName
    )
    Get-ChildItem $PathToFolderTree | ForEach-Object {
        $targetFile = $(Join-Path $_.FullName $FileName)
        if (Test-Path $targetFile)
        {
            Remove-Item -Force $targetFile
            Write-Host $targetFile " removed"
        }
    }
}

#if (Get-Command rm -ErrorAction SilentlyContinue | Test-Path)
# {
#   ${function:rmf}  = { rm -f  @args }
#   ${function:rmrf} = { rm -rf @args }
# }
# else
# {
    ${function:rmf}  = { Remove-Item -Force @args }
    ${function:rmrf} = { Remove-Item -Recurse -Force @args }
# }

function touch($file) { $null | Out-File -Append $file -Encoding ASCII }

# Mounts
${function:mountW} = { subst W: ( Join-Path $Env:USERPROFILE "workspace" ) }

# Find files
function find
{
    param
    (
        [Parameter(Mandatory = $True)]
        [string]$Path,
        [Parameter(Mandatory = $True)]
        [string]$Expression
    )
    Get-ChildItem -Path $Path -Filter $Expression -Recurse -ErrorAction SilentlyContinue -Force | ForEach-Object { Write-Host $_.FullName -ForegroundColor Yellow}
}

# Copy files with directory structure.
# Input: Array of Strings
# Output: Folder with copied files
function Copy-FilesWithFolderStructure
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $True)]
        [String]$Destination,
        [Parameter(Mandatory = $True,ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
        [String[]]$Items
    )

    if (-Not (Test-Path $Destination))
    {
        New-Item -ItemType Directory -Path "$Destination" -Force
    }

    foreach ($item in $Items)
    {
        if (Test-Path $item)
        {
            $Dir = Split-Path -Path $item
            New-Item -Path "$(Join-Path $Destination $Dir)" -ItemType Directory -Force
            Copy-Item "$item" -Destination "$(Join-Path $Destination $Dir)" -Force
        }
    }
}

function join_files
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string] $Out,

        [Parameter(ValueFromPipeline=$true)]
        [ValidateScript({
            foreach ($file in $_)
            {
                Test-Path $file.FullName
            }
        })]
        [System.Object[]] $FilesToJoin = (Get-ChildItem -Path . -File)
    )
    $cmd = "cmd /c '$($FilesToJoin.FullName -join ' + ') ${Out}'"
    Write-Host $cmd

    # Usages:
    # join_files out.mp3
    # join_files out.mp3 (Get-ChildItem -Path ..\path\to\folder\ -File)
    # Get-ChildItem -Path ..\path\to\folder\ -File | join_files out.mp3
    # Get-ChildItem -Path ..\path\to\folder\ -File -Filter "*.mp3"  | join_files out.mp3
    #
    # CMD equivalent
    # copy /b 01.mp3 + 02.mp3 + 03.mp3 + 04.mp3 + 05.mp3 + 06.mp3 + 07.mp3 + 08.mp3 + 09.mp3 + 10.mp3 + 11.mp3 out.mp3
}

function mkl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $True)]
        [ValidateScript({Test-Path -Path $_})]
        [String] $Source,
        [Parameter(Mandatory = $True)]
        [String] $Destination
    )
    $cmd = "cmd /c 'mklink"
    if ((Get-Item $Source) -is [System.IO.DirectoryInfo])
    {
        $cmd += " /d"
    }
    $cmd += " $($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$Destination"))".trim('\')
    $cmd += " $(Convert-Path $Source)".trim('\')
    $cmd += "'"

    Write-Host "`t Creating link: ${cmd}" -ForegroundColor Yellow
    Invoke-Expression "${cmd}"
}
