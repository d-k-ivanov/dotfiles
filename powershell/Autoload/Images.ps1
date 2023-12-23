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

${function:iresjpg160}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 160x120   $_ } } # (QQVGA)
${function:iresjpg320}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 320x240   $_ } } # (QVGA)
${function:iresjpg640}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 640x480   $_ } } # (VGA)
${function:iresjpg800}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 800x600   $_ } } # (SVGA)
${function:iresjpg1024} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1024x768  $_ } } # (XGA)
${function:iresjpg1152} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1152x864  $_ } } # (XGA+)
${function:iresjpg1280} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1280x960  $_ } } # (SXGA-)
${function:iresjpg1400} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1400x1050 $_ } } # (SXGA+)
${function:iresjpg1600} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1600x1200 $_ } } # (UXGA)
${function:iresjpg2048} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 2048x1536 $_ } } # (QXGA)
${function:iresjpg3200} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 3200x2400 $_ } } # (QUXGA)
${function:iresjpg4096} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 4096x3072 $_ } } # (HXGA)
${function:iresjpg6400} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 6400x4800 $_ } } # (HUXGA)

${function:iresjpg160x}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 160x160   $_ } }
${function:iresjpg320x}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 320x320   $_ } }
${function:iresjpg640x}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 640x640   $_ } }
${function:iresjpg800x}  = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 800x800   $_ } }
${function:iresjpg1024x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1024x1024 $_ } }
${function:iresjpg1152x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1152x1152 $_ } }
${function:iresjpg1280x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1280x1280 $_ } }
${function:iresjpg1400x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1400x1400 $_ } }
${function:iresjpg1600x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1600x1600 $_ } }
${function:iresjpg2048x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 2048x2048 $_ } }
${function:iresjpg3200x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 3200x3200 $_ } }
${function:iresjpg4096x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 4096x4096 $_ } }
${function:iresjpg6400x} = { Get-ChildItem -Path @args -Filter *.jpg -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 6400x6400 $_ } }

${function:irespng160}  = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 160x120   $_ } } # (QQVGA)
${function:irespng320}  = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 320x240   $_ } } # (QVGA)
${function:irespng640}  = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 640x480   $_ } } # (VGA)
${function:irespng800}  = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 800x600   $_ } } # (SVGA)
${function:irespng1024} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1024x768  $_ } } # (XGA)
${function:irespng1152} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1152x864  $_ } } # (XGA+)
${function:irespng1280} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1280x960  $_ } } # (SXGA-)
${function:irespng1400} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1400x1050 $_ } } # (SXGA+)
${function:irespng1600} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1600x1200 $_ } } # (UXGA)
${function:irespng2048} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 2048x1536 $_ } } # (QXGA)
${function:irespng3200} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 3200x2400 $_ } } # (QUXGA)
${function:irespng4096} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 4096x3072 $_ } } # (HXGA)
${function:irespng6400} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 6400x4800 $_ } } # (HUXGA)

${function:irespng160x}  = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 160x160   $_ } }
${function:irespng320x}  = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 320x320   $_ } }
${function:irespng640x}  = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 640x640   $_ } }
${function:irespng800x}  = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 800x800   $_ } }
${function:irespng1024x} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1024x1024 $_ } }
${function:irespng1152x} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1152x1152 $_ } }
${function:irespng1280x} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1280x1280 $_ } }
${function:irespng1400x} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1400x1400 $_ } }
${function:irespng1600x} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 1600x1600 $_ } }
${function:irespng2048x} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 2048x2048 $_ } }
${function:irespng3200x} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 3200x3200 $_ } }
${function:irespng4096x} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 4096x4096 $_ } }
${function:irespng6400x} = { Get-ChildItem -Path @args -Filter *.png -Recurse -ErrorAction SilentlyContinue -Force | % { magick.exe mogrify -define preserve-timestamp=true -resize 6400x6400 $_ } }

