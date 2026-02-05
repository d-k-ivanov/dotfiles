<#
.SYNOPSIS
Environment scripts.

.DESCRIPTION
Environment scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# Make vim the default editor\
# Set-Alias vim nvim
# Set-Alias gvim nvim-qt
$Env:VISUAL = "vim"
# $Env:VISUAL = "gvim"
$Env:EDITOR = "${Env:VISUAL}"
$Env:GIT_EDITOR = $Env:EDITOR

# Language
$Env:LANG = "en_US"
# $Env:LC_ALL = "C.UTF-8"
$Env:LC_ALL = "C"

# Init of directory envs:
$Env:PWD = Get-Location
$Env:OLDPWD = Get-Location

# Virtual Env Fix (if prompt in ReadOnly mode)
# $Env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# PS Readline:
$PSReadLineOptions = @{
    # EditMode = "Vi"
    EditMode                      = "Emacs"

    # Defaiult word delimiters
    WordDelimiters                = ';:,.[]{}()/\|^&*-=+`"–—―'
    # Bash 4.0 word delimiters
    # WordDelimiters = '()<>;&|"'

    MaximumHistoryCount           = 32767
    HistorySearchCursorMovesToEnd = $true
    ShowToolTips                  = $false
}
Set-PSReadLineOption @PSReadLineOptions

If ($PSVersionTable.PSVersion.Major -ge '7' -And $PSVersionTable.PSVersion.Minor -ge '2')
{
    Set-PSReadLineOption -PredictionSource None
    # Set-PSReadLineOption -PredictionViewStyle = "ListView"
}

Set-PSReadLineOption -HistoryNoDuplicates:$true

### KEYS:
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
Set-PSReadlineKeyHandler -Key Ctrl+e -Function DeleteWord
Set-PSReadlineKeyHandler -Key Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Tab -Function Complete

#  1..50000 | % {Set-Variable -Name MaximumHistoryCount -Value $_ }
Set-Variable -Name MaximumHistoryCount -Value 32767

${function:env} = { Get-ChildItem Env: }
${function:List-Env} = { Get-ChildItem Env: }
${function:List-Paths} = { $Env:Path.Split(';') }

