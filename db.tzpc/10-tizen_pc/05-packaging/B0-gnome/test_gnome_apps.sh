#!/bin/bash 

set -e
set -x

file="$(dirname $0)/packages.lst"
file="packages.lst"

grep -v '#' "$file" | sort | uniq  | grep -v '^$' | while read pkg ; do
    echo "================= $pkg ================" >&2
    
    exe="${pkg}"

    zypper -q search ${pkg} || echo "ignored for now"

    yes | sudo zypper in ${pkg} || echo "ignored for now"
    
    which ${exe}
    
    ldd $(which ${exe} )
    
    ${exe} --version 

    ${exe} &
    
    sleep 10

    killall ${exe} || echo "ignored for now"
    
    echo "TODO:   yes | zypper rm ${pkg}"
done
