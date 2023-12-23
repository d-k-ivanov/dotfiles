<#
.SYNOPSIS
TeX, LaTeX, TeXLive, MkLatex, etc. scripts.

.DESCRIPTION
TeX, LaTeX, TeXLive, MkLatex, etc. scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

${function:irezise160}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 160x120   $_ } } # (QQVGA)
${function:irezise320}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 320x240   $_ } } # (QVGA)
${function:irezise640}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 640x480   $_ } } # (VGA)
${function:irezise800}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 800x600   $_ } } # (SVGA)
${function:irezise1024} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 1024x768  $_ } } # (XGA)
${function:irezise1152} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 1152x864  $_ } } # (XGA+)
${function:irezise1280} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 1280x960  $_ } } # (SXGA-)
${function:irezise1400} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 1400x1050 $_ } } # (SXGA+)
${function:irezise1600} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 1600x1200 $_ } } # (UXGA)
${function:irezise2048} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 2048x1536 $_ } } # (QXGA)
${function:irezise3200} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 3200x2400 $_ } } # (QUXGA)
${function:irezise4096} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 4096x3072 $_ } } # (HXGA)
${function:irezise6400} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -resize 6400x4800 $_ } } # (HUXGA)