# C:\Program Files\                             --> C:\PROGRA~1\
# C:\Program Files\Common Files                 --> C:\PROGRA~1\
# C:\Program Files\NVIDIA Corporation           --> C:\PROGRA~1\NVIDIA~1
# C:\Program Files\NVIDIA GPU Computing Toolkit --> C:\PROGRA~1\NVIDIA~2
# C:\Program Files (x86)\                       --> C:\PROGRA~2\
# C:\Program Files (x86)\NVIDIA Corporation     --> C:\PROGRA~2\NVIDIA~1
# C:\ProgramData\                               --> C:\PROGRA~3\
function Initialize-Paths-User
{
    $paths = @(
        "${Env:USERPROFILE}\OneDrive\bin"
        "${Env:USERPROFILE}\OneDrive\bin\work"
        "${Env:USERPROFILE}\OneDrive - ${Env:WORK_ONEDRIVE_SUFFIX}\bin"
        "${Env:USERPROFILE}\OneDrive - ${Env:WORK_ONEDRIVE_SUFFIX}\bin\work"
        "${Env:USERPROFILE}\scoop\shims"
        "${Env:GOPATH}\bin"
        "${Env:USERPROFILE}\.elan\bin"
        "${Env:USERPROFILE}\.cargo\bin"
        "${Env:USERPROFILE}\.dotnet\tools"
        "${Env:USERPROFILE}\.krew\bin"
        "${Env:USERPROFILE}\AppData\Local\Android\Sdk\platform-tools"
        "${Env:USERPROFILE}\AppData\Local\Coursier\data\bin"
        "${Env:USERPROFILE}\AppData\Local\JetBrains\Toolbox\scripts"
        "${Env:USERPROFILE}\AppData\Local\Pandoc"
        "${Env:USERPROFILE}\AppData\Local\Programs\Fiddler"
        "${Env:USERPROFILE}\AppData\Local\Programs\Microsoft VS Code Insiders\bin"
        "${Env:USERPROFILE}\AppData\Local\Programs\Ollama"
        "${Env:USERPROFILE}\AppData\Local\Pub\Cache\bin"
        "${Env:USERPROFILE}\AppData\Local\Yarn\bin"
        "${Env:USERPROFILE}\AppData\Roaming\cabal\bin"
        "${Env:USERPROFILE}\AppData\Roaming\local\bin"
        "${Env:USERPROFILE}\AppData\Roaming\npm"
        "${Env:USERPROFILE}\AppData\Roaming\Pub\Cache\bin"
        "${Env:USERPROFILE}\go\bin"
        "${Env:NVM_HOME}"
        "${Env:NVM_SYMLINK}"
        "C:\usr\bin"
        "C:\boost\dist\bin"
        "C:\Coq\bin"
        "C:\Go\bin"
        "C:\HashiCorp\Vagrant\bin"
        "C:\msys64"
        "C:\opscode\chefdk\bin"
        "C:\PROGRA~1\Azure Data Studio\bin"
        "C:\PROGRA~1\Conan\conan"
        "C:\PROGRA~1\ConEmu\ConEmu"
        "C:\PROGRA~1\ConEmu\ConEmu\wsl"
        "C:\PROGRA~1\GitHub CLI"
        "C:\PROGRA~1\gnuplot\bin"
        "C:\PROGRA~1\Gource\cmd"
        "C:\PROGRA~1\ImageMagick-7.1.2-Q16-HDRI"
        "C:\PROGRA~1\KDiff3\bin"
        "C:\PROGRA~1\Pandoc"
        "C:\PROGRA~1\SmartGit\bin"
        "C:\PROGRA~1\SmartSynchronize\bin"
        "C:\PROGRA~1\Sublime Text"
        "C:\PROGRA~1\Vagrant\bin"
        "C:\PROGRA~1\WinMerge"
        "C:\PROGRA~2\Android\android-sdk\platform-tools"
        "C:\PROGRA~2\GitExtensions"
        "C:\PROGRA~2\Nmap"
        "C:\PROGRA~2\pgAdmin 4\v4\runtime"
        "C:\ProgramData\chocolatey\lib\maven\apache-maven-3.9.9\bin"
        "C:\ProgramData\chocolatey\lib\maven\apache-maven-3.9.8\bin"
        "C:\ProgramData\chocolatey\lib\maven\apache-maven-3.9.7\bin"
        "C:\ProgramData\chocolatey\lib\maven\apache-maven-3.9.6\bin"
        "C:\ProgramData\chocolatey\lib\pulumi\tools\Pulumi\bin"
        "C:\ProgramData\chocolatey\lib\wmiexplorer\tools"
        "C:\Qt\Tools\QtCreator\bin"
        # "C:\Strawberry\c\bin"
        "C:\Strawberry\perl\bin"
        # "C:\Strawberry\perl\site\bin"
        "C:\tools\acli"
        # "C:\tools\Atlassian\atlassian-plugin-sdk-8.2.7\bin"
        "C:\tools\BCURRAN3"
        "C:\tools\bin"
        "C:\tools\binaryen\bin"
        "C:\tools\blackduck"
        "C:\tools\cobertura"
        "C:\tools\CppDepend"
        "C:\tools\dart-sdk\bin"
        "C:\tools\doublecmd"
        "C:\tools\emsdk"
        "C:\tools\espressif"
        "C:\tools\fasm"
        "C:\tools\ghc-9.8.2\bin"
        "C:\tools\ghc-9.8.1\bin"
        "C:\tools\ghc-9.6.2\bin"
        "C:\tools\ghc-9.6.1\bin"
        "C:\tools\gnuplot\bin"
        "C:\tools\MagicaVoxel"
        "C:\tools\miniforge3\condabin"
        "C:\tools\msys64"
        "C:\tools\neovim\Neovim\bin"
        "C:\tools\ProccessHacker"
        "C:\tools\processing-4.3\"
        "C:\tools\SHADERed"
        "C:\tools\Sharpmake"
        "C:\tools\sonar\bin"
        "C:\tools\stlink\bin"
        "C:\tools\swig"
        "C:\tools\tracy"
        "C:\tools\vim"
        "C:\tools\wabt\1.0.24"
        "C:\tools\wsl\arch"
        "C:\tools\wsl\debian"
        "C:\tools\wsl\kali"
        "C:\tools\wsl\ubuntu"
        # "C:\tools\wsltty\bin"
        "C:\tools\zig"
    )

    $final_path = "${Env:USERPROFILE}\.bin;${Env:USERPROFILE}\.bin\win"

    foreach ($path in $paths)
    {
        if (Test-Path $path)
        {
            $final_path += ";$path"
        }
    }

    [Environment]::SetEnvironmentVariable("PATH", "$final_path", "User")
}

