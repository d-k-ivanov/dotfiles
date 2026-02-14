<#
.SYNOPSIS
Package scripts.

.DESCRIPTION
Package scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    exit
}

# ==============================================================================================================
# Shared package management functions
# ==============================================================================================================
function Update-System()
{
    # PowerShell:
    # Update-Help -Force
    Update-Module
    # Scoop:
    # scoop update *
    # Chocolatey:
    # choco upgrade all -y
    # Winget:
    # winget upgrade --all --silent
    # RubyGems:
    # gem update --system
    # gem update
    # NPM:
    npm install npm -g
    npm update -g
}

# ==============================================================================================================
# Scoop package management functions: local user only
# ==============================================================================================================
function Install-Scoop()
{
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue))
    {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        irm get.scoop.sh | iex
    }
}

function Update-Scoop()
{
    scoop update *
}

function Install-ScoopPackages()
{
    Write-Host "Installing buckets..."
    $buckets = @(
        "extras",
        "games",
        "java",
        "nerd-fonts"
    )

    foreach ($bucket in $buckets)
    {
        scoop bucket add $bucket
    }

    Write-Host "Installing packages..."
    $packages = @(
        # Java
        "java/microsoft-jdk"
        "java/microsoft-lts-jdk"
        "java/microsoft11-jdk"
        "java/microsoft16-jdk"
        "java/microsoft17-jdk"
        "java/microsoft21-jdk"
        "${Env:USERPROFILE}\scoop\apps\openjdk\"
        "java/openjdk7-unofficial"
        "java/openjdk8-redhat"
        "java/openjdk9"
        "java/openjdk10"
        "java/openjdk11"
        "java/openjdk12"
        "java/openjdk13"
        "java/openjdk14"
        "java/openjdk15"
        "java/openjdk16"
        "java/openjdk17"
        "java/openjdk18"
        "java/openjdk19"
        "java/openjdk20"
        "java/openjdk21"
        "java/openjdk22"
        "java/openjdk23"
        "java/openjdk24"
        "java/openjdk25"
        "java/oraclejdk"
        "java/oraclejdk-lts"
        "java/temurin-jdk"
        "java/temurin-lts-jdk"
        "java/temurin8-jdk"
        "java/temurin11-jdk"
        "java/temurin16-jdk"
        "java/temurin17-jdk"
        "java/temurin18-jdk"
        "java/temurin19-jdk"
        "java/temurin20-jdk"
        "java/temurin21-jdk"
        "java/temurin22-jdk"
        "java/temurin23-jdk"
        "java/temurin24-jdk"
        "java/temurin25-jdk"

        # Fonts
        "nerd-fonts/Hack-NF"
        "nerd-fonts/Hack-NF-Propo"
        "nerd-fonts/Hack-NF-Mono"
    )

    foreach ($package in $packages)
    {
        scoop install $package
    }
}

# ==============================================================================================================
# Chocolatey package management functions: system-wide
# ==============================================================================================================
function Install-Chocolatey()
{
    if (-not (Get-Command choco -ErrorAction SilentlyContinue))
    {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        irm https://community.chocolatey.org/install.ps1 | iex
    }

    # Enable remembering arguments for upgrades
    choco feature enable -n=useRememberedArgumentsForUpgrades

}

function Update-Chocolatey()
{
    choco upgrade all -y
    choco feature enable -n=useRememberedArgumentsForUpgrades
}

