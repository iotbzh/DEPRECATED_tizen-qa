#!/bin/bash
function removeall()
{
	local list=$(/usr/lib64/bluez/test/test-device list | awk '{print $1}')
	for device in $list
	do
		/usr/lib64/bluez/test/test-device remove $device
	done
}

ADDRESS=$1

if [[ -z $(hcitool dev | sed -n '2p') ]]
then
	echo "======== BLUETOOTH DEVICE NOT FOUND ========"
	exit 1
fi

echo $(/usr/lib64/bluez/test/test-device list)
/usr/lib64/bluez/test/test-adapter powered on
/usr/lib64/bluez/test/test-adapter pairable on
/usr/lib64/bluez/test/test-adapter pairabletimeout 720
/usr/lib64/bluez/test/test-adapter discoverable on

echo ">>> Printing config :"
/usr/lib64/bluez/test/test-adapter list
echo "==========================================="

DISCOVERY=/usr/lib64/bluez/test/test-discovery
$DISCOVERY &
PID=$!

sleep 30;
kill -9 $PID

echo ">>> Trying to establish connection to $1"
/usr/lib64/bluez/test/test-device connect $1

cmd=$(hcitool con)

if [[ $cmd == *$1*"AUTH ENCRYPT"* ]]
then
	echo "... connection succeeed"
	sleep 5
	echo $cmd
else
	echo "... connection failed"
	echo $cmd
	removeall
	exit 1
fi

echo ">>> Trying to disconnect to $1"
/usr/lib64/bluez/test/test-device disconnect $1
sleep 5
cmd=$(hcitool con)

if [[ $cmd == *$1*"AUTH ENCRYPT"* ]]
then 
	echo "... disconnection failed !"
	removeall
	exit 1
else
	echo "... disconnection succeed"
	removeall
fi


