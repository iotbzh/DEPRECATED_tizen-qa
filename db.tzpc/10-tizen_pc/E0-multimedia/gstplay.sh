#!/bin/bash

[[ "$#" = 2 ]] || { echo "BAD ARGUMENTS" >&2; exit 2; }
case $1 in
 -f) uri="file://$(pwd)/$2";;
 -h) [[ -n "$QA_HTTP_BASEURL" ]] || { echo "BAD ENV: QA_HTTP_BASEURL is missing" >&2; exit 3; }
    uri="$QA_HTTP_BASEURL/$2";;
 -r) [[ -n "$QA_RTSP_BASEURL" ]] || { echo "BAD ENV: QA_RTSP_BASEURL is missing" >&2; exit 3; }
    uri="$QA_RTSP_BASEURL/$2";;
 *)  { echo "BAD OPTION" >&2; exit 4; };;
esac

for x in gst-launch gst-launch-1.0
do
	command=$(type -p $x) && [[ -x $command ]] && break
	command=
done
[[ -z "$command" ]] && { echo "GST-LAUNCH not found"; exit 4; }

result=$(cat <<EOC | qa-within-gnome.sh -s 2>&1
. qa-commons.sh
{ sleep 1; qa_proc_stat_begin; } &
$command -q playbin "uri=$uri"
qa_proc_stat_end
EOC
)
echo "$result" >&2

if grep -q ERROR <<<"$result"; then
	echo "ERROR when playing ${ext^^*} format uri=$uri"
	exit 1
fi

echo "SUCCESS when playing ${ext^^*} format uri=$uri"
. qa-commons.sh
qa_measure idle $(qa_proc_stat_get idle) % 0 0 0
exit 0

