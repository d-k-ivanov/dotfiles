#!/usr/bin/env bash

# TODO: Refactor my CPP tempates before usage
# export CMAKE_GENERATOR="Ninja Multi-Config"
# export CMAKE_DEFAULT_BUILD_TYPE=Release

clang_format_all()
{
    find . -regex '.*\.\(cpp\|hpp\|cu\|c\|h\)' -exec clang-format -style=file -i {} \;
}
