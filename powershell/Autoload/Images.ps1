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

${function:irezise160}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 160x120   $_ } } # (QQVGA)
${function:irezise320}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 320x240   $_ } } # (QVGA)
${function:irezise640}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 640x480   $_ } } # (VGA)
${function:irezise800}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 800x600   $_ } } # (SVGA)
${function:irezise1024} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1024x768  $_ } } # (XGA)
${function:irezise1152} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1152x864  $_ } } # (XGA+)
${function:irezise1280} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1280x960  $_ } } # (SXGA-)
${function:irezise1400} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1400x1050 $_ } } # (SXGA+)
${function:irezise1600} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1600x1200 $_ } } # (UXGA)
${function:irezise2048} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 2048x1536 $_ } } # (QXGA)
${function:irezise3200} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 3200x2400 $_ } } # (QUXGA)
${function:irezise4096} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 4096x3072 $_ } } # (HXGA)
${function:irezise6400} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 6400x4800 $_ } } # (HUXGA)

${function:irezise160x}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 160x160   $_ } }
${function:irezise320x}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 320x320   $_ } }
${function:irezise640x}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 640x640   $_ } }
${function:irezise800x}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 800x800   $_ } }
${function:irezise1024x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1024x1024 $_ } }
${function:irezise1152x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1152x1152 $_ } }
${function:irezise1280x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1280x1280 $_ } }
${function:irezise1400x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1400x1400 $_ } }
${function:irezise1600x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1600x1600 $_ } }
${function:irezise2048x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 2048x2048 $_ } }
${function:irezise3200x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 3200x3200 $_ } }
${function:irezise4096x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 4096x4096 $_ } }
${function:irezise6400x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 6400x6400 $_ } }
