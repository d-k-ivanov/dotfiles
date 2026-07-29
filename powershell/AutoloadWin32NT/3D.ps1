<#
.SYNOPSIS
3D-related scripts.

.DESCRIPTION
3D-related scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    exit
}

# Get-ChildItem . -File -Filter "*.drc" | %{ draco_decoder.exe -i "$($_.Name)" -o "$($_.BaseName).stl" }
function draco_to_stl
{
    [CmdletBinding()]
    param
    (
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string] $Path = '.'
    )

    $FullPath = Convert-Path $Path
    Set-Location $FullPath

    Get-ChildItem -Path $FullPath -File -Recurse -Filter *.drc | ForEach-Object {
        $out = Join-Path $_.DirectoryName "$($_.BaseName).stl"
        Write-Host "Converting: $($_.FullName) -> $out" -ForegroundColor Yellow
        & draco_decoder.exe -i $_.FullName -o $out
    }
}
Set-Alias -Name drc_to_stl -Value draco_to_stl

function stl_to_draco
{
    [CmdletBinding()]
    param
    (
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string] $Path = '.'
    )

    $FullPath = Convert-Path $Path
    Set-Location $FullPath

    Get-ChildItem -Path $FullPath -File -Recurse -Filter *.stl | ForEach-Object {
        $out = Join-Path $_.DirectoryName "$($_.BaseName).drc"
        Write-Host "Converting: $($_.FullName) -> $out" -ForegroundColor Yellow
        & draco_encoder.exe -i $_.FullName -o $out
    }
}
Set-Alias -Name stl_to_drc -Value stl_to_draco
