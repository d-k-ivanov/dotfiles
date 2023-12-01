#!/usr/bin/env bash

startTime=$(date +%s)

build_triplet='x64-linux'

if [[ $(uname -s) == 'Darwin' ]]; then
    build_triplet='x64-osx'
fi

if [ ! -z "$2" ]; then
    build_triplet="$2"
fi

output_dir="${HOME}/vcpkg/dev"

# The name of file with list of libraries to install:
vcpkg_library_list="cc-required-libs-linux.txt"
if [ ! -z "$3" ]; then
    vcpkg_library_list="$3"
fi

[ ! -f .vcpkg-root ] && exit 1

rm -f ./vcpkg
./bootstrap-vcpkg.sh -disableMetrics || exit 1

current_hash=$(cat vcpkg_hash)
[ -z "$current_hash" ] && current_hash=$(git rev-parse @)
# Here we determine if there have been any changes since the last build

if [[ -f "${output_dir}/repo-git-hash.txt" ]]; then
    old_hash="$(cat "${output_dir}/repo-git-hash.txt")"
else
    old_hash=""
fi

# if [[ "${old_hash}" == "${current_hash}" ]]; then
# 	echo "Dependencies are up to date! To force export, delete the export dir '${output_dir}'";
# 	exit 0;
# fi
# echo "vcpkg hash changed from '${old_hash}' to '${current_hash}'; will rebuild/re-export..."
echo "vcpkg old hash: '${old_hash}'"
echo "vcpkg current hash: '${old_hash}'"

libs=$(cat ${vcpkg_library_list})
libs_no_features=${libs//\[contrib\]/}
# rm -rf buildtrees
# rm -rf installed
# rm -rf vcpkg-export-latest

echo ================================================================================
echo =============== Cleaning up
echo ================================================================================
# Remove old build and export folder
build_dir="$(realpath "${PWD}/../build")"
rm -rf "${build_dir}"
rm -rf "${output_dir}"

# Uncomment this section to remove currently installed libraries
if [ "${1}" == "force" ]; then
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

echo ================================================================================
echo ======================== INSTALL COMPLETE ==================================
echo ================================================================================
echo Exporting to "${output_dir}"
echo --------------------------------------------------------------------------------
echo ./vcpkg export --raw --triplet ${build_triplet} --output="${output_dir}" ${libs_no_features}

if [[ $? != 0 ]]; then
    echo "Error while exporting libs"
    exit 1
fi

printf "${current_hash}" >"${output_dir}/repo-git-hash.txt"

endTime=$(date +%s)
elapsedTime=$((endTime - startTime))
eHours=$((elapsedTime / 3600))
eMinutes=$(((elapsedTime - eHours * 3600) / 60))
eSeconds=$((elapsedTime % 60))

echo "Elapsed time: $((eHours))h $((eMinutes))m $((eSeconds))s"
