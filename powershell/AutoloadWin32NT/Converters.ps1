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
    exit
}

function ResizePDF()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ })]
        [string] $Path,
        [string] $Resolution = "72",
        [string] $OutputPath

    )

    if (-not $OutputPath)
    {
        $OutputPath = "$((Get-Item $Path).BaseName)_${Resolution}dpi.pdf"
        Write-Host "`t Setting OutputPath to ${OutputPath}" -ForegroundColor Yellow
    }

    if (Get-Command gswin64.exe -ErrorAction SilentlyContinue | Test-Path)
    {
        $cmd = "cmd /c '"
        $cmd += "gswin64.exe"
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
        [ValidateScript({ Test-Path $_ })]
        [string] $Path = '.',
        [string] $DPI = '512'
    )

    $FullPath = Convert-Path $Path

    $inkscape_cmd = "C:\Program Files\Inkscape\bin\inkscape.exe"
    if (Get-Command ${inkscape_cmd} -ErrorAction SilentlyContinue | Test-Path)
    {
        Get-ChildItem -Path "${FullPath}" -File -Filter *.svg `
        | ForEach-Object {
            $in = $_.FullName
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
        [ValidateScript({ Test-Path $_ })]
        [string] $SourcePath = '.',
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ })]
        [string] $DesctinationPath
    )

    $FullPath = Convert-Path $SourcePath

    Get-ChildItem -Path "${FullPath}" -File -Filter *.svg `
    | ForEach-Object {
        $svg = $_.FullName
        $png = Join-Path $FullPath "$([io.path]::GetFileNameWithoutExtension("$svg")).png"
        if (Test-Path $png)
        {
            Move-Item -Path $svg -Destination $DesctinationPath -Force
            Move-Item -Path $png -Destination $DesctinationPath -Force
        }
    }
}

function convert_gif_to_mp4
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string] $Path,
        [string] $OutputPath,
        [int] $Fps = 30
    )

    $FullPath = Convert-Path $Path

    if (-not $OutputPath)
    {
        $OutputPath = Join-Path (Split-Path -Path $FullPath -Parent) "$([io.path]::GetFileNameWithoutExtension($FullPath)).mp4"
        Write-Host "`t Setting OutputPath to ${OutputPath}" -ForegroundColor Yellow
    }

    $ffmpeg = Get-Command ffmpeg.exe -ErrorAction SilentlyContinue
    if (-not $ffmpeg)
    {
        Write-Host "ERROR: ffmpeg not found..." -ForegroundColor Red
        Write-Host "ERROR: ffmpeg should be installed and ffmpeg.exe added to the %PATH% env" -ForegroundColor Red
        return
    }

    $ffmpegArgs = @(
        '-y'
        '-hide_banner'
        '-loglevel', 'error'
        '-i', $FullPath
        '-movflags', '+faststart'
        '-pix_fmt', 'yuv420p'
        '-vf', "fps=$Fps,scale=trunc(iw/2)*2:trunc(ih/2)*2:flags=lanczos"
        '-c:v', 'libx264'
        '-crf', '23'
        '-preset', 'medium'
        '-an'
        $OutputPath
    )

    Write-Host "`t ffmpeg cmd: $($ffmpeg.Source) $($ffmpegArgs -join ' ')`n" -ForegroundColor Yellow
    & $ffmpeg.Source @ffmpegArgs

    if (($LASTEXITCODE -eq 0) -and (Test-Path $OutputPath))
    {
        Write-Host "Converted: ${FullPath} -> ${OutputPath}" -ForegroundColor Green
    }
    else
    {
        Write-Host "ERROR: Conversion failed for ${FullPath}" -ForegroundColor Red
    }
}

function convert_gif_to_mp4_recursive
{
    [CmdletBinding()]
    param
    (
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string] $Path = '.',
        [int] $Fps = 30
    )

    $FullPath = Convert-Path $Path
    Get-ChildItem -Path $FullPath -File -Recurse -Filter *.gif | ForEach-Object {
        $out = Join-Path $_.DirectoryName "$($_.BaseName).mp4"
        convert_gif_to_mp4 -Path $_.FullName -OutputPath $out -Fps $Fps
    }
}