# C:\Program Files\                             --> C:\PROGRA~1\
# C:\Program Files\Common Files                 --> C:\PROGRA~1\
# C:\Program Files\NVIDIA Corporation           --> C:\PROGRA~1\NVIDIA~1
# C:\Program Files\NVIDIA GPU Computing Toolkit --> C:\PROGRA~1\NVIDIA~2
# C:\Program Files (x86)\                       --> C:\PROGRA~2\
# C:\Program Files (x86)\NVIDIA Corporation     --> C:\PROGRA~2\NVIDIA~1
# C:\ProgramData\                               --> C:\PROGRA~3\
function Initialize-Paths-System
{
    $paths = @(
        "C:\PROGRA~1\PowerShell\7"
        "${Env:USERPROFILE}\AppData\Local\Microsoft\WindowsApps"
        "C:\texlive\2025\bin\windows"
        "C:\texlive\2024\bin\windows"
        "C:\texlive\2023\bin\windows"
        "C:\texlive\2022\bin\win32"
        "C:\PROGRA~1\Amazon\AWSCLI\bin"
        "C:\PROGRA~1\Amazon\AWSCLIV2"
        "C:\PROGRA~1\AutoHotkey"
        "C:\PROGRA~1\BinDiff\bin"
        "C:\PROGRA~1\Calibre2"
        "C:\PROGRA~1\CMake\bin"
        "C:\PROGRA~1\COMMON~1\Intel\WirelessCommon"
        "C:\PROGRA~1\Cppcheck"
        # "C:\tools\docker"                         ## Use Set-ContainerEngine
        # "C:\PROGRA~1\RedHat\Podman"               ## Use Set-ContainerEngine
        # "C:\PROGRA~1\Docker\Docker\resources\bin" ## Use Set-ContainerEngine
        "C:\PROGRA~1\dotnet"
        "C:\PROGRA~1\doxygen\bin"
        "C:\PROGRA~1\f3d\bin"
        "C:\PROGRA~1\Git LFS"
        "C:\PROGRA~1\Git\cmd"
        "C:\PROGRA~1\Go\bin"
        "C:\PROGRA~1\Gpg4win\..\GnuPG\bin"
        "C:\PROGRA~1\Graphviz\bin"
        "C:\PROGRA~1\grepWin"
        "C:\PROGRA~1\gs\gs9.53.1\bin"
        "C:\PROGRA~1\gs\gs9.53.3\bin"
        "C:\PROGRA~1\Intel\TXE Components\DAL"
        "C:\PROGRA~1\Intel\TXE Components\IPT"
        "C:\PROGRA~1\Intel\TXE Components\TCS"
        "C:\PROGRA~1\Intel\WiFi\bin"
        "C:\PROGRA~1\Lens\resources\cli\bin"
        "C:\PROGRA~1\LLVM\bin"
        "C:\PROGRA~1\MATLAB\R2022a\bin"
        "C:\PROGRA~1\MATLAB\R2022a\runtime\win64"
        "C:\PROGRA~1\Mercurial"
        "C:\PROGRA~1\Microsoft MPI\Bin"
        "C:\PROGRA~1\Microsoft SDKs\Azure\CLI2\wbin"
        "C:\PROGRA~1\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn"
        "C:\PROGRA~1\Microsoft SQL Server\160\Tools\Binn"
        "C:\PROGRA~1\Microsoft SQL Server\150\Tools\Binn"
        "C:\PROGRA~1\Microsoft SQL Server\130\Tools\Binn"
        "C:\PROGRA~1\Microsoft Visual Studio\2022\Enterprise\Msbuild\Current\Bin\Roslyn"
        "C:\PROGRA~1\Microsoft Visual Studio\2022\Professional\Msbuild\Current\Bin\Roslyn"
        "C:\PROGRA~1\Microsoft Visual Studio\2022\Community\Msbuild\Current\Bin\Roslyn"
        "C:\PROGRA~1\Microsoft Visual Studio\2022\Preview\Msbuild\Current\Bin\Roslyn"
        "C:\PROGRA~1\Microsoft VS Code Insiders\bin"
        "C:\PROGRA~1\Microsoft VS Code\bin"
        "C:\PROGRA~1\MiKTeX\miktex\bin\x64"
        "C:\PROGRA~1\MySQL\MySQL Workbench 8.0 CE"
        "C:\PROGRA~1\NASM"
        "C:\PROGRA~1\nodejs"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2025.4.0"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2025.3.1"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2025.3.0"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2025.2.0"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2025.1.1"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2024.3.2"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2024.3.0"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2024.2.0"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2024.1.0"
        "C:\PROGRA~1\NVIDIA~1\NVIDIA app\NvDLISR"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v13.1\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v13.1\bin\x64"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v13.1\compute-sanitizer"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v13.0\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v13.0\bin\x64"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v13.0\compute-sanitizer"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v12.9\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v12.9\compute-sanitizer"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v12.8\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v12.8\compute-sanitizer"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v12.6\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v12.6\compute-sanitizer"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v12.6\nvvm\bin"
        "C:\PROGRA~1\OpenConnect-GUI"
        "C:\PROGRA~1\OpenCppCoverage"
        "C:\PROGRA~1\OpenSCAD"
        "C:\PROGRA~1\OpenSSH-Win64"
        "C:\PROGRA~1\OpenSSL\bin"
        "C:\PROGRA~1\OpenVPN\bin"
        "C:\PROGRA~1\Rust stable MSVC 1.33\bin"
        "C:\PROGRA~1\S3 Browser"
        "C:\PROGRA~1\Sublime Text"
        "C:\PROGRA~1\TAP-Windows\bin"
        "C:\PROGRA~1\VcXsrv"
        "C:\PROGRA~1\Wolfram Research\WolframScript"
        "C:\PROGRA~1\AutoFirma\AutoFirma"
        # "C:\PROGRA~2\Common Files\Oracle\Java\javapath"
        # "C:\PROGRA~2\dotnet"
        "C:\PROGRA~2\Dr. Memory\bin64"
        "C:\PROGRA~2\encfs"
        "C:\PROGRA~2\GNU\GnuPG\pub"
        "C:\PROGRA~2\GnuWin32\bin"
        "C:\PROGRA~2\Gpg4win\..\GnuPG\bin"
        "C:\PROGRA~2\IncrediBuild"
        "C:\PROGRA~2\Intel\Intel(R) Management Engine Components\DAL"
        "C:\PROGRA~2\Intel\TXE Components\DAL"
        "C:\PROGRA~2\Intel\TXE Components\IPT"
        "C:\PROGRA~2\Intel\TXE Components\TCS"
        "C:\PROGRA~2\Lua\5.1"
        "C:\PROGRA~2\Lua\5.1\clibs"
        "C:\PROGRA~2\Microsoft SDKs\Azure\CLI2\wbin"
        "C:\PROGRA~2\Microsoft Visual Studio\2022\BuildTools\Msbuild\Current\Bin\Roslyn"
        "C:\PROGRA~2\Microsoft Visual Studio\2019\Enterprise\MSBuild\16.0\Bin\Roslyn"
        "C:\PROGRA~2\Microsoft Visual Studio\2019\Professional\MSBuild\16.0\Bin\Roslyn"
        "C:\PROGRA~2\Microsoft Visual Studio\2019\Community\MSBuild\16.0\Bin\Roslyn"
        "C:\PROGRA~2\Microsoft Visual Studio\2019\BuildTools\MSBuild\16.0\Bin\Roslyn"
        "C:\PROGRA~2\Microsoft Visual Studio\2019\Preview\MSBuild\16.0\Bin\Roslyn"
        "C:\PROGRA~2\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\Roslyn"
        "C:\PROGRA~2\Microsoft Visual Studio\2017\Professional\MSBuild\15.0\Bin\Roslyn"
        "C:\PROGRA~2\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\Roslyn"
        "C:\PROGRA~2\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\Roslyn"
        "C:\PROGRA~2\Microsoft Visual Studio\2017\Preview\MSBuild\15.0\Bin\Roslyn"
        "C:\PROGRA~2\NSIS"
        "C:\PROGRA~2\NVIDIA Corporation\PhysX\Common"
        "C:\PROGRA~2\OpenConnect-GUI"
        "C:\PROGRA~2\Subversion\bin"
        "C:\PROGRA~2\Windows Kits\10\WINDOW~1"
        "C:\PROGRA~2\Windows Kits\8.1\WINDOW~1"
        "C:\PROGRA~2\WinFsp\bin"
        "C:\PROGRA~2\Yarn\bin"
        "$Env:SystemRoot"
        "$Env:SystemRoot\system32"
        "$Env:SystemRoot\System32\Wbem"
        "$Env:SYSTEMROOT\System32\WindowsPowerShell\v1.0"
        "$Env:SYSTEMROOT\System32\OpenSSH"
    )

    $final_path = "C:\ProgramData\chocolatey\bin"

    foreach ($path in $paths)
    {
        if (Test-Path $path)
        {
            $final_path += ";$path"
        }
    }

    [Environment]::SetEnvironmentVariable("PathsSys", "$final_path", "Machine")
}

