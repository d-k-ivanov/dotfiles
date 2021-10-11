<#
.SYNOPSIS
CPP Dev scripts.

.DESCRIPTION
CPP Dev scripts.
#>

# TODO: Refactor my CPP tempates before usage
# $Env:CMAKE_GENERATOR = 'Ninja Multi-Config'
# $Env:CMAKE_DEFAULT_BUILD_TYPE = 'Release'

if (Get-Command clang-format -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:clang_format_cmd} = { cmd /c 'for /r %t in (*.cpp *.h) do clang-format -i -style=file %t' }
    ${function:clang_format_ps}  = { Get-ChildItem . -File -Recurse -Include  *.cpp,*.h | %{ clang-format -i -style=file $_.FullName } }
}
