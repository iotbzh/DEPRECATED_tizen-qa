#!/bin/bash
# This program launch the core
# work on existing files and directories testfile1 tesfile2 testdir1 testdir 2
#

set -e

fail_if_error() {
  echo "... Testing $1 :" 
  if ! "$@"
  then 
    echo "failed : $*"
  fi
}

fail_if_ok() {
	if "$@"
	then
	  echo "failed : $*"
	fi
}

  
fail_if_error arch
fail_if_error basename testfile1
fail_if_error cat testfile2
#fail_if_error chcon
fail_if_error chgrp root testdir1
fail_if_error chmod 777 testdir2
fail_if_error chown root testfile1 # To complete
#fail_if_error chroot --userspec=USER:GROUP dir1
fail_if_error cksum testfile1
fail_if_error comm testfile1 testfile2
fail_if_error cp testfile1 testfile3
#fail_if_error csplit  15 30 45 /etc/group
fail_if_error cut -d: -f1 testfile2
fail_if_error date
fail_if_error dd if=testfile1 of=testfile3
# --- cleaning ---#
fail_if_error df
fail_if_error dir -a
fail_if_error dircolors
fail_if_error dirname testdir1
fail_if_error du testdir1
fail_if_error echo "this is only a test"
fail_if_error dir -a
fail_if_error env
fail_if_error expand testfile2
fail_if_error factor 966
fail_if_ok false
fail_if_error fmt testfile2
fail_if_error fold testfile1
fail_if_error groups
fail_if_error hostid 
#fail_if_error hostname
fail_if_error id 
fail_if_error install testfile1 testdir1
# --- cleaning --- #
rm testdir1/testfile1
fail_if_error join testfile1 testfile2
#fail_if_error kill 
fail_if_error link testfile1 alink
# --- cleaning ---#
rm alink
fail_if_error ln -ns testfile2 symblink
#fail_if_error logname
rm -rf /tmp/*
rm -rf /tmp/*
fail_if_error ls
fail_if_error md5sum testfile1
fail_if_error mkdir toto
# --- cleaning ---#
rm -r toto
fail_if_error mkfifo fifo
# --- cleaning ---#
rm fifo
fail_if_error mknod anode c 0 0
# --- cleaning --- #
rm anode
fail_if_error mktemp --suffix=.txt file-XXXX
# --- cleaning ---#
rm file-*
touch touchedfile ; fail_if_error mv touchedfile testdir1/
# --- cleaning ---
rm  testdir1/touchedfile
fail_if_error nice nice
fail_if_error nl testfile1
fail_if_error nohup ls
# --- cleaning ---#
rm -f nohup.out
fail_if_error nproc
#fail_if_error od
fail_if_error paste testfile2
fail_if_error pathchk testfile1
fail_if_error pinky -l root
fail_if_error pr testfile1
fail_if_error printenv
fail_if_error printf "this is a sanity test\n"
fail_if_error ptx testfile2
fail_if_error pwd
fail_if_error readlink symblink
# --- cleaning ---#
rm symblink
fail_if_error realpath .
fail_if_error rm  -rf /var/tmp/*
mkdir toto ; fail_if_error rm -r toto  
mkdir toto ; fail_if_error rmdir toto
#fail_if_error runcon
fail_if_error  seq -f '(%9.2E)' -9e5 1.1e6 1.3e6
fail_if_error sha1sum testfile2
fail_if_error sha224sum testfile2
fail_if_error sha256sum testfile2
fail_if_error sha384sum testfile2
fail_if_error sha512sum testfile1
fail_if_error shred testfile2
# --- correcting ---#
cp testfile1 testfile2
fail_if_error shuf testfile1
fail_if_error sleep 3
fail_if_error sort testfile1
fail_if_error split testfile2
fail_if_error stat testfile1
fail_if_error stdbuf echo
#fail_if_error stty
fail_if_error sum testfile1
fail_if_error sync
fail_if_error tac testfile2
fail_if_error tail /proc/devices
fail_if_error echo "it is only a test" | tee fileres.log
# --- cleaning ---#
rm fileres.log
fail_if_error test 5 -gt 2
fail_if_error timeout 2 ls
fail_if_error touch testfile
fail_if_error echo ThIs ExAmPlE HaS MIXED case! | tr '[:upper:]' '[:lower:]' 
fail_if_error true
fail_if_error truncate --size=40 testfile1
fail_if_error tsort testfile1
fail_if_error tty
fail_if_error uname
fail_if_error unexpand testfile2
fail_if_error uniq testfile1
fail_if_error unlink testfile
fail_if_error uptime
fail_if_error users
fail_if_error vdir
fail_if_error wc testfile1
fail_if_error who
fail_if_error whoami
#fail_if_error yes

rm -rf /tmp/*





