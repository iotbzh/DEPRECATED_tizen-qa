# File to be sourced into bash scripts.
# Contains helper functions

# function to emit a note
qa_note() { echo "###[NOTE]###$*"; }

# function to emit a measure: name value unit target failure power
qa_measure() { echo "###[MEASURE]###$1:$2:$3:$4:$5:$6"; }

# function to cancel the screen saver
qa_cancel_screensaver() {
    gsettings set org.gnome.desktop.screensaver idle-activation-enabled false
    gsettings set org.gnome.desktop.screensaver lock-enabled false
}

# function to lock the screen
qa_lock_screen() {
    dbus-send --print-reply --dest=org.gnome.ScreenSaver / org.gnome.ScreenSaver.SetActive boolean:true > /dev/null
}

# function to unlock the screen
qa_unlock_screen() {
    dbus-send --print-reply --dest=org.gnome.ScreenSaver / org.gnome.ScreenSaver.SetActive boolean:false > /dev/null
}

# function to set the brightness
# usage: qa_set_brightness value
# where value is raw (ex: value=1000) or in NIT (cd/m/m) (ex: value=200NIT) or in percent (ex: value=50%)
qa_set_brightness() {
    local val=$1 max mnit
    for dir in /sys/class/backlight/*
    do
	[[ 'raw' = $(cat $dir/type) ]] && break
    done
    max=$(cat $dir/max_brightness)
    case $val in
	*NIT) 
	    case $(uname -n) in
		lenovo*) mnit=300;;
		hp*) mnit=250;;
		*) mnit=250;;
	    esac
	    val=${val%NIT}
	    val=$(expr \( $val \* $max \) / $mnit);;
	*%)
	    val=${val%\%}
	    val=$(expr \( $val \* $max \) / 100);;
    esac
    echo $val > $dir/brightness
}

# records /proc/stat into /tmp/stat-beg-${1:-default}
qa_proc_stat_begin() {
	cp -f /proc/stat "/tmp/stat-beg-${1:-default}"
}

# records into the file /tmp/stat-${1:-default}${2}
# the significant differences between the current /proc/stat
# and /tmp/stat-beg-${1:-default} 
# see also qa_proc_stat_begin
qa_proc_stat_end() {
	paste /proc/stat "/tmp/stat-beg-${1:-default}" |
	awk '!($1~/cpu[0-9]/ || $1~/procs_/ || $1=="btime") { 
		s = 0 ; n = NF/2
		for (i=2 ; i<=n ; i++) { $i -= $(i+n); s+=$i }
		if ($1=="processes") $2-=2
		else if ($1=="intr") n=2
		else if ($1=="cpu") $(++n)=s
		NF = n
		print
	}' > "/tmp/stat-${1:-default}${2}"
}

# get the indicator $1 from the file /tmp/stat-${2:-default}${3}
# the indicator is idle, intr, ctxt, processes
# see also qa_proc_stat_begin, qa_proc_stat_end
qa_proc_stat_get() {
        local script=
	case $1 in
		idle) script='$1=="cpu"{printf "%5.2f\n",100*$5/$NF}' ;;
		*) script='$1=="'$1'"{print $2}' ;;
        esac
	awk "$script" "/tmp/stat-${2:-default}${3}"
}

