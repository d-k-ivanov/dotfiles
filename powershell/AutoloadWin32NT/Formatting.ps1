<#
.SYNOPSIS
Formatting scripts.

.DESCRIPTION
Formatting scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    exit
}

if (Get-Command clang-format -ErrorAction SilentlyContinue | Test-Path)
{
    function clang_format
    {
        param
        (
            [Parameter(Position = 0)]
            [string] $Path = '.'
        )

        $extensions = @(
            '*.c', '*.cc', '*.cpp', '*.cxx', '*.c++', '*.cp',
            '*.h', '*.hh', '*.hpp', '*.hxx', '*.h++', '*.hp',
            '*.inl', '*.inc', '*.ipp', '*.tpp', '*.tcc', '*.txx',
            '*.cu', '*.cuh'
        )

        Get-ChildItem $Path -File -Recurse -Include $extensions | % { clang-format -i -style=file $_.FullName }
    }

    ${function:clang_format_cmd} = { cmd /c 'for /r %t in (*.cpp *.cxx *.h *.hpp) do clang-format -i -style=file %t' }
}

if (Get-Command tabspace -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:tabspace_py} = { tabspace /leaveeol /ext:"py" }
    ${function:tabspace_cpp} = { tabspace /leaveeol /ext:"cpp;cxx;h;hpp;inl" }
    ${function:tabspace_cpp_tab} = { tabspace /leaveeol /usetabs /ext:"cpp;cxx;h;hpp;inl" }
    ${function:tabspace_shaders} = { tabspace /leaveeol /ext:"vert;frag" }
    ${function:tabspace_shaders_tab} = { tabspace /leaveeol /usetabs /ext:"vert;frag" }
    ${function:tabspace_general} = { tabspace /leaveeol /ext:"bat;cpp;cxx;doxyfile;h;hpp;in;inl;js;json;md;props;ps1;py;qss;sh;txt" }
    ${function:tabspace_general_tab} = { tabspace /leaveeol /usetabs /ext:"bat;cpp;cxx;doxyfile;h;hpp;in;inl;js;json;md;props;ps1;qss;sh;txt" }
}
