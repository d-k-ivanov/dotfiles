#!/usr/bin/env bash

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# TODO: Refactor my CPP tempates before usage
# export CMAKE_GENERATOR="Ninja Multi-Config"
# export CMAKE_DEFAULT_BUILD_TYPE=Release

clang_format_all()
{
    find . -regex '.*\.\(cpp\|hpp\|cu\|c\|h\)' -exec clang-format -style=file -i {} \;
}
