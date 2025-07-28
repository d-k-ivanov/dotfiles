<#
.SYNOPSIS
Convert scripts.

.DESCRIPTION
Convert scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function ResizePDF()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path -Path $_})]
        [string] $Path,
        [string] $Resolution = "72",
        [string] $OutputPath

    )

    if (-Not $OutputPath)
    {
        $OutputPath = "$((Get-Item $Path).BaseName)_${Resolution}dpi.pdf"
        Write-Host "`t Setting OutputPath to ${OutputPath}" -ForegroundColor Yellow
    }

    if (Get-Command gswin64.exe -ErrorAction SilentlyContinue | Test-Path)
    {
        $cmd  = "cmd /c '"
        $cmd  += "gswin64.exe"
        $cmd += " -q -dNOPAUSE -dBATCH -dSAFER"
        $cmd += " -sDEVICE=pdfwrite"
        $cmd += " -dCompatibilityLevel=1.3"
        $cmd += " -dPDFSETTINGS=/screen"
        $cmd += " -dEmbedAllFonts=true"
        $cmd += " -dSubsetFonts=true"
        $cmd += " -dAutoRotatePages=/None"
        $cmd += " -dColorImageDownsampleType=/Bicubic"
        $cmd += " -dColorImageResolution=$Resolution"
        $cmd += " -dGrayImageDownsampleType=/Bicubic"
        $cmd += " -dGrayImageResolution=$Resolution"
        $cmd += " -dMonoImageDownsampleType=/Subsample"
        $cmd += " -dMonoImageResolution=$Resolution"
        $cmd += " -sOutputFile=$OutputPath"
        $cmd += " $Path"
        $cmd += "'"

        Write-Host "`t GhostScript cmd: $cmd`n" -ForegroundColor Yellow
        Invoke-Expression "$cmd"
    }
    else
    {
        Write-Host "ERROR: gswin64 not found..." -ForegroundColor Red
        Write-Host "ERROR: GhostScript for Windows should be installed and gswin64.exe added to the %PATH% env" -ForegroundColor Red
    }
}

function convert_all_svg_to_png
{
    [CmdletBinding()]
    param
    (
        [ValidateScript({Test-Path $_})]
        [string] $Path = '.',
        [string] $DPI = '512'
    )

    $FullPath = Convert-Path $Path

    $inkscape_cmd = "C:\Program Files\Inkscape\bin\inkscape.exe"
    if (Get-Command ${inkscape_cmd} -ErrorAction SilentlyContinue | Test-Path)
    {
        Get-ChildItem -Path "${FullPath}" -File -Filter *.svg `
            | Foreach-Object {
                $in  = $_.FullName
                $out = Join-Path $FullPath "$([io.path]::GetFileNameWithoutExtension("$in")).png"
                Write-Output "Converting: $in  --> $out ($DPI dpi)"
                & ${inkscape_cmd} "${in}" --batch-process --export-type=png --export-dpi=${DPI} --export-filename="${out}"
            }
    }
}

function move_all_converted_svg_and_png
{
    [CmdletBinding()]
    param
    (
        [ValidateScript({Test-Path $_})]
        [string] $SourcePath = '.',
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_})]
        [string] $DesctinationPath
    )

    $FullPath = Convert-Path $SourcePath

    Get-ChildItem -Path "${FullPath}" -File -Filter *.svg `
        | Foreach-Object {
            $svg  = $_.FullName
            $png = Join-Path $FullPath "$([io.path]::GetFileNameWithoutExtension("$svg")).png"
            if (Test-Path $png)
            {
                Move-Item -Path $svg -Destination $DesctinationPath -Force
                Move-Item -Path $png -Destination $DesctinationPath -Force
            }
        }
}
