# File to be sourced into bash scripts.
# Contains helper functions

usage() {
	cat >&2 <<EOC
Usage: $(basename $0) [OPTIONS]... [command [args]...]

Execute the command (or the stream, see -s option) with environment
given by the process of the given pid (see option -p) with the
given user id (see otpion -u). When a command is given and the stream
is also selected, the command is executed first.

Options:
    -u user	tells what user to use (by default it is the same as the process)
    -p pid	pid of the process to use (by default the one of the first 
		process encountered within: gnome-shell tizen-shell gnome-session)
    -d dir	tell to set the directory for execution (default is current PWD)
    -P path	path to prepend to PATH (default is \$QAPATH if exists)
    -s		stream the commands from the input 

EOC
	exit 1
}

# for errors
error() {
	echo "$0: $*" >&2
	exit 1
}

# for getting a pid
scanpids() {
	local p
	for p; do
		if [[ -z "${p//[0-9]/}" ]]; then
			# numeric pid
			if [[ -d /proc/$p && -r /proc/$p/environ ]]; then
				echo $p
				return 0
			fi
		else
			# process name
			if scanpids $(pgrep -x "$p"); then
				return 0
			fi
		fi
	done
	return 1
}

# scan the options
user=""
pids=""
path="$QAPATH"
dir=$(pwd)
stream=false

while getopts "u:p:d:P:s" opt; do
   case "$opt" in
	p) pids=$OPTARG;;
	u) user=$OPTARG;;
	d) dir=$OPTARG;;
	P) path=$OPTARG;;
	s) stream=:;;
	*) usage;;
	esac
done

shift $(($OPTIND - 1))
[[ $# -eq 0 ]] && stream=:

# get the directory
if [[ -n "$dir" ]]; then
	[[ -d "$dir" ]] || error "invalid directory $dir"
	dir="cd $dir"
fi

# get the pid
[[ -z "$pids" ]] && pids="gnome-shell tizen-shell gnome-session"
pid=$(scanpids $pids) || error "invalid pid $pids"

# get the environment
env="$({ printf "\0"; cat /proc/$pid/environ; } |
	sed -e 's/"/\\"/g' -e 's/\x00\([^=]*\)=/"\nexport \1="/g' |
	tr -d '\0' | tail +2 |
	grep -v 'PROFILEREAD' )\""

# get the user
[[ -z "$user" ]] && user=$(stat -c %U /proc/$pid)

# get the command
cmd="$*"

# get the path
[[ -n "$path" ]] && path="export PATH=$path:\$PATH"

# execute now
{
cat <<EOC 
$env
$path
$dir
$cmd
EOC
$stream && cat
} | 
su - "$user" 


