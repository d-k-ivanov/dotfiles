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
$Env:LANG   = "en_US"
# $Env:LC_ALL = "C.UTF-8"
$Env:LC_ALL = "C"

# Init of directory envs:
$Env:PWD = Get-Location
$Env:OLDPWD = Get-Location

# Virtual Env Fix (if prompt in ReadOnly mode)
# $env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# VCPKG:
$Env:VCPKG_DISABLE_METRICS = 1
# $Env:VCPKG_FEATURE_FLAGS = "versions"

# PS Readline:
$PSReadLineOptions = @{
    # EditMode = "Vi"
    EditMode = "Emacs"

    # Defaiult word delimiters
    WordDelimiters = ';:,.[]{}()/\|^&*-=+`"–—―'
    # Bash 4.0 word delimiters
    # WordDelimiters = '()<>;&|"'

    MaximumHistoryCount = 32767
    HistoryNoDuplicates = $true
    HistorySearchCursorMovesToEnd = $true
    ShowToolTips = $false
}
Set-PSReadLineOption @PSReadLineOptions

If($PSVersionTable.PSVersion.Major -ge '7' -And $PSVersionTable.PSVersion.Minor -ge '2')
{
    Set-PSReadLineOption -PredictionSource None
    # Set-PSReadLineOption -PredictionViewStyle = "ListView"
}

### KEYS:
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
Set-PSReadlineKeyHandler -Key Ctrl+e -Function DeleteWord
Set-PSReadlineKeyHandler -Key Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Key Tab -Function Complete

#  1..50000 | % {Set-Variable -Name MaximumHistoryCount -Value $_ }
Set-Variable -Name MaximumHistoryCount -Value 32767

