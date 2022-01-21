<#
.SYNOPSIS
Formatting scripts.

.DESCRIPTION
Formatting scripts.
#>

if (Get-Command clang-format -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:clang_format_cmd} = { cmd /c 'for /r %t in (*.cpp *.h) do clang-format -i -style=file %t' }
    ${function:clang_format_ps}  = { Get-ChildItem . -File -Recurse -Include  *.cpp,*.h | %{ clang-format -i -style=file $_.FullName } }
}

if (Get-Command tabspace -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:tabspace_general}     = { tabspace /leaveeol /ext:"bat;cpp;cxx;doxyfile;h;hpp;in;inl;js;json;md;props;ps1;py;qss;sh;txt" }
    ${function:tabspace_general_tab} = { tabspace /leaveeol /usetabs /ext:"bat;cpp;cxx;doxyfile;h;hpp;in;inl;js;json;md;props;ps1;py;qss;sh;txt" }
    ${function:tabspace_shaders} = { tabspace /ext:"vert;frag"}
}
