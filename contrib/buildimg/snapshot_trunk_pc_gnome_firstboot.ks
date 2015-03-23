logging --level=info

lang fr_FR.UTF-8
keyboard fr
timezone --utc Europe/Paris

#part / --size 3200 --ondisk sda --fstype=ext3
part / --fstype="ext4" --ondisk=sda --size=3200 --active --label tizen-pc-trunk

#bootloader  --timeout=1  --append="rw vga=current quiet splash"   
bootloader  --timeout=1  --append="rw vga=current quiet splash rootwait rootfstype=ext4" --location=mbr --menus="install:Wipe and Install:systemd.unit=pc-installer.service:test"

#user --name tizen  --groups audio,video --password 'tizen'
#desktop --autologinuser=tizen  
rootpw --plaintext tizen 
xconfig --startxonboot

repo --name=trunk_pc --baseurl=@REPO_URL@/repos/pc/x86_64/packages --ssl_verify=no
repo --name=google --baseurl=@TZ_URL@/pc/repos/google --ssl_verify=no

%include customize.inc.ks

%include qa.inc.ks

%include extra_packages_common.inc.ks
%include extra_packages_trunk.inc.ks

%packages

@Base System
@Gnome
@Base Desktop
@Console Tools
@PC Adaptation
@Tizen Shell
@Google Chrome

kernel-adaptation-pc

libreoffice


%end

%post

cat >> /etc/zypp/repos.d/tizen-pc.repo  << EOF
[pc]
name=pc
enabled=1
autorefresh=0
baseurl=@REPO_URL@/repos/pc/x86_64/packages/?ssl_verify=no
type=rpm-md
gpgcheck=0
EOF

cat >> /etc/zypp/repos.d/tizen-pc-debug.repo  << EOF
[pcdbg]
name=pcdbg
enabled=1
autorefresh=0
baseurl=@REPO_URL@/repos/pc/x86_64/debug/?ssl_verify=no
type=rpm-md
gpgcheck=0
EOF

# uncomment for secure image without any clear password in urls
#rm /etc/zypp/repos.d/tizen-pc.repo /etc/zypp/repos.d/tizen-pc-debug.repo

echo "@IMAGETAG@ @SNAPSHOT@ standard" >/etc/tizen-snapshot

cat >> /etc/os-release  << EOF
TIZEN_BUILD_ID=@BUILD_ID@
EOF

%end

%post --nochroot

%end
