#!/bin/bash

set -e

arcdir=/tmp/test_file_roller

mkdir -p $arcdir

trap 'rm -rf $arcdir' STOP INT QUIT EXIT

file-roller --extract-to=$arcdir test_file_roller.tgz

