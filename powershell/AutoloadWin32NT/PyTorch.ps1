<#
.SYNOPSIS
PyTorch scripts.

.DESCRIPTION
PyTorch scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

# Package lists:
# https://download.pytorch.org/libtorch/cpu/
# https://download.pytorch.org/libtorch/cu118/
# https://download.pytorch.org/libtorch/cu121/
# https://download.pytorch.org/libtorch/cu124/
# https://download.pytorch.org/libtorch/cu126/
# https://download.pytorch.org/libtorch/cu128/
# https://download.pytorch.org/libtorch/cu130/
# https://download.pytorch.org/libtorch/cu132/
# https://download.pytorch.org/libtorch/rocm6.1/
# https://download.pytorch.org/libtorch/rocm6.2/
# https://download.pytorch.org/libtorch/rocm6.3/
function Install-LibTorch
{
    $torch_versions = @(
        "2.4.0",
        "2.4.1",
        "2.5.0",
        "2.5.1",
        "2.6.0",
        "2.7.1",
        "2.8.0",
        "2.9.0",
        "2.9.1",
        "2.10.0",
        "2.11.0",
        "2.12.0"
    )

    $selectedTorch = Select-From-List $torch_versions 'PyTorch version'

    # Supported platforms by version:
    # cpu: 2.4.0, 2.4.1, 2.5.0, 2.5.1, 2.6.0, 2.7.1, 2.8.0, 2.9.0, 2.9.1, 2.10.0, 2.11.0, 2.12.0
    # cu118: 2.4.0, 2.4.1, 2.5.0, 2.5.1, 2.6.0, 2.7.1
    # cu121: 2.4.0, 2.4.1, 2.5.0, 2.5.1
    # cu124: 2.4.0, 2.4.1, 2.5.0, 2.5.1, 2.6.0
    # cu126: 2.6.0, 2.7.1, 2.8.0, 2.9.0, 2.9.1, 2.10.0, 2.11.0, 2.12.0
    # cu128: 2.7.1, 2.8.0, 2.9.0, 2.9.1, 2.10.0, 2.11.0, 2.12.0
    # cu130: 2.9.0, 2.9.1, 2.10.0, 2.11.0, 2.12.0
    # cu132: 2.12.0
        $compute_platforms = @("cpu")
        switch ($selectedTorch)
        {
                "2.4.0"  { $compute_platforms += @("cu118", "cu121", "cu124") }
                "2.4.1"  { $compute_platforms += @("cu118", "cu121", "cu124") }
                "2.5.0"  { $compute_platforms += @("cu118", "cu121", "cu124") }
                "2.5.1"  { $compute_platforms += @("cu118", "cu121", "cu124") }
                "2.6.0"  { $compute_platforms += @("cu118", "cu124", "cu126") }
                "2.7.1"  { $compute_platforms += @("cu118", "cu126", "cu128") }
                "2.8.0"  { $compute_platforms += @("cu126", "cu128")          }
                "2.9.0"  { $compute_platforms += @("cu126", "cu128", "cu130") }
                "2.9.1"  { $compute_platforms += @("cu126", "cu128", "cu130") }
                "2.10.0" { $compute_platforms += @("cu126", "cu128", "cu130") }
                "2.11.0" { $compute_platforms += @("cu126", "cu128", "cu130") }
                "2.12.0" { $compute_platforms += @("cu126", "cu128", "cu130", "cu132") }
        }

    $selectedPlatform = Select-From-List $compute_platforms 'Computing platform'

    $opt_path = 'C:\opt'
    If (-Not (Test-Path -PathType container ${opt_path}))
    {
      New-Item -ItemType Directory -Path ${opt_path}
    }

    $torch_url = "https://download.pytorch.org/libtorch/${selectedPlatform}/libtorch-win-shared-with-deps-${selectedTorch}%2B${selectedPlatform}.zip"
    $torch_zip = "${opt_path}\libtorch-win-shared-with-deps-${selectedTorch}+${selectedPlatform}.zip"
    $torch_dir = "${opt_path}\libtorch-${selectedTorch}+${selectedPlatform}"

    Write-Host "Downloading ${torch_url}"
    wget.exe -O "${torch_zip}" "${torch_url}"

    Write-Host "Extracting ${torch_zip}"
    7z.exe x "${torch_zip}" -o"${opt_path}"

    Write-Host "Moving ${opt_path}\libtorch to ${torch_dir}"
    Move-Item -Path "${opt_path}\libtorch" -Destination ${torch_dir}

    Write-Host "Removing ${torch_zip}"
    Remove-Item -Force "${torch_zip}"
}

function Set-LibTorch
{
    $selected = Select-From-List $((Get-ChildItem "C:\opt"-Filter "*libtorch*" -Directory).FullName) 'LibTorch'
    [Environment]::SetEnvironmentVariable("LIBTORCH", $selected, "Machine")
    [Environment]::SetEnvironmentVariable("LIBTORCH_DIR", $selected, "Machine")
    Set-Item -Path Env:LIBTORCH -Value "$selected"
    Set-Item -Path Env:LIBTORCH_DIR -Value "$selected"
}

function Clear-LibTorch
{
    [Environment]::SetEnvironmentVariable("LIBTORCH", [NullString]::Value, "Machine")
    if ($env:LIBTORCH)
    {
        Remove-Item Env:LIBTORCH
    }

    [Environment]::SetEnvironmentVariable("LIBTORCH_DIR", [NullString]::Value, "Machine")
    if ($env:LIBTORCH_DIR)
    {
        Remove-Item Env:LIBTORCH_DIR
    }
}
