#!/usr/bin/env bash

platform=`uname`
if [ ! "${platform}" != "Darwin"  ]
then
    alias  lib_arch='lipo -info'
    alias  lib_object='otools -L'
    alias  lib_object_v='otools -Lv'
fi

alias show_opscodes_b='objdump -d /bin/* | cut -f3 | grep -oE "^[a-z]+" | sort | uniq -c'
alias show_opscodes_ub='objdump -d /usr/bin/* | cut -f3 | grep -oE "^[a-z]+" | sort | uniq -c'
alias show_opscodes_sb='objdump -d /sbin/* | cut -f3 | grep -oE "^[a-z]+" | sort | uniq -c'

alias gdb_py='gdb -ex r --args python'

function perf-profiling-enable {
    if [ -f /proc/sys/kernel/perf_event_paranoid ]; then
        echo 0 | sudo tee /proc/sys/kernel/perf_event_paranoid > /dev/null
    fi
    if [ -f /proc/sys/kernel/kptr_restrict ]; then
        echo 0 | sudo tee /proc/sys/kernel/kptr_restrict > /dev/null
    fi
}

function perf-profiling-disable {
    if [ -f /proc/sys/kernel/perf_event_paranoid ]; then
        echo 2 | sudo tee /proc/sys/kernel/perf_event_paranoid > /dev/null
    fi
    if [ -f /proc/sys/kernel/kptr_restrict ]; then
        echo 1 | sudo tee /proc/sys/kernel/kptr_restrict > /dev/null
    fi
}
