#!/bin/bash

# this script is downloaded on the target device and is responsible for flashing the image locally
# arguments:
# - imgurl: the http url to download raw image
# - evturl: the http url to call for reporting flash success or failure

set -e 

exec >/dev/tty1 2>&1

echo "******************** FLASHING DEVICE ************************" >&2

imgurl=$1
evturl=$2

fb_sent=0
function send_feedback() {
    if [ $fb_sent -eq 0 ]; then
	echo "Sending feedback: $1"
	wget --quiet -O - $evturl/$1
	fb_sent=1
    else
	echo "Feedback already sent"
    fi
}

# send feedback if and error is trapped
trap 'send_feedback 127' ERR

# find first non-removable block device 
#for i in `ls /sys/block/*/device/model `; do 
#	dev=$(echo $i | cut -d'/' -f-4) ; 
#	outdev=$(echo $i | cut -d'/' -f4)
#	grep -q 1 $dev/removable || outdev="/dev/$outdev";   
#	break
#done

# find first non-removable block device 
for i in `ls -d /sys/block/*/device `; do 
	dev=$(echo $i | cut -d'/' -f-4) ; 
	outdev=$(echo $i | cut -d'/' -f4)
	grep -q 1 $dev/removable || outdev="/dev/$outdev"; break
done

# could be used also to find block device (but doesn't skip removables)
#outdev=/dev/$(ls /sys/block/ | grep ^sd | sort | head -1)

if [ ! -b $outdev ]; then
	echo "Invalid target device $outdev" >&2
	send_feedback 1
	exit 1
fi

# for LZO compressed images:
wget  -O - "$imgurl" | lzop -d -c | buffer -z 512k -m 32m -p 75 -o $outdev

# for XZ compressed images:
#wget --quiet -O - "$imgurl" | xz -d -c | buffer -s 256k -m 16m -o $outdev

# for non compressed images
#wget --quiet -O - "$imgurl" | buffer -s 256k -m 16m -o $outdev


RESIZEFS=no
case $outdev in
	mmcblk*)
	   RESIZEFS=no
	   ;;
	sd*)
	   RESIZEFS=yes
	   ;;
	*)
       ;;
esac

if [ "$RESIZEFS" = "yes" ]; then
	# resize first partition
	# WARNING: this only works if the system is installed on a single partition
	newsz=20 # GB
	partition=1
	sfdisk -d $outdev | 
	awk '$1=="'${outdev}${partition}'" { sub("size=[^,]+","size="'${newsz}'*1024*1024*2)}1' >/tmp/newpart.lst
	sfdisk $outdev </tmp/newpart.lst || true
	echo "Partition ${outdev}${partition} resized to $newsz GB"

	# force kernel to reread partitions
	echo "Probing new partition table"
	partprobe $outdev

	# resize filesystem
	echo "Resizing filesystem"
	resize2fs -f -p ${outdev}${partition}
fi

send_feedback 0

echo "Rebooting..." >&2

reboot -f