function Set-Env
{
    # Save current variables
    [Environment]::SetEnvironmentVariable("PATH_PRE_SYS", "$([Environment]::GetEnvironmentVariable("PATH", "Machine"))", "Machine")
    [Environment]::SetEnvironmentVariable("PATH_PRE_USR", "$([Environment]::GetEnvironmentVariable("PATH", "User"))", "Machine")

    # PATHs
    Initialize-Paths-System
    Initialize-Paths-User

    Reset-Environment

    $system_path = "C:\tools\bin"

    if ($Env:CONTAINER_ENGINE_PATH)
    {
        $system_path += ";$Env:CONTAINER_ENGINE_PATH"
    }

    if ($Env:CUDNN_PATH)
    {
        $system_path += ";$Env:CUDNN_PATH\bin"
    }

    if ($Env:JAVA_HOME)
    {
        $system_path += ";$Env:JAVA_HOME\bin"
    }

    if ($Env:PYENV)
    {
        $system_path += ";$Env:PYENV\bin"
        $system_path += ";$Env:PYENV\shims"
    }

    if ($Env:PYTHON_PATH)
    {
        $system_path += ";$Env:PYTHON_PATH\Scripts"
        $system_path += ";$Env:PYTHON_PATH"
    }

    if ($Env:QTDIR)
    {
        $system_path += ";$Env:QTDIR\bin"
    }

    if ($Env:RPROJECT_PATH)
    {
        $system_path += ";$Env:RPROJECT_PATH"
    }

    if ($Env:RUBY_PATH)
    {
        $system_path += ";$Env:RUBY_PATH"
    }

    if ($Env:SquishBinDir)
    {
        $system_path += ";$Env:SquishBinDir"
    }

    if ($Env:VC_IDE)
    {
        $system_path += ";$Env:VC_IDE"
    }

    # if ($Env:VC_PATH) {
    #     $system_path += ";$Env:VC_PATH"
    # }

    if ($Env:VCPKG_ROOT)
    {
        $system_path += ";$Env:VCPKG_ROOT"
    }

    if ($Env:VISUALGDB_DIR)
    {
        $system_path += ";$Env:VISUALGDB_DIR"
    }

    if ($Env:VULKAN_SDK)
    {
        $system_path += ";$Env:VULKAN_SDK\Bin"
    }

    $system_path += ";$Env:PathsSys"
    [Environment]::SetEnvironmentVariable("PATH", "$system_path", "Machine")
    [Environment]::SetEnvironmentVariable("PathsApp", [NullString]::Value, "Machine")

    # LANG
    [Environment]::SetEnvironmentVariable("LANG", "en_US", "Machine")

    # Development Env
    if (Test-Path "C:\Program Files\Git LFS")
    {
        [Environment]::SetEnvironmentVariable("GIT_LFS_PATH", "C:\Program Files\Git LFS", "Machine")
    }

    # Set-PowershellEnvironment
    Set-WorkEnv
    Reset-Environment
}

