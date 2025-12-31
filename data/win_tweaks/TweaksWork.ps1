$ScriptName         = [io.path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "${PSScriptRoot}\Tweaks\Tweaks.ps1" -include "${PSScriptRoot}\Tweaks\Tweaks.psm1" -preset "${PSScriptRoot}\${ScriptName}.preset"
Set-Service "CDPUserSvc" -StartupType Automatic
