#!/usr/bin/env bash

startTime=$(date +%s)

build_triplet='x64-linux'

if [[ $(uname -s) == 'Darwin' ]]; then
    build_triplet='x64-osx'
fi

if [ ! -z "$2" ]; then
    build_triplet="$2"
fi

# The name of file with list of libraries to install:
script_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
vcpkg_library_list="${script_path}/vcpkg-packages.txt"
if [ ! -z "$3" ]; then
    vcpkg_library_list="$3"
fi

[ ! -f .vcpkg-root ] && exit 1

rm -f ./vcpkg
./bootstrap-vcpkg.sh -disableMetrics || exit 1

current_hash=$(cat vcpkg_hash)
[ -z "$current_hash" ] && current_hash=$(git rev-parse @)
# Here we determine if there have been any changes since the last build

libs=$(cat ${vcpkg_library_list})
libs_no_features=${libs//\[contrib\]/}
# rm -rf buildtrees
# rm -rf installed
# rm -rf vcpkg-export-latest

if [ "${1}" == "force" ]; then
    echo ================================================================================
    echo =============== Cleaning up
    echo ================================================================================
    echo vcpkg remove --triplet ${build_triplet} ${libs_no_features}
    ./vcpkg remove --recurse --triplet ${build_triplet} ${libs_no_features}
fi

if [[ $? != 0 ]]; then
    echo "Error while removing libs"
    exit 1
fi

echo ================================================================================
echo =============== Building triplet: ${build_triplet}
echo ================================================================================
echo vcpkg install --keep-going --triplet ${build_triplet} ${libs}
./vcpkg install --keep-going --triplet ${build_triplet} ${libs}

if [[ $? != 0 ]]; then
    echo "Error while installing libs"
    exit 1
fi

endTime=$(date +%s)
elapsedTime=$((endTime - startTime))
eHours=$((elapsedTime / 3600))
eMinutes=$(((elapsedTime - eHours * 3600) / 60))
eSeconds=$((elapsedTime % 60))

echo "Elapsed time: $((eHours))h $((eMinutes))m $((eSeconds))s"