${function:env} = {Get-ChildItem Env:}
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
        "${env:USERPROFILE}\OneDrive\bin"
        "${env:USERPROFILE}\OneDrive\bin\work"
        "${env:USERPROFILE}\OneDrive - STG-Business\bin"
        "${env:USERPROFILE}\OneDrive - STG-Business\bin\work"
        "${env:USERPROFILE}\scoop\shims"
        "${env:GOPATH}\bin"
        "${env:M2_HOME}\bin"
        "${env:USERPROFILE}\.elan\bin"
        "${env:USERPROFILE}\.cargo\bin"
        "${env:USERPROFILE}\.dotnet\tools"
        "${env:USERPROFILE}\.krew\bin"
        "${env:USERPROFILE}\AppData\Local\Android\Sdk\platform-tools"
        "${env:USERPROFILE}\AppData\Local\Pandoc"
        "${env:USERPROFILE}\AppData\Local\Programs\Fiddler"
        "${env:USERPROFILE}\AppData\Local\Programs\Microsoft VS Code Insiders\bin"
        "${env:USERPROFILE}\AppData\Local\Yarn\bin"
        "${env:USERPROFILE}\AppData\Roaming\cabal\bin"
        "${env:USERPROFILE}\AppData\Roaming\local\bin"
        "${env:USERPROFILE}\AppData\Roaming\npm"
        "C:\usr\bin"
        "C:\boost\dist\bin"
        "C:\Coq\bin"
        "C:\Go\bin"
        "C:\HashiCorp\Vagrant\bin"
        "C:\msys64"
        "C:\texlive\2023\bin\win32"
        "C:\texlive\2022\bin\win32"
        "C:\opscode\chefdk\bin"
        "C:\PROGRA~1\Azure Data Studio\bin"
        "C:\PROGRA~1\Conan\conan"
        "C:\PROGRA~1\ConEmu\ConEmu"
        "C:\PROGRA~1\ConEmu\ConEmu\wsl"
        "C:\PROGRA~1\gnuplot\bin"
        "C:\PROGRA~1\Gource\cmd"
        "C:\PROGRA~1\ImageMagick-7.1.0-Q16-HDRI"
        "C:\PROGRA~1\ImageMagick-7.0.10-Q16-HDRI"
        "C:\PROGRA~1\KDiff3"
        "C:\PROGRA~1\KDiff3\bin"
        "C:\PROGRA~1\Pandoc"
        "C:\PROGRA~1\SmartGit\bin"
        "C:\PROGRA~1\SmartSynchronize\bin"
        "C:\PROGRA~1\Sublime Text 3"
        "C:\PROGRA~1\WinMerge"
        "C:\PROGRA~2\Android\android-sdk\platform-tools"
        "C:\PROGRA~2\GitExtensions"
        "C:\PROGRA~2\Nmap"
        "C:\PROGRA~2\pgAdmin 4\v4\runtime"
        "C:\Strawberry\perl\bin"
        # "C:\Strawberry\perl\site\bin"
        "C:\tools\acli"
        # "C:\tools\Atlassian\atlassian-plugin-sdk-8.2.7\bin"
        "C:\tools\BCURRAN3"
        "C:\tools\binaryen\bin"
        "C:\tools\CppDepend"
        "C:\tools\dart-sdk\bin"
        "C:\tools\doublecmd"
        "C:\tools\emsdk"
        "C:\tools\fasm"
        "C:\tools\ghc-9.4.4\bin"
        "C:\tools\ghc-9.4.2\bin"
        "C:\tools\ghc-9.4.1\bin"
        "C:\tools\ghc-9.2.4\bin"
        "C:\tools\ghc-9.2.3\bin"
        "C:\tools\ghc-9.2.2\bin"
        "C:\tools\ghc-9.2.1\bin"
        "C:\tools\ghc-9.0.1\bin"
        "C:\tools\gnuplot\bin"
        "C:\tools\msys64"
        "C:\tools\neovim\Neovim\bin"
        "C:\tools\ProccessHacker"
        "C:\tools\sonar-scanner-4.4.0.2170-windows\bin"
        "C:\tools\stlink\1.7.0\bin"
        "C:\tools\swig"
        "C:\tools\vcpkg"
        "C:\tools\wabt\1.0.24"
        "C:\tools\wsl\arch"
        "C:\tools\wsl\debian"
        "C:\tools\wsl\kali"
        "C:\tools\wsl\ubuntu"
        "C:\VulkanSDK\1.3.211.0\Bin"
        "C:\VulkanSDK\1.3.204.1\Bin"
        "C:\VulkanSDK\1.2.198.1\Bin"
        "C:\VulkanSDK\1.2.189.2\Bin"
        "C:\ProgramData\chocolatey\lib\pulumi\tools\Pulumi\bin"
        "C:\ProgramData\chocolatey\lib\wmiexplorer\tools"
        # "C:\ProgramData\DockerDesktop\version-bin"
    )

    $final_path = "${env:USERPROFILE}\.bin"

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
        "${env:USERPROFILE}\AppData\Local\Microsoft\WindowsApps"
        "C:\PROGRA~1\Amazon\AWSCLI\bin"
        "C:\PROGRA~1\Amazon\AWSCLIV2"
        "C:\PROGRA~1\AutoHotkey"
        "C:\PROGRA~1\BinDiff\bin"
        "C:\PROGRA~1\Calibre2"
        "C:\PROGRA~1\CMake\bin"
        "C:\PROGRA~1\COMMON~1\Intel\WirelessCommon"
        "C:\PROGRA~1\Cppcheck"
        # "C:\tools\docker"
        # "C:\PROGRA~1\RedHat\Podman\"
        # "C:\PROGRA~1\Docker\Docker\resources\bin"
        "C:\PROGRA~1\dotnet"
        "C:\PROGRA~1\doxygen\bin"
        "C:\PROGRA~1\f3d\bin"
        "C:\PROGRA~1\Git LFS"
        "C:\PROGRA~1\Git\cmd"
        "C:\PROGRA~1\Go\bin"
        "C:\PROGRA~1\grepWin"
        "C:\PROGRA~1\Graphviz\bin"
        "C:\PROGRA~1\gs\gs9.53.3\bin"
        "C:\PROGRA~1\gs\gs9.53.1\bin"
        "C:\PROGRA~1\Intel\TXE Components\DAL"
        "C:\PROGRA~1\Intel\TXE Components\IPT"
        "C:\PROGRA~1\Intel\TXE Components\TCS"
        "C:\PROGRA~1\Intel\WiFi\bin"
        "C:\PROGRA~1\LLVM\bin"
        "C:\PROGRA~1\MATLAB\R2022a\bin"
        "C:\PROGRA~1\MATLAB\R2022a\runtime\win64"
        "C:\PROGRA~1\Mercurial"
        "C:\PROGRA~1\Microsoft MPI\Bin"
        "C:\PROGRA~1\Microsoft SQL Server\150\Tools\Binn"
        # "C:\PROGRA~1\Microsoft SQL Server\130\Tools\Binn"
        "C:\PROGRA~1\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn"
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
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2022.4.0"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2022.3.0"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2022.2.0"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2022.1.1"
        "C:\PROGRA~1\NVIDIA~1\Nsight Compute 2022.1.0"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v12.0\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v12.0\compute-sanitizer"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v12.0\libnvvp"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v12.0\nvvm\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.8\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.8\compute-sanitizer"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.8\libnvvp"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.8\nvvm\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.7\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.7\compute-sanitizer"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.7\libnvvp"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.7\nvvm\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.6\bin"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.6\compute-sanitizer"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.6\libnvvp"
        "C:\PROGRA~1\NVIDIA~2\CUDA\v11.6\nvvm\bin"
        "C:\PROGRA~1\OpenConnect-GUI"
        "C:\PROGRA~1\OpenCppCoverage"
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
        "C:\PROGRA~2\Intel\Intel(R) Management Engine Components\DAL"
        "C:\PROGRA~2\Intel\TXE Components\DAL"
        "C:\PROGRA~2\Intel\TXE Components\IPT"
        "C:\PROGRA~2\Intel\TXE Components\TCS"
        "C:\PROGRA~2\Lua\5.1"
        "C:\PROGRA~2\Lua\5.1\clibs"
        "C:\PROGRA~2\Microsoft SDKs\Azure\CLI2\wbin"
        # "C:\PROGRA~2\Microsoft SQL Server\150\DTS\Binn"
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
        # "C:\PROGRA~2\NVIDIA~1\PhysX\Common"
        "C:\PROGRA~2\NSIS"
        "C:\PROGRA~2\OpenConnect-GUI"
        "C:\PROGRA~2\Subversion\bin"
        "C:\PROGRA~2\Windows Kits\8.1\Windows Performance Toolkit"
        "C:\PROGRA~2\WinFsp\bin"
        "C:\PROGRA~2\Yarn\bin"
        "$env:SystemRoot"
        "$env:SystemRoot\system32"
        "$env:SystemRoot\System32\Wbem"
        "$env:SYSTEMROOT\System32\WindowsPowerShell\v1.0"
        "$env:SYSTEMROOT\System32\OpenSSH"
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
    [Environment]::SetEnvironmentVariable("PATH_PRE_USR", "$([Environment]::GetEnvironmentVariable("PATH", "User"))",    "Machine")

    # PATHs
    Initialize-Paths-System
    Initialize-Paths-User

    Reset-Environment

    $system_path = "C:\tools\bin"
    if ($Env:CONTAINER_ENGINE_PATH)
    {
        $system_path += ";$Env:CONTAINER_ENGINE_PATH"
    }

    if ($Env:PYTHON_PATH)
    {
        $system_path += ";$Env:PYTHON_PATH\Scripts"
        $system_path += ";$Env:PYTHON_PATH"
    }

    # if ($env:PYENV)
    # {
    #     $system_path += ";$env:PYENV\bin"
    #     $system_path += ";$env:PYENV\shims"
    # }

    if ($env:RUBY_PATH)
    {
        $system_path += ";$env:RUBY_PATH"
    }

    if ($env:RPROJECT_PATH)
    {
        $system_path += ";$env:RPROJECT_PATH"
    }

    if ($env:JAVA_HOME)
    {
        $system_path += ";$env:JAVA_HOME\bin"
    }

    if ($env:VC_IDE)
    {
        $system_path += ";$env:VC_IDE"
    }

    # if ($env:VC_PATH) {
    #     $system_path += ";$env:VC_PATH"
    # }

    if ($env:QTDIR)
    {
        $system_path += ";$env:QTDIR\bin"
    }

    if ($env:SquishBinDir)
    {
        $system_path += ";$env:SquishBinDir"
    }

    if ($env:VISUALGDB_DIR)
    {
        $system_path += ";$env:VISUALGDB_DIR"
    }

    $system_path += ";$env:PathsSys"
    [Environment]::SetEnvironmentVariable("PATH", "$system_path", "Machine")
    [Environment]::SetEnvironmentVariable("PathsApp", $null, "Machine")

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
        # "${env:USERPROFILE}\Documents\PowerShell\Modules"
        # "${env:USERPROFILE}\OneDrive\Documents\PowerShell\Modules"
        # "${env:USERPROFILE}\OneDrive\Documents\WindowsPowerShell\Modules"
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
    Invoke-Expression "`$env:${variable} = `"$value`""
}

# Reload the $env object from the registry
function Reset-Environment
{
    $locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
                 'HKCU:\Environment'

    $locations | ForEach-Object {
        $k = Get-Item $_
        $k.GetValueNames() | ForEach-Object {
            $name  = $_
            $value = $k.GetValue($_)
            Set-Item -Path Env:\$name -Value $value
        }
    }

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

function Edit-Hosts
{
    Invoke-Expression "sudo $(
        if ($null -ne $env:EDITOR)
        {
            $env:EDITOR
        }
        else
        {
            'notepad'
        }) $env:windir\system32\drivers\etc\hosts"
}

function Edit-Profile
{
    Invoke-Expression "$(
        if ($null -ne $env:EDITOR)
        {
            $env:EDITOR
        }
        else
        {
            'notepad'
        }) $profile"
}