function Install-ChocolateyPackages()
{
    $packages = @(
        # ------------------------------------------------------------------
        # Basic Packages
        # ------------------------------------------------------------------

        "7zip.install"                      # 7-Zip file archiver
        "busybox"                           # BusyBox for Windows
        "conemu"                            # ConEmu terminal emulator
        "curl"                              # Command-line tool for transferring data with URL syntax
        "du"                                # Disk usage analyzer
        "everything"                        # Fast file and folder search tool
        "gnuwin32-coreutils.install"        # GNU Core Utilities for Windows
        "grep"                              # Command-line text search tool
        "jq"                                # Command-line JSON processor
        # "ripgrep"                         # Fast command-line search tool
        "tree"                              # Directory tree listing tool
        "wget"                              # Command-line file downloader
        "yq"                                # Command-line YAML processor

        # Browsers
        "firefox"                           # Mozilla Firefox web browser
        "googlechrome"                      # Google Chrome web browser
        # "palemoon"                        # Lightweight Firefox-based web browser
        "tor-browser"                       # Tor Browser for anonymous web browsing

        # Microsoft:
        "vcredist140"                       # Visual C++ Redistributable for Visual Studio 2015-2022
        "vcredist2005"                      # Visual C++ Redistributable for Visual Studio 2005
        "vcredist2008"                      # Visual C++ Redistributable for Visual Studio 2008
        "vcredist2010"                      # Visual C++ Redistributable for Visual Studio 2010
        "vcredist2012"                      # Visual C++ Redistributable for Visual Studio 2012
        "vcredist2013"                      # Visual C++ Redistributable for Visual Studio 2013
        "vcredist2015"                      # Visual C++ Redistributable for Visual Studio
        "vcredist2017"                      # Visual C++ Redistributable for Visual Studio 2017
        "dotnet4.6.1"                       # Microsoft .NET Framework 4.6.1

        # Utilities:
        # "crystaldiskinfo.install"         # CrystalDiskInfo disk health monitoring tool
        # "crystaldiskmark"                 # CrystalDiskMark disk benchmark tool
        "choco-cleaner"                     # Chocolatey Cleaner
        # "doublecmd"                       # Double Commander file manager
        # "encfs4win"                       # EncFS4Win encrypted file system
        # "ext2fsd"                         # Ext2Fsd - Ext2/3/4 file system driver for Windows
        # "far"                             # FAR Manager file manager
        "gpu-z"                             # GPU-Z graphics card information tool
        "hwinfo"                            # HWiNFO hardware information and diagnostic tool
        "imdisk-toolkit"                    # ImDisk Toolkit virtual disk driver and tools
        "libre-hardware-monitor"            # Libre Hardware Monitor hardware monitoring tool
        "lockhunter"                        # LockHunter file unlocker
        "nssm"                              # Non-Sucking Service Manager
        # "open-shell"                      # Open-Shell (Classic Shell) start menu replacement
        "powertoys"                         # Microsoft PowerToys utilities
        # "rapidee"                         # RapidEE registry Editor
        # "sophiapp"                        # Sophisticated Windows customization tool
        # "swissfileknife"                  # Swiss File Knife command-line tool
        "sysinternals"                      # Sysinternals Suite
        "traystatus.install"                # TrayStatus system status monitor
        "windirstat"                        # WinDirStat disk usage statistics viewer
        "winfsp"                            # Windows File System Proxy

        # ------------------------------------------------------------------
        # Office and Documentation Packages
        # ------------------------------------------------------------------

        # Communication:
        # "microsoft-teams.install"         # Microsoft Teams
        # "slack"                           # Slack client
        # "telegram.install"                # Telegram messenger
        # "whatsapp"                        # WhatsApp messenger
        # "zoom"                            # Zoom video conferencing

        # Documentation:
        "docfx"                             # Documentation generator for .NET projects
        "doxygen.install"                   # Doxygen documentation generator
        # "miktex.install"                  # MiKTeX LaTeX distribution
        "pandoc"                            # Universal document converter
        "plantuml"                          # UML diagram generator
        # "texlive"                         # TeX Live LaTeX distribution
        "texstudio.install"                 # TeXstudio LaTeX editor
        # "yed"                             # yEd Graph Editor
        # "zotero"                          # Zotero reference manager

        # Fonts:
        "cascadiacode"                      # Cascadia Code font
        "cascadiamono"                      # Cascadia Mono font
        "cascadiamonopl"                    # Cascadia Mono PLus font
        "dejavufonts"                       # DejaVu fonts
        "firacode"                          # FiraCode font
        "fontforge"                         # FontForge font editor
        "inconsolata"                       # Inconsolata
        "nerd-fonts-hack"                   # Hack Nerd Font
        "nerd-fonts-sourcecodepro"          # Source Code Pro Nerd Font
        "sourcecodepro"                     # Source Code Pro font

        # Internet:
        "qbittorrent"                       # qBittorrent BitTorrent client
        "yt-dlp"                            # YouTube video downloader

        # Office:
        "adobereader"                       # Adobe Acrobat Reader DC
        # "anki"                            # Anki flashcard program
        # "calibre"                         # Calibre eBook management software
        "Ghostscript.app"                   # Ghostscript PostScript and PDF interpreter
        "dropbox"                           # Dropbox client
        # "libreoffice-fresh"               # LibreOffice suite
        "pdf24"                             # PDF24 Creator
        "pdfsam"                            # PDF Split and Merge Basic
        # "qtranslate"                      # QTranslate language translator. Download from: https://quest-app.appspot.com/
        "sumatrapdf.install"                # SumatraPDF document viewer
        # "thunderbird"                     # Mozilla Thunderbird email client
        # "windjview"                       # DjVu document viewer
        "xpdf-utils"                        # Xpdf command-line PDF toolset

        # Utilities:
        # "flameshot"                       # Screenshot tool
        "greenshot"                         # Screenshot tool
        # "sharex"                          # Screenshot and screencast tool

        # ------------------------------------------------------------------
        # DevOps and Administration Packages
        # ------------------------------------------------------------------

        # Databases:
        "dbeaver"                           # Database management tool
        # "mysql.workbench"                 # MySQL Workbench
        # "pgadmin4"                        # PostgreSQL management tool
        # "robo3t"                          # GUI for MongoDB
        "sql-server-management-studio"      # Microsoft SQL Server Management Studio
        "sqlitebrowser.install"             # SQLite database browser

        # DevOps:
        "act-cli"                           # Run GitHub Actions locally
        "aws-iam-authenticator"             # AWC IAM Authenticator
        "awscli"                            # Amazon AWS CLI
        "azure-cli"                         # Microsoft Azure CLI
        # "chefdk"                          # Chef Development Kit
        # "cyberduck"                       # Cyberduck FTP and cloud storage client
        # "ftpdmin"                         # FTP server administration tool
        "gh"                                # GitHub CLI tool
        # "eksctl"                          # Amazon EKS CLI tool
        "headlamp"                          # Kubernetes dashboard
        "k9s"                               # K9s - Kubernetes CLI to manage clusters
        # "kubergrunt"                      # Kubernetes cluster management tool
        "kubernetes-cli"                    # kubectl - Kubernetes command-line tool
        "kubernetes-helm"                   # Helm - Kubernetes package manager
        # "kubernetes-kompose"              # Kompose - Kubernetes object converter
        "kubernetes-kops"                   # Kubernetes Operations (kops) tool for managing clusters
        "kustomize"                         # Kubernetes configuration management tool
        # "krew"                            # kubectl plugin manager
        # "kubectx"                         # kubectx and kubens - Kubernetes context and namespace switcher
        # "kubeval"                         # Kubernetes configuration validator
        # "ldapadmin"                       # LDAP administration tool
        # "lens"                            # Kubernetes IDE
        # "minikube"                        # Minikube - local Kubernetes cluster
        "mremoteng"                         # mRemoteNG remote connections manager
        "packer"                            # HashiCorp Packer
        # "pulumi"                          # Infrastructure as Code tool
        # "putty"                           # PuTTY SSH and telnet client
        "rufus"                             # Bootable USB drive creator
        # "superputty"                      # SuperPuTTY tabbed PuTTY client
        "terraform"                         # Infrastructure as Code tool
        "tightvnc"                          # TightVNC remote desktop software
        # "travis"                          # Travis CI command-line client
        "vagrant"                           # Vagrant virtual machine manager
        # "vagrant-manager"                 # Vagrant Manager GUI
        # "vcxsrv"                          # X server for Windows
        "winscp.install"                    # WinSCP SFTP and FTP client

        # Networking:
        "bind-toolsonly"                    # BIND DNS tools
        "charles4"                          # Charles HTTP Proxy
        "nmap"                              # Network scanner
        "openssh"                           # OpenSSH client and server
        "openssl.light"                     # OpenSSL toolkit
        # "openconnect-gui"                 # OpenConnect GUI client
        "openvpn"                           # OpenVPN client
        # "tapwindows"                      # TAP-Windows driver for VPN clients
        # "tftpd32"                         # TFTP server and client
        # "wifiinfoview"                    # Wireless network information viewer
        # "winpcap"                         # WinPcap network packet capture library
        # "wireshark"                       # Wireshark network protocol analyzer
        # "wmiexplorer"                     # WMI Explorer tool
        # "warp"                            # Cloudflare Warp VPN client

        # Secrets:
        # "1password"                       # 1Password client
        "bitwarden-cli"                     # Bitwarden command-line client
        "bitwarden"                         # Bitwarden desktop client
        "gpg4win"                           # Gpg4win - GnuPG for Windows
        # "keepass"                         # KeePass password manager
        # "keepass-yet-another-favicon-downloader"  # KeePass plugin to download favicons
        # "keepass-plugin-qrcodegen"        # KeePass plugin to generate QR codes
        "keystore-explorer.portable"        # GUI for managing Java keystores

        # Virtualization:
        "docker-desktop"                    # Docker Desktop
        # "podman-cli"                      # Podman CLI tool
        # "podman-desktop"                  # Podman Desktop
        # "rancher-desktop"                 # Rancher Desktop
        # "virtualbox"                      # Oracle VM VirtualBox

        # ------------------------------------------------------------------
        # Software Development Packages
        # ------------------------------------------------------------------

        # Development Tools:
        "bazel"                             # Build and test tool from Google
        # "buckaroo"                        # C/C++ package manager: https://buckaroo.pm/
        "codecov"                           # Code coverage tool
        "conan"                             # C/C++ package manager
        "cmake"                             # Cross-platform build system
        "cutter"                            # Open-source reverse engineering framework
        "cppcheck"                          # Static Analysis Tool for C/C++
        # "delta"                           # A syntax-highlighting pager for git, diff, and grep output
        "dependencies"                      # Modern Dependency Walker
        # "dependencywalker"                # Dependency Walker
        "drmemory"                          # Dynamic Memory Debugger
        # "dvc"                             # Data Version Control: https://dvc.org/
        # "fiddler"                         # HTTP Debugger
        # "emscripten"                      # Emscripten SDK
        "ghidra"                            # Software reverse engineering framework
        "git"                               # Git version control system
        "gitextensions"                     # Git Extensions GUI
        "gitversion.portable"               # Git versioning tool
        "gource"                            # Visualize version control repositories
        "gradle"                            # Gradle build toolkit
        # "hg"                              # Mercurial version control system
        "hxd"                               # Hex editor
        "imhex"                             # Hex editor
        "jetbrainstoolbox"                  # JetBrains Toolbox App
        "ida-free"                          # IDA Freeware - Interactive Disassembler
        # "insomnia-rest-api-client"        # Insomnia REST API Client
        "kdiff3"                            # File and directory comparison tool
        "llvm"                              # LLVM compiler infrastructure
        "make"                              # GNU Make build tool
        "maven"                             # Apache Maven build automation tool
        "meld"                              # Visual diff and merge tool
        "ninja"                             # Ninja build system
        "nuget.commandline"                 # NuGet package manager
        "nugetpackageexplorer"              # NuGet Package Explorer
        "nsis"                              # Nullsoft Scriptable Install System
        "nvm.install"                       # Node Version Manager for Windows
        # "octopustools"                    # Octopus Deploy command-line tools
        "ollydbg"                           # OllyDbg - 32-bit assembler-level debugger
        "opencppcoverage"                   # OpenCppCoverage - Code coverage for C/C++ on Windows
        "paket.powershell"                  # Paket dependency manager for .NET
        # "pmd"                             # PMD source code analyzer. Download from: https://pmd.github.io/
        # "postman"                         # Postman API development environment
        "radare2"                           # Reverse engineering framework
        "reportgenerator.portable"          # Report Generator for code coverage reports
        "reshack"                           # Resource Hacker - Resource editor for Windows executables
        "sass"                              # SASS CSS preprocessor
        # "soapui"                          # SOAP and REST testing tool
        "svn"                               # Apache Subversion version control system
        "swig"                              # Simplified Wrapper and Interface Generator
        "winappdriver"                      # Windows Application Driver
        "winmerge"                          # WinMerge file and directory comparison tool
        # "wixtoolset"                      # Windows Installer XML (WiX) toolset
        "x64dbg.portable"                   # x64dbg - 64-bit debugger
        "xml-notepad"                       # XML Notepad editor
        # "yarn"                            # Yarn package manager

        # Editors
        "notepadplusplus.install"           # Notepad++ text editor
        "notepadplusplus-npppluginmanager"  # Notepad++ Plugin Manager
        # "neovim"                          # Neovim text editor
        # "vim --params `"`'/RestartExplorer /NoDesktopShortcuts /NoDefaultVimrc`'`"" # Vim text editor
        # "vscode"                          # Visual Studio Code editor
        # "visualstudio2026professional"    # Visual Studio 2026 Professional Edition

        # Programming Languages:
        "corretto11jdk"                     # Amazon Corretto 11 JDK
        "corretto17jdk"                     # Amazon Corretto 17 JDK
        "corretto21jdk"                     # Amazon Corretto 21 JDK
        "ghc"                               # Glasgow Haskell Compiler
        "golang"                            # Go programming language
        "jdk8"                              # Java Development Kit 8
        "julia"                             # Julia programming language
        "lein"                              # Clojure build tool
        "lua"                               # Lua programming language
        "microsoft-openjdk"                 # Microsoft OpenJDK
        "microsoft-openjdk11"               # Microsoft OpenJDK 11
        "microsoft-openjdk17"               # Microsoft OpenJDK 17
        # "miniconda3 --params `"`'/InstallationType:AllUsers /AddToPath:0 /RegisterPython:0`'`"" # Miniconda3 Python distribution
        "nasm"                              # Netwide Assembler
        "nodejs-lts"                        # Node.js LTS
        "openjdk"                           # OpenJDK
        "openjdk11"                         # OpenJDK 11
        "oracle17jdk"                       # Oracle JDK 17
        "oraclejdk"                         # Oracle JDK
        "powershell-core"                   # PowerShell Core
        "pyenv-win"                         # Python version management
        # "python"                          # Python programming language
        # "r.studio"                        # R programming language IDE
        # "ruby"                            # Ruby programming language
        "strawberryperl"                    # Strawberry Perl
        "temurin"                           # Eclipse Temurin JDK
        "temurin8"                          # Eclipse Temurin JDK 8
        "temurin11"                         # Eclipse Temurin JDK 11
        "temurin17"                         # Eclipse Temurin JDK 17
        "temurin21"                         # Eclipse Temurin JDK 21
        "yasm"                              # Yet Another Assembler

        # ------------------------------------------------------------------
        # STEM and Engineering Packages
        # ------------------------------------------------------------------

        # Circuit Engineering:
        "kicad"                             # KiCad EDA Suite
        "logisim-evolution"                 # Digital logic circuit simulator

        # Math
        "coq --ignore-checksums"            # Coq proof assistant
        "free42"                            # Free42 HP-42S calculator simulator
        "gnuplot"                           # Gnuplot graphing utility
        "maxima"                            # Maxima computer algebra system
        "octave"                            # GNU Octave numerical computation software
        "qalculate"                         # Qalculate! advanced calculator
        "scilab"                            # Scilab numerical computation software
        "speedcrunch"                       # SpeedCrunch high-precision calculator

        # Modelling/3D:
        "blender"                           # Blender 3D modelling software
        # "librecad"                        # LibreCAD 2D CAD software
        # "magicavoxel"                     # MagicaVoxel 3D voxel editor
        "meshlab"                           # MeshLab 3D mesh processing software
        # "meshmixer"                       # Meshmixer 3D modelling software
        "openscad.install"                  # OpenSCAD 3D CAD modeller

        # ------------------------------------------------------------------
        # Multimedia Packages
        # ------------------------------------------------------------------

        # Audio Tools
        "audacity"                          # Audio editor
        "audacity-lame"                     # LAME MP3 encoder for Audacity
        "audacity-ffmpeg"                   # FFmpeg import/export library for Audacity
        # "equalizerapo"                    # System-wide audio equalizer. Download from: https://sourceforge.net/projects/equalizerapo/files/
        "foobar2000"                        # Advanced audio player
        "freeencoderpack"                   # Audio and video codec pack
        # "mp3directcut"                    # Fast audio editor and recorder for compressed MP3 files. Download from: https://mpesch3.de/
        # "roomeqwizard"                    # Room EQ Wizard (REW) acoustic measurement software. Download from: https://www.roomeqwizard.com/
        # "spotify"                         # Spotify music streaming client

        # Images:
        # "drawpile"                        # Collaborative drawing software
        # "fsviewer"                        # FastStone Image Viewer
        "gimp"                              # GIMP image editor
        "graphviz"                          # Graphviz graph visualization software
        "imagemagick"                       # ImageMagick image manipulation tools
        "inkscape"                          # Inkscape vector graphics editor
        "irfanview"                         # IrfanView image viewer
        "irfanviewplugins"                  # IrfanView plugins
        "krita"                             # Krita digital painting software
        "lunacy"                            # Lunacy graphic design software
        "paint.net"                         # Paint.NET image editor
        "pencil"                            # Pencil 2D animation software
        # "processing"                      # Processing programming environment
        "XnView"                            # XnView image viewer and converter

        # Video:
        "fraps"                             # FRAPS screen capture and benchmarking tool
        # "natron"                          # Natron node-based compositing software
        "obs-studio"                        # OBS Studio screen recording and streaming software
        "openshot"                          # OpenShot video editor
        # "opentoonz"                       # OpenToonz 2D animation software. Install from GitHub.
        "screentogif"                       # ScreenToGif screen recorder
        "shotcut.install"                   # Shotcut video editor
        "vlc"
    )

    foreach ($package in $packages)
    {
        choco install $package -y
    }

    # Post-Install:
    Write-Output 'nameserver 1.1.1.1' > $env:SystemRoot\System32\Drivers\etc\resolv.conf
    Write-Output 'nameserver 8.8.8.8' >> $env:SystemRoot\System32\Drivers\etc\resolv.conf

    # Accept SysInternals EULA
    New-Item -Path "HKCU:\Software\Sysinternals" -Name "EulaAccepted" -Value 1 -PropertyType DWORD -Force | Out-Null
}

