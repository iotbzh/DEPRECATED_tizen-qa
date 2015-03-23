#!/bin/bash

# Copyright (c) 2013 Intel Corporation. All rights reserved.
# Use of this source code is governed by a LGPL v2.1 license that can be
# found in the LICENSE file in the db directory.
# Author : Ewan le Bideau Canevet <ewan.lebideau-canevet@open.eurogiciel.org>

FILE=$1
chsmack -a _  ../gst.sh
cp $FILE ~guest
chsmack -a _ ~guest/$FILE

