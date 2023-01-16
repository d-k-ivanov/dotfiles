#requires -version 3
# Set-ExecutionPolicy RemoteSigned -scope CurrentUser

$dotfilesProfileDir = Join-Path $PSScriptRoot       "powershell"
$dotfilesModulesDir = Join-Path $dotfilesProfileDir "Modules"
$dotfilesScriptsDir = Join-Path $dotfilesProfileDir "Scripts"

"DEVELOPMENT" | Out-File ( Join-Path $PSScriptRoot "bash/var.env"    )
"COMPLEX"     | Out-File ( Join-Path $PSScriptRoot "bash/var.prompt" )

# Cleanup profile
If (Test-Path "${Env:USERPROFILE}\.bash"                 ) { [System.IO.Directory]::Delete("${Env:USERPROFILE}\.bash"                 , $true) }
If (Test-Path "${Env:USERPROFILE}\.bin"                  ) { [System.IO.Directory]::Delete("${Env:USERPROFILE}\.bin"                  , $true) }
If (Test-Path "${Env:USERPROFILE}\.conan_my"             ) { [System.IO.Directory]::Delete("${Env:USERPROFILE}\.conan_my"             , $true) }
If (Test-Path "${Env:USERPROFILE}\.git.d"                ) { [System.IO.Directory]::Delete("${Env:USERPROFILE}\.git.d"                , $true) }
If (Test-Path "${Env:USERPROFILE}\.tmux"                 ) { [System.IO.Directory]::Delete("${Env:USERPROFILE}\.tmux"                 , $true) }
If (Test-Path "${Env:USERPROFILE}\.vim"                  ) { [System.IO.Directory]::Delete("${Env:USERPROFILE}\.vim"                  , $true) }
If (Test-Path "${Env:LOCALAPPDATA}\nvim"                 ) { [System.IO.Directory]::Delete("${Env:LOCALAPPDATA}\nvim"                 , $true) }
If (Test-Path "${Env:APPDATA}\NuGet"                     ) { [System.IO.Directory]::Delete("${Env:APPDATA}\NuGet"                     , $true) }
If (Test-Path "${Env:APPDATA}\Sublime Text\Packages\User") { [System.IO.Directory]::Delete("${Env:APPDATA}\Sublime Text\Packages\User", $true) }
If (Test-Path "${Env:USERPROFILE}\.bash_profile"         ) { Remove-Item -Force -Recurse   "${Env:USERPROFILE}\.bash_profile"  -Confirm:$false }
If (Test-Path "${Env:USERPROFILE}\.bashrc"               ) { Remove-Item -Force -Recurse   "${Env:USERPROFILE}\.bashrc"        -Confirm:$false }
If (Test-Path "${Env:USERPROFILE}\.gemrc"                ) { Remove-Item -Force -Recurse   "${Env:USERPROFILE}\.gemrc"         -Confirm:$false }
If (Test-Path "${Env:USERPROFILE}\.gitconfig"            ) { Remove-Item -Force -Recurse   "${Env:USERPROFILE}\.gitconfig"     -Confirm:$false }
If (Test-Path "${Env:USERPROFILE}\.gitmessage"           ) { Remove-Item -Force -Recurse   "${Env:USERPROFILE}\.gitmessage"    -Confirm:$false }
If (Test-Path "${Env:USERPROFILE}\.profile"              ) { Remove-Item -Force -Recurse   "${Env:USERPROFILE}\.profile"       -Confirm:$false }
If (Test-Path "${Env:USERPROFILE}\.tmux.conf"            ) { Remove-Item -Force -Recurse   "${Env:USERPROFILE}\.tmux.conf"     -Confirm:$false }
If (Test-Path "${Env:USERPROFILE}\.vimrc"                ) { Remove-Item -Force -Recurse   "${Env:USERPROFILE}\.vimrc"         -Confirm:$false }
If (Test-Path "${Env:USERPROFILE}\.wslconfig"            ) { Remove-Item -Force -Recurse   "${Env:USERPROFILE}\.wslconfig"     -Confirm:$false }


