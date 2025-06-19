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

function Install-LibTorch
{
    $torch_versions = @(
        "2.5.0",
        "2.5.1",
        "2.6.0",
        "2.7.1"
    )

    $selectedTorch = Select-From-List $torch_versions 'PyTorch version'

    $compute_platforms = @(
      "cpu"
      "cu118"
      "cu121"
      "cu124"
      "cu128"
    )

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
    [Environment]::SetEnvironmentVariable("LIBTORCH", $null, "Machine")
    if ($env:LIBTORCH)
    {
        Remove-Item Env:LIBTORCH
    }

    [Environment]::SetEnvironmentVariable("LIBTORCH_DIR", $null, "Machine")
    if ($env:LIBTORCH_DIR)
    {
        Remove-Item Env:LIBTORCH_DIR
    }
}
