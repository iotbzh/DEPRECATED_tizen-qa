%packages

#group:PC Base
alsa-plugins-pulse
system-installer
pam-locale
prelink
tree

#kernel-adaptation-pc
kernel-x86-generic
dlogutil
#system-server
calendar-service

# bluetooth
rfkill
bluetooth-agent
bluetooth-frwk
bluetooth-share
bluetooth-tools-no-firmware
pulseaudio-module-bluetooth
bluez
#bluez-alsa
#bluez-compat

# desktop skin
desktop-skin

# xwayland
#xorg-server
#-xf86-video-vesa # makes xserver segfault
#xterm

# needed for zypper to work correctly
gpg2

# for wrt
sqlite3
ail # to remove after 20131014
wrt
wrt-commons
wrt-plugins-tizen
wrt-installer
wrt-security
wrt-widgets

# for gstreamer
gstreamer-utils 
gstreamer-vaapi
gst-plugins-good
gst-plugins-bad
libva-intel-driver
gst-libav
vaapi-tools
emotion

# for audio
alsa-utils
pulseaudio
pulseaudio-utils

# for tizen apps
web-ui-fw
web-ui-fw-demo-tizen-winsets
web-ui-fw-theme-default
web-ui-fw-theme-tizen-black
web-ui-fw-theme-tizen-white
efl-theme-tizen-hd
pkgmgr-server

# EFL apps
econnman

%end

%include G_Base_System.inc.ks
%include G_Wayland.inc.ks
#%include G_Development.inc.ks
%include G_Console_Tools.inc.ks
%include G_PC_Adaptation.inc.ks

%post
cat >> /etc/os-release  << EOF
BUILD_ID=@BUILD_ID@
EOF

ln -sf /usr/share/plymouth/themes/tizen/tizen-installer.script /usr/share/plymouth/themes/tizen/tizen.script

# lock root account
#passwd -l root

############################

# base-general.post

ln -sf /proc/self/mounts /etc/mtab

rm -rf /root/.zypp

# rpm.post
rm -f /var/lib/rpm/__db*
rpmdb --rebuilddb

# Initialize the native application database
pkg_initdb

# Add 'app' user to the weston-launch group
/usr/sbin/groupmod -A app weston-launch

# Temporary work around for bug in filesystem package resulting in the 'app' user home
# directory being only readable by root
chown -R app:app /opt/home/app

# Since weston-launch runs with the "User" label, the app
# home dir must have the same label
chsmack -a User /opt/home/app

# Enable a logind session for 'app' user on seat0 (the default seat for
# graphical sessions)
mkdir -p /usr/lib/systemd/system/graphical.target.wants
ln -s ../user-session-launch@.service /usr/lib/systemd/system/graphical.target.wants/user-session-launch@seat0-5000.service
ln -sf weston.target  /usr/lib/systemd/user/default.target

# Enable user@5000.service by setting the linger for user 'app'
#mkdir -p /var/lib/systemd/linger
#touch /var/lib/systemd/linger/app

######################################## START WRT WIDGETS PREINSTALL ####################

prepare_widgets.sh
install_widgets.sh

######################################## END WRT WIDGETS PREINSTALL ####################

# Add over-riding environment to enable the web runtime to
# run on an IVI image as a different user then the tizen user
cat > /etc/sysconfig/wrt <<EOF
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/5000/dbus/user_bus_socket
XDG_RUNTIME_DIR=/run/user/5000
ELM_ENGINE=wayland_egl
ECORE_EVAS_ENGINE=wayland_egl
ELM_THEME=tizen-HD-light
WRT_PROCESS_POOL_DISABLE=1
EOF

# Use the same over-rides for the native prelaunch daemon
cp /etc/sysconfig/wrt /etc/sysconfig/launchpad

# for AMD (ac.service)
cp /etc/sysconfig/wrt /etc/sysconfig/prelaunch

# Add a rule to ensure the app user has permissions to
# open the graphics device
cat > /etc/udev/rules.d/99-dri.rules <<EOF
SUBSYSTEM=="drm", MODE="0666"
EOF

# Needed to fix TIVI-1629
vconftool set -t int -f db/setting/default_memory/wap 0

###########################

# sdx: add ELM theme in weston.sh
cat >>/etc/profile.d/weston.sh <<'EOF'
# sdx: patch from Vannes custom ks file ks_generic/80_tzpackages.inc.ks
export ELM_THEME=tizen-HD-light
EOF

# sdx: user 'app' must own /dev/tty1 for weston to start correctly
cat >/usr/lib/udev/rules.d/99-tty.rules <<EOF
SUBSYSTEM=="tty", KERNEL=="tty1", GROUP="app", OWNER="app"
EOF

# sdx: fix smack labels on /var/log
chsmack -a '*' /var/log

# Run prelink to speed up dynamic binary/library loading
/usr/sbin/prelink --all

%end

