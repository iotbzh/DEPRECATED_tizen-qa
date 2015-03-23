#!/bin/bash

wgtname=memorygame
wgtdb=/home/guest/.applications/dbspace/.app_info.db
wgtfullname=$wgtname.wgt
#wgtfullname=$(realpath $wgtname.wgt)
wgtpid=ttMvx9BNP4
wgtappid=$wgtpid.$wgtname

function install_wgt() {
	cp $wgtfullname ~guest
	
	echo "Trying to install widget $wgtfullname..."
	su - guest -c "export DBUS_SESSION_BUS_ADDRESS=\"unix:path=/run/user/9999/dbus/user_bus_socket\"; export XDG_RUNTIME_DIR=\"/run/user/9999\"; timeout 5 pkgcmd -i -t wgt -q -p $wgtfullname"
	if [ -n "$(sqlite3 $wgtdb "select x_slp_appid from app_info where name=\"$wgtname\"")" ]; then
		echo "application successfully installed - Ok"
	else
		echo "application cannot be installed !"
		exit 1
	fi
}

function launch_wgt() {
	su - guest -c "export DBUS_SESSION_BUS_ADDRESS=\"unix:path=/run/user/9999/dbus/user_bus_socket\"; export XDG_RUNTIME_DIR=\"/run/user/9999\"; systemctl restart --user xwalk.service; app_launcher -s $wgtappid"
	sleep 5
	if [ -n "$(app_launcher -S | sed -n '2p')" ]; then
		echo "application successfully launched - Ok"
		su - guest -c "export DBUS_SESSION_BUS_ADDRESS=\"unix:path=/run/user/9999/dbus/user_bus_socket\"; export XDG_RUNTIME_DIR=\"/run/user/9999\"; app_launcher -k $wgtappid"
	else
		echo "application cannot be launched !"
		exit 1
	fi
}

function uninstall_wgt() {
	su - guest -c "export DBUS_SESSION_BUS_ADDRESS=\"unix:path=/run/user/9999/dbus/user_bus_socket\"; export XDG_RUNTIME_DIR=\"/run/user/9999\"; timeout 5 pkgcmd -u -q -n $wgtpid"
	if [ -z  "$(sqlite3 $wgtdb "select x_slp_appid from app_info where name=\"$wgtname\"")" ]; then
		echo "application successfully uninstalled - Ok"
	else
		echo "application cannot be uninstalled !"
		exit 1
	fi		
}

case "$1" in
	install) install_wgt;;
	launch) launch_wgt;;
	uninstall) uninstall_wgt;;
	*) echo "command not supported";;
esac
