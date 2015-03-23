function loginfo() {
	echo "$@" >&2
}

function get_snapshotid() {
	local XMLSTARLET=$(which xml || which xmlstarlet)
	[[ -z "$XMLSTARLET" ]] && { loginfo "Please install xmlstarlet: zypper in xml"; exit 1; }

	[[ ! -f $1/repodata/repomd.xml ]] && { loginfo "Unable to find $1/repodata/repomd.xml"; exit 1; }

	local ts=$(cat $1/repodata/repomd.xml | $XMLSTARLET sel -N r=http://linux.duke.edu/metadata/repo -t -v "/r:repomd/r:revision/text()" 2>/dev/null)
	[[ -z "$ts" ]] && { loginfo "Unable to find source repo timestamp"; exit 1; }

	echo $(date +%Y%m%d.%H%M -d "@$ts")
}


