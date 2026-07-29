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
function draco_decode
{
    [CmdletBinding()]
    param
    (
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string] $Path = '.',
        [string] $Format = 'stl'
    )

    $FullPath = Convert-Path $Path
    Set-Location $FullPath

    Get-ChildItem -Path $FullPath -File -Recurse -Filter *.drc | ForEach-Object {
        $out = Join-Path $_.DirectoryName "$($_.BaseName).$Format"
        Write-Host "Converting: $($_.FullName) -> $out" -ForegroundColor Yellow
        & draco_decoder.exe -i $_.FullName -o $out
    }
}

function draco_encode
{
    [CmdletBinding()]
    param
    (
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string] $Path = '.',
        [string] $Format = 'stl'
    )

    $FullPath = Convert-Path $Path
    Set-Location $FullPath

    Get-ChildItem -Path $FullPath -File -Recurse -Filter *.$Format | ForEach-Object {
        $out = Join-Path $_.DirectoryName "$($_.BaseName).drc"
        Write-Host "Converting: $($_.FullName) -> $out" -ForegroundColor Yellow
        & draco_encoder.exe -i $_.FullName -o $out
    }
}

${function:drc_to_stl} = { draco_decode }
${function:drc_to_ply} = { draco_decode -Format 'ply' }
${function:drc_to_obj} = { draco_decode -Format 'obj' }

${function:draco_to_stl} = { draco_decode }
${function:draco_to_ply} = { draco_decode -Format 'ply' }
${function:draco_to_obj} = { draco_decode -Format 'obj' }

${function:stl_to_drc} = { draco_encode }
${function:ply_to_drc} = { draco_encode -Format 'ply' }
${function:obj_to_drc} = { draco_encode -Format 'obj' }

${function:stl_to_draco} = { draco_encode }
${function:ply_to_draco} = { draco_encode -Format 'ply' }
${function:obj_to_draco} = { draco_encode -Format 'obj' }
