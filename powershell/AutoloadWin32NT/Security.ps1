<#
.SYNOPSIS
Security (SSH, SSL, GPG etc.) scripts.

.DESCRIPTION
Security (SSH, SSL, GPG etc.) scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command openssl -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:genpass}             = { openssl rand -base64 @args  }
    ${function:ssl_check_client}    = { openssl s_client -connect @args }
    ${function:decodecert}          = { openssl x509 -text -in @args }
}

if (Get-Command shasum -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:sha}  = { shasum -a 256 @args }
}

function DecryptFrom-Base64()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $string
    )
    if (Get-Command gpg -ErrorAction SilentlyContinue | Test-Path)
    {
        $bytes  = [System.Convert]::FromBase64String($string);
        $filename = [System.IO.Path]::GetTempFileName()
        # Write-Output $filename
        [IO.File]::WriteAllBytes($filename, $bytes)
        gpg -d $filename
        Remove-Item $filename
    }
    else
    {
        Write-Host "ERROR: gpg not found..." -ForegroundColor Red
        Write-Host "ERROR: GPG4Win should be installed and gpg added to the %PATH% env" -ForegroundColor Red
    }
}
${function:ggg}                 = { gpg --dry-run -vvvv --import @args }

${function:gpg_show_keys}       = { gpg --list-secret-keys --keyid-format LONG @args }
${function:gpg_show_key_info}   = { gpg --import-options show-only --import --fingerprint @args }

${function:gpg_search_sks}      = { gpg --keyserver pool.sks-keyservers.net --search-key  @args }
${function:gpg_search_ubuntu}   = { gpg --keyserver keyserver.ubuntu.com --search-key  @args }
${function:gpg_search_mit}      = { gpg --keyserver pgp.mit.edu --search-key  @args }

function gpg_file_e()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateScript({Test-Path $_})]
        [string] $File,
        [string] $Recipients = "d.k.ivanov@live.com"
    )

    if (Get-Command gpg -ErrorAction SilentlyContinue | Test-Path)
    {
        gpg -e --yes --trust-model always -r $Recipients $File
    }
    else
    {
        Write-Host "ERROR: gpg not found..." -ForegroundColor Red
        Write-Host "ERROR: GPG4Win should be installed and gpg added to the %PATH% env" -ForegroundColor Red
    }
}

function gpg_file_d()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateScript({Test-Path $_})]
        [string] $File
    )

    if (Get-Command gpg -ErrorAction SilentlyContinue | Test-Path)
    {
        $FileName = [io.path]::GetFileNameWithoutExtension("$File")
        gpg --output $FileName --decrypt $File
    }
    else
    {
        Write-Host "ERROR: gpg not found..." -ForegroundColor Red
        Write-Host "ERROR: GPG4Win should be installed and gpg added to the %PATH% env" -ForegroundColor Red
    }
}

function create_rsa_key
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$KeyName
    )
    ssh-keygen -t rsa -m pem -b 4096 -C "${KeyName}" -f "${KeyName}"
}

function convert_openssh_to_rsa
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path -Path $_})]
        [string] $Path,
        [SecureString] $OldPassword = "",
        [SecureString] $NewPassword = ""
    )
    $FullPath = Convert-Path $Path
    ssh-keygen -p -P "$OldPassword" -N "$NewPassword" -m pem -f "$FullPath"
}
