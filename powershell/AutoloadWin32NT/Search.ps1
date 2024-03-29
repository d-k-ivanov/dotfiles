<#
.SYNOPSIS
Search scripts.

.DESCRIPTION
Search scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

Set-Alias gre findstr

# Greps with status
if (Get-Command grep -ErrorAction SilentlyContinue | Test-Path)
{
    Set-Alias -Name gerp -Value grep
    Set-Alias -Name greo -Value grep
    ${function:gHS}  = { grep -e "status" -e "health" @args }
}
elseif (Get-Command busybox -ErrorAction SilentlyContinue | Test-Path)
{
    function grep
    {
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory=$true)]
            [string]$Pattern,
            [switch]$c,
            [switch]$E,
            [switch]$F,
            [switch]$hh,
            [switch]$H,
            [switch]$i,
            [switch]$ll,
            [switch]$L,
            [switch]$n,
            [switch]$o,
            [switch]$q,
            [switch]$r,
            [switch]$s,
            [switch]$v,
            [switch]$w,
            [switch]$x,
            [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
            $Data,
            [string]$Other = $null
        )
        Begin
        {
            [string] $SessionID = [System.Guid]::NewGuid()
            [string] $TempFile  = (Join-Path $env:Temp $SessionID'.grep')
            $File = $null
        }
        Process
        {
            # Check if value came from pipeline
            if ($PSCmdlet.MyInvocation.ExpectingInput)
            {
                Write-Output $Data >> "${TempFile}"
                if (-Not $File)
                {
                    $File = $TempFile
                }
            }
            else
            {
                $File = $Data
            }
            $Arguments = "-e $Pattern"
            if ($c)         {$Arguments += " -c"}
            if ($E)         {$Arguments += " -E"}
            if ($F)         {$Arguments += " -F"}
            if ($hh)        {$Arguments += " -h"}
            if ($H)         {$Arguments += " -H"}
            if ($i)         {$Arguments += " -i"}
            if ($ll)        {$Arguments += " -l"}
            if ($L)         {$Arguments += " -L"}
            if ($n)         {$Arguments += " -n"}
            if ($o)         {$Arguments += " -o"}
            if ($q)         {$Arguments += " -q"}
            if ($r)         {$Arguments += " -r"}
            if ($s)         {$Arguments += " -s"}
            if ($v)         {$Arguments += " -v"}
            if ($w)         {$Arguments += " -w"}
            if ($x)         {$Arguments += " -x"}
            if ($Other)     {$Arguments += " $Other"}
        }

        End
        {
            Invoke-Expression "busybox grep $Arguments $File"
            Remove-Item -Force -ErrorAction SilentlyContinue "${TempFile}"
        }
    }

    Set-Alias -Name gerp -Value grep
    Set-Alias -Name greo -Value grep
}
else
{
    Set-Alias -Name grep -Value Select-String
    Set-Alias -Name gerp -Value grep
    Set-Alias -Name greo -Value grep
}

# Tail
function tail
{
    if ($args.Count -ne 2)
    {
        Write-Host "Usage: tail <-N or -f> <path_to_file>"
    }
    else
    {
        switch ($args[0])
        {
            "-f" {Get-Content $args[1] -Wait}
            default {Get-Content $args[1] -Tail $($args[0] -replace '\D+(\d+)','$1')}
        }
    }
}

# Which and where
function which($name)
{
    Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition
}
Set-Alias Show-Command which
New-Alias which1 Get-Command -Force
${function:which2} = { Get-Command @args -All | Format-Table CommandType, Name, Definition }

${function:count-stl} = { Write-Host (Get-ChildItem -Path @args -Recurse -Filter '*.stl'| Measure-Object).Count }
${function:count-xml} = { Write-Host (Get-ChildItem -Path @args -Recurse -Filter '*.xml'| Measure-Object).Count }

function compare-dirs-and-list-missing {
    [CmdletBinding()]
    param
    (
        [ValidateNotNullOrEmpty()] [ValidateScript({Test-Path -Path $_})]
        [string] $Folder1,
        [ValidateNotNullOrEmpty()] [ValidateScript({Test-Path -Path $_})]
        [string] $Folder2,
        [string] $FileType = "stl"
    );
    $Folder1 = (Convert-Path -LiteralPath $Folder1.TrimEnd('\'))
    $Folder2 = (Convert-Path -LiteralPath $Folder2.TrimEnd('\'))
    $Depth = $Folder1.Split('\').Count

    Write-Host "Comparing ${Folder1} and ${Folder2} with depth ${Depth}" -ForegroundColor Yellow

    $Files = @();
    Get-ChildItem ${Folder1} -Recurse -Filter "*.${FileType}" | ForEach-Object { $Files += $(($_.FullName -split '[\\/]' | Select -Skip $Depth) -join "\") };

    [uint32] $counterEqual = 0;
    [uint32] $counterMissing = 0;

    foreach ($File in $Files)
    {
        If(Test-Path "${Folder2}\$File")
        {
            $counterEqual++;
            continue;
        }
        $counterMissing++;
        Write-Output $File;
    }

    Write-Host -ForegroundColor Yellow "Number of missing ${FileType} files: ${counterMissing}";
    Write-Host -ForegroundColor Yellow "Number of equal ${FileType} files: ${counterEqual}";
}