function Set-WorkEnv
{
    # if (Test-Path "$Env:WORKSPACE\thirdparty")  {
    #     [Environment]::SetEnvironmentVariable("THIRDPARTY_LOCATION", "$Env:WORKSPACE\thirdparty", "Machine")
    # }
    # if (Test-Path "$Env:WORKSPACE\testdata")  {
    #     [Environment]::SetEnvironmentVariable("TESTDATA_LOCATION", "$Env:WORKSPACE\testdata", "Machine")
    # }
}

# C:\Program Files\       --> C:\PROGRA~1\
# C:\Program Files (x86)\ --> C:\PROGRA~2\
# C:\ProgramData\         --> C:\PROGRA~3\
function Set-PowershellEnvironment
{
    $paths = @(
        # "C:\Program Files\PowerShell\7\Modules"
        "C:\Program Files\WindowsPowerShell\Modules"
        "C:\WINDOWS\system32\WindowsPowerShell\v1.0\Modules"
        "C:\opscode\chefdk\modules"
        "C:\ProgramData\chocolatey\lib\Paket.PowerShell\tools"
        # "${Env:USERPROFILE}\Documents\PowerShell\Modules"
        # "${Env:USERPROFILE}\OneDrive\Documents\PowerShell\Modules"
        # "${Env:USERPROFILE}\OneDrive\Documents\WindowsPowerShell\Modules"
        # "C:\Program Files\PowerShell\6\Modules"
        # "C:\Program Files\PowerShell\Modules"
    )

    $final_path = "C:\Program Files\PowerShell\7\Modules"

    foreach ($path in $paths)
    {
        if (Test-Path $path)
        {
            $final_path += ";$path"
        }
    }

    Set-Item -Path Env:PSModulePath -Value "${final_path}"
    # [Environment]::SetEnvironmentVariable("PSModulePath", "$final_path", "Machine")
}

# Set a permanent Environment variable, and reload it into $env
function Set-Environment([String] $variable, [String] $value)
{
    Set-ItemProperty -Path "HKCU:\Environment" -Name $variable -Value $value
    # Manually setting Registry entry. SetEnvironmentVariable is too slow because of blocking HWND_BROADCAST
    #[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
    Invoke-Expression "`$Env:${variable} = `"$value`""
}

# Reload the $env object from the registry
function Reset-Environment
{
    $locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'HKCU:\Environment'

    $locations | ForEach-Object {
        $k = Get-Item $_
        $k.GetValueNames() | ForEach-Object {
            $name = $_
            $value = $k.GetValue($_)
            Set-Item -Path Env:\$name -Value $value
        }
    }

    $Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

function Edit-Hosts
{
    Invoke-Expression "sudo $(
        if ($null -ne $Env:EDITOR)
        {
            $Env:EDITOR
        }
        else
        {
            'notepad'
        }) $Env:windir\system32\drivers\etc\hosts"
}

function Edit-Profile
{
    Invoke-Expression "$(
        if ($null -ne $Env:EDITOR)
        {
            $Env:EDITOR
        }
        else
        {
            'notepad'
        }) $profile"
}
