#!/bin/bash 

usage() {
	echo "Usage: $(basename $0) [-u <user>] pgrep_pattern" >&2
	exit 1
}

user=""

while getopts "c:t:d:u:" opt; do
   case "$opt" in
	u) user=$OPTARG;;
	*) usage;;
	esac
done

shift $(($OPTIND - 1))

# set default user
# get current user logged on the X display
userdisplay=$(who | awk '{ if (substr($2,0,1)==":") printf("%s@%s",$1,$2); }')
def_user=$(cut -f1 -d'@' <<<$userdisplay)
if [ -z "$user" ]; then echo "Using default user $def_user" >&2; user=$def_user; fi

if [ -z "$user" ]; then echo "$0: unable to find valid user" >&2; exit 1; fi

if [ $# -eq 0 ]; then echo "$0: no command given." >&2; exit 1; fi

echo "Searching for process $@ owned by user $user" >&2
pgrep -u $user $@

