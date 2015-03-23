#!/bin/bash

set -e

file=/tmp/fileroller_test_file
arc=/tmp/fileroller_test_archive.tgz

trap 'rm -f $file $arc' STOP INT QUIT EXIT

dd if=/dev/urandom of=$file bs=1M count=1

file-roller -a $arc $file

