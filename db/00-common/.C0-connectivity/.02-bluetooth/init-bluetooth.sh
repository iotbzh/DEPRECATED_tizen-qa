#!/bin/bash

systemctl restart bluetooth.service
sleep 2
hciconfig hci0 up
zypper ref
zypper -n in -f bluez-test
#chsmack -a _  connect.sh

