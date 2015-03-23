#!/bin/bash 

usage() {
	echo "Usage: $(basename $0) -d <display> -u <user>-- command [args]" >&2
	exit 1
}

user=""
display=""

while getopts "c:t:d:u:" opt; do
   case "$opt" in
	d) display=$OPTARG;;
	u) user=$OPTARG;;
	*) usage;;
	esac
done

shift $(($OPTIND - 1))

# set default user or display
# get current user logged on the X display
userdisplay=$(who | awk '{ if (substr($2,0,1)==":") printf("%s@%s",$1,$2); }')
def_user=$(cut -f1 -d'@' <<<$userdisplay)
def_display=$(cut -f2 -d'@' <<<$userdisplay)
if [ -z "$user" ]; then echo "Using default user $def_user" >&2; user=$def_user; fi
if [ -z "$display" ]; then echo "Using default display $def_display" >&2; display=$def_display; fi

if [ -z "$user" ]; then echo "$0: unable to find valid user" >&2; exit 1; fi
if [ -z "$display" ]; then echo "$0: unable to find valid display" >&2; exit 1; fi

if [ $# -eq 0 ]; then echo "$0: no command given." >&2; exit 1; fi

#*************************************************************************

# generate a script that launches the command in the appropriate environment
# the script will be executed as the target user

tempfile=$(mktemp /tmp/launch.XXXXXXX)

workdir=$(pwd -P)
workpath=$PATH

cat <<EOF >$tempfile
#!/bin/bash

export DISPLAY=$display

if [ -z "\$DBUS_SESSION_BUS_ADDRESS" ]; then
	# get address from gnome-session environment
	gspid=\$(pgrep -x gnome-session -u \$(id -un))
	if [ -n "\$gspid" ]; then
		echo "C: Trying to get DBUS address from gnome-session process \$gspid" >&2
		export DBUS_SESSION_BUS_ADDRESS=\$(tr '\0' '\n' </proc/\${gspid}/environ | grep ^DBUS_SESSION_BUS_ADDRESS | cut -f2- -d'=')
	fi

	# try to use already created session files
	if [ -z "\$DBUS_SESSION_BUS_ADDRESS" ]; then
		if [ -d \$HOME/.dbus/session-bus/ ]; then
			dbusfiles=\$(ls \$HOME/.dbus/session-bus/*-* | head -1)
			if [ -n "\$dbusfiles" ]; then
				echo "C: Trying to get DBUS address from \$dbusfiles" >&2
				. \$dbusfiles
			fi
		fi
	fi
fi

if [ -z "\$DBUS_SESSION_BUS_ADDRESS" ]; then
	echo "C: Unable to find existing dbus session" >&2
	exit 1
fi

echo "C: Using DBUS_SESSION_BUS_ADDRESS=\$DBUS_SESSION_BUS_ADDRESS" >&2

# copy PATH from parent
export PATH=$workpath

echo "C: Running as user \$(id -un) with display \$DISPLAY" >&2
echo "C: D-Bus session address: \$DBUS_SESSION_BUS_ADDRESS" >&2

echo "C: PATH=\$PATH" >&2

echo "C: Switching to dir $workdir" >&2
cd "$workdir"
echo "C: current dir: \$(pwd -P)" >&2

exec $@
EOF

# first: disable security on display
su - $user -c "DISPLAY=$display xhost +"

# ... and restore at exit
trap "echo 'P: Restoring X display access' >&2; rm -fv $tempfile; su - $user -c \"DISPLAY=$display xhost -\"" STOP INT QUIT EXIT

############################ exec step ############################

# default RC: failure
RC=1 

# this shell must have the target display to execute correctly
export DISPLAY=$display

# start command in bg
echo "P: Launching $@ as user $user on display $display from dir $workdir" >&2
chmod 777 $tempfile
su - $user -c $tempfile 