# Making Symlinks
C:\Windows\System32\cmd /c mklink /d "${Env:USERPROFILE}\.bash"                  "${PSScriptRoot}\bash"
C:\Windows\System32\cmd /c mklink /d "${Env:USERPROFILE}\.bin"                   "${PSScriptRoot}\bin"
C:\Windows\System32\cmd /c mklink /d "${Env:USERPROFILE}\.conan_my"              "${PSScriptRoot}\conan"
C:\Windows\System32\cmd /c mklink /d "${Env:USERPROFILE}\.git.d"                 "${PSScriptRoot}\git.d"
C:\Windows\System32\cmd /c mklink /d "${Env:USERPROFILE}\.tmux"                  "${PSScriptRoot}\tmux"
C:\Windows\System32\cmd /c mklink /d "${Env:LOCALAPPDATA}\nvim"                  "${PSScriptRoot}\nvim"
C:\Windows\System32\cmd /c mklink /d "${Env:APPDATA}\NuGet"                      "${PSScriptRoot}\NuGet"
C:\Windows\System32\cmd /c mklink /d "${Env:APPDATA}\Sublime Text\Packages\User" "${PSScriptRoot}\sublime"
C:\Windows\System32\cmd /c mklink /d "${Env:USERPROFILE}\.vim"                   "${PSScriptRoot}\vim"
C:\Windows\System32\cmd /c mklink    "${Env:USERPROFILE}\.bash_profile"          "${PSScriptRoot}\bash_profile"
C:\Windows\System32\cmd /c mklink    "${Env:USERPROFILE}\.profile"               "${PSScriptRoot}\bash_profile"
C:\Windows\System32\cmd /c mklink    "${Env:USERPROFILE}\.bashrc"                "${PSScriptRoot}\bashrc"
C:\Windows\System32\cmd /c mklink    "${Env:USERPROFILE}\.gemrc"                 "${PSScriptRoot}\gemrc"
C:\Windows\System32\cmd /c mklink    "${Env:USERPROFILE}\.gitconfig"             "${PSScriptRoot}\.gitconfig-win"
C:\Windows\System32\cmd /c mklink    "${Env:USERPROFILE}\.gitmessage"            "${PSScriptRoot}\.gitmessage"
C:\Windows\System32\cmd /c mklink    "${Env:USERPROFILE}\.tmux.conf"             "${PSScriptRoot}\tmux.conf"
C:\Windows\System32\cmd /c mklink    "${Env:USERPROFILE}\.vimrc"                 "${PSScriptRoot}\vimrc"
C:\Windows\System32\cmd /c mklink    "${Env:USERPROFILE}\.wslconfig"             "${PSScriptRoot}\wslconfig"

# Set dot source string to default PS profile for Current User
if (Test-Path $profile) { Remove-Item -Force -Confirm:$false $profile }
". `"$PSScriptRoot\powershell\profile_loader.ps1`"" | Out-File $profile

# Install Nuget package provide if needed
if (-Not (Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue))
{
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}

# Make PSGallery Trusted if needed
if (-Not (Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue).InstallationPolicy -eq 'Trusted')
{
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

# $NormalizationPath = Join-Path $dotfilesProfileDir "normalization-done"
# if (![System.IO.File]::Exists($NormalizationPath)) {
#     . (Join-Path $dotfilesScriptsDir "Normalilze-Manually-Installed-Modules.ps1") -force
#     Normalilze-Manually-Installed-Modules
#     New-Item (Join-Path $dotfilesProfileDir "normalization-done") -ItemType file
# }

#if (Get-Command chef -ErrorAction SilentlyContinue | Test-Path) {
#  chef gem install knife-block
#}

Import-Module -FullyQualifiedName (Join-Path $dotfilesModulesDir "ApplicationCompatibility")

# ConEmu
if (Test-Path "C:\Program Files\ConEmu\ConEmu64.exe")
{
    Set-ApplicationCompatibility -CurrentUser -ApplicationLocation "C:\Program Files\ConEmu\ConEmu64.exe" -PrivilegeLevel
}
Remove-Item -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue (Join-Path ${Env:APPDATA} "ConEmu.xml")
cmd /c mklink (Join-Path ${Env:APPDATA} "ConEmu.xml") (Join-Path $PSScriptRoot "data\conemu\ConEmu.xml")

$workspace_path = 'c:\ws'
New-Item $workspace_path -ItemType Directory -ErrorAction SilentlyContinue
[Environment]::SetEnvironmentVariable("WORKSPACE", $workspace_path, "Machine")
