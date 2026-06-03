<#
.SYNOPSIS
FPGA scripts.

.DESCRIPTION
FPGA scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    exit
}

function vitis-install-paths
{
    $potentialRoots = @(
        'C:\Xilinx',
        'C:\AMDDesignToolls',
        'D:\Xilinx',
        'D:\AMDDesignToolls'
    )
    $vitisInstallPaths = @()
    foreach ($root in $potentialRoots)
    {
        if (Test-Path -Path $root)
        {
            $vitisDirs = Get-ChildItem -Path $root -Directory -Filter '202*' -ErrorAction SilentlyContinue
            foreach ($dir in $vitisDirs)
            {
                $vitisPath = Join-Path -Path $dir.FullName -ChildPath 'Vitis'
                if (Test-Path -Path $vitisPath)
                {
                    $vitisInstallPaths += $dir.FullName
                }
            }
        }
    }

    return $vitisInstallPaths
}

function vitis-select
{
    return Select-From-List $(vitis-install-paths) "Vitis Version" $Versions
}

function vitis-env-invoke
{
    $ChoosenVersion = vitis-select
    $InstallRoot = $ChoosenVersion
    $ToolsRoot = Split-Path -Path $InstallRoot  -Parent

    # --- Power Design Manager (PDM) ---
    $env:Path = "$InstallRoot\PDM\bin;$env:Path"

    # --- Vitis / HLS ---
    $vitisBin = @(
        "$InstallRoot\Vitis\bin"
        "$InstallRoot\Vitis\gnu\microblaze\nt\bin"
        "$InstallRoot\Vitis\gnu\microblaze\linux_toolchain\nt64_le\bin"
        "$InstallRoot\Vitis\gnu\aarch32\nt\gcc-arm-linux-gnueabi\bin"
        "$InstallRoot\Vitis\gnu\aarch32\nt\gcc-arm-none-eabi\bin"
        "$InstallRoot\Vitis\gnu\aarch64\nt\aarch64-linux\bin"
        "$InstallRoot\Vitis\gnu\aarch64\nt\aarch64-none\bin"
        "$InstallRoot\Vitis\gnu\armr5\nt\gcc-arm-none-eabi\bin"
        "$InstallRoot\Vitis\gnuwin\bin"
        "$InstallRoot\Vitis\gnu\riscv\nt\bin"
        "$InstallRoot\Vitis\gnu\riscv\linux_toolchain\nt32\bin"
        "$InstallRoot\Vitis\gnu\riscv\linux_toolchain\nt64\bin"
    ) -join ';'

    $env:Path = "$vitisBin;$env:Path"
    $env:XILINX_VITIS = "$InstallRoot\Vitis"
    $env:RDI_PLATFORM = 'win64'
    $env:XILINX_HLS = "$InstallRoot\Vitis"

    # --- Vivado ---
    $env:Path = "$InstallRoot\Vivado\bin;$InstallRoot\Vivado\lib\win64.o;$env:Path"
    $env:XILINX_VIVADO = "$InstallRoot\Vivado"

    # --- Model Composer ---
    $env:Path = "$InstallRoot\Model_Composer\bin;$env:Path"

    # --- DocNav ---
    $env:Path = "$ToolsRoot\DocNav;$env:Path"

    Write-Verbose "AMD 2025.2 environment initialized (Vitis, Vivado, PDM, Model Composer, DocNav)."
}
Set-Alias -Name vitis-env -Value vitis-env-invoke

function vitis-env-cleanup
{
    # Remove Vitis-related paths from PATH
    $pathsToRemove = @(
        'PDM\bin',
        'Vitis\bin',
        'Vitis\gnu\microblaze\nt\bin',
        'Vitis\gnu\microblaze\linux_toolchain\nt64_le\bin',
        'Vitis\gnu\aarch32\nt\gcc-arm-linux-gnueabi\bin',
        'Vitis\gnu\aarch32\nt\gcc-arm-none-eabi\bin',
        'Vitis\gnu\aarch64\nt\aarch64-linux\bin',
        'Vitis\gnu\aarch64\nt\aarch64-none\bin',
        'Vitis\gnu\armr5\nt\gcc-arm-none-eabi\bin',
        'Vitis\gnuwin\bin',
        'Vitis\gnu\riscv\nt\bin',
        'Vitis\gnu\riscv\linux_toolchain\nt32\bin',
        'Vitis\gnu\riscv\linux_toolchain\nt64\bin',
        'Vivado\bin',
        'Vivado\lib\win64.o',
        'Model_Composer\bin'
    )

    foreach ($path in $pathsToRemove)
    {
        $env:Path = (($env:Path -split ';') | Where-Object { $_ -notlike "*$path*" }) -join ';'
    }

    # Unset environment variables
    Remove-Item Env:XILINX_VITIS -ErrorAction SilentlyContinue
    Remove-Item Env:RDI_PLATFORM -ErrorAction SilentlyContinue
    Remove-Item Env:XILINX_HLS -ErrorAction SilentlyContinue
    Remove-Item Env:XILINX_VIVADO -ErrorAction SilentlyContinue

    Write-Verbose "AMD 2025.2 environment cleaned up."
}