# ==============================================================================================================
# Windows App Package (WAPP) management functions
# ==============================================================================================================

function Remove-WAPP
{
    if ($args.Count -ne 1)
    {
        Write-Host "Usage: rm-wapp <package_mask>"
    }
    else
    {
        Get-AppxPackage *$($args[0].ToString())* | Remove-AppxPackage
    }
}

function Get-WAPP
{
    if ($args.Count -ne 1)
    {
        Write-Host "Usage: get-wapp <package_mask>"
    }
    else
    {
        Get-AppxPackage *$($args[0].ToString())*
    }
}

function Install-WAPP
{
    Get-AppxPackage *$($args[0].ToString())* | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
}

function Install-WAPP-All
{
    Get-AppxPackage -AllUsers | ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" }
}

function Download-AppxPackage
{
    [CmdletBinding()]
    param (
        [string]$Uri,
        [string]$Path = "."
    )

    process
    {
        $Path = (Resolve-Path $Path).Path
        #Get Urls to download
        $WebResponse = Invoke-WebRequest -UseBasicParsing -Method 'POST' -Uri 'https://store.rg-adguard.net/api/GetFiles' -Body "type=url&url=$Uri&ring=Retail" -ContentType 'application/x-www-form-urlencoded'
        $LinksMatch = $WebResponse.Links | Where-Object { $_ -like '*.appx*' } | Where-Object { $_ -like '*_neutral_*' -or $_ -like "*_" + $env:PROCESSOR_ARCHITECTURE.Replace("AMD", "X").Replace("IA", "X") + "_*" } | Select-String -Pattern '(?<=a href=").+(?=" r)'
        $DownloadLinks = $LinksMatch.matches.value

        function Resolve-NameConflict
        {
            #Accepts Path to a FILE and changes it so there are no name conflicts
            param(
                [string]$Path
            )
            $newPath = $Path
            if (Test-Path $Path)
            {
                $i = 0;
                $item = (Get-Item $Path)
                while (Test-Path $newPath)
                {
                    $i += 1;
                    $newPath = Join-Path $item.DirectoryName ($item.BaseName + "($i)" + $item.Extension)
                }
            }
            return $newPath
        }
        #Download Urls
        foreach ($url in $DownloadLinks)
        {
            $FileRequest = Invoke-WebRequest -Uri $url -UseBasicParsing #-Method Head
            $FileName = ($FileRequest.Headers["Content-Disposition"] | Select-String -Pattern  '(?<=filename=).+').matches.value
            $FilePath = Join-Path $Path $FileName; $FilePath = Resolve-NameConflict($FilePath)
            [System.IO.File]::WriteAllBytes($FilePath, $FileRequest.content)
            Write-Output $FilePath
        }
    }
}
