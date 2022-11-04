
# $PSScriptRoot                               # C:\Users\${Env:HOME}\.bin
# $PSCommandPath                              # C:\Users\${Env:HOME}\.bin\serv.ps1
# (Get-Item $PSCommandPath).Extension        # .ps1
# (Get-Item $PSCommandPath).Basename         # serv
# (Get-Item $PSCommandPath).Name             # serv.ps1
# (Get-Item $PSCommandPath).DirectoryName    # C:\Users\${Env:HOME}\.bin
# (Get-Item $PSCommandPath).FullName         # C:\Users\${Env:HOME}\.bin\serv.ps1

$Script = $PSScriptRoot + "\" + (Get-Item $PSCommandPath).BaseName + ".py"
python $Script
