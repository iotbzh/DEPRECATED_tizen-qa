%packages

#group:PC Base
alsa-plugins-pulse
system-installer
pam-locale
prelink
tree

#kernel-adaptation-pc
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

# EFL apps
econnman

%end

%include G_Base_System.inc.ks
%include G_Wayland.inc.ks
#%include G_Development.inc.ks
%include G_Console_Tools.inc.ks
%include G_PC_Adaptation.inc.ks

%post

# Migrate /etc/sysconfig/i18n until MIC is fixed to handle locale.conf
if [ -e /etc/sysconfig/i18n -a ! -e /etc/locale.conf ]; then
        unset LANG
        unset LC_CTYPE 
        unset LC_NUMERIC
        unset LC_TIME
        unset LC_COLLATE
        unset LC_MONETARY
        unset LC_MESSAGES
        unset LC_PAPER
        unset LC_NAME
        unset LC_ADDRESS
        unset LC_TELEPHONE
        unset LC_MEASUREMENT
        unset LC_IDENTIFICATION
        . /etc/sysconfig/i18n >/dev/null 2>&1 || :
        [ -n "$LANG" ] && echo LANG=$LANG > /etc/locale.conf 2>&1 || :
        [ -n "$LC_CTYPE" ] && echo LC_CTYPE=$LC_CTYPE >> /etc/locale.conf 2>&1 || :
        [ -n "$LC_NUMERIC" ] && echo LC_NUMERIC=$LC_NUMERIC >> /etc/locale.conf 2>&1 || :
        [ -n "$LC_TIME" ] && echo LC_TIME=$LC_TIME >> /etc/locale.conf 2>&1 || :
        [ -n "$LC_COLLATE" ] && echo LC_COLLATE=$LC_COLLATE >> /etc/locale.conf 2>&1 || :
        [ -n "$LC_MONETARY" ] && echo LC_MONETARY=$LC_MONETARY >> /etc/locale.conf 2>&1 || :
        [ -n "$LC_MESSAGES" ] && echo LC_MESSAGES=$LC_MESSAGES >> /etc/locale.conf 2>&1 || :
        [ -n "$LC_PAPER" ] && echo LC_PAPER=$LC_PAPER >> /etc/locale.conf 2>&1 || :
        [ -n "$LC_NAME" ] && echo LC_NAME=$LC_NAME >> /etc/locale.conf 2>&1 || :
        [ -n "$LC_ADDRESS" ] && echo LC_ADDRESS=$LC_ADDRESS >> /etc/locale.conf 2>&1 || :
        [ -n "$LC_TELEPHONE" ] && echo LC_TELEPHONE=$LC_TELEPHONE >> /etc/locale.conf 2>&1 || :
        [ -n "$LC_MEASUREMENT" ] && echo LC_MEASUREMENT=$LC_MEASUREMENT >> /etc/locale.conf 2>&1 || :
        [ -n "$LC_IDENTIFICATION" ] && echo LC_IDENTIFICATION=$LC_IDENTIFICATION >> /etc/locale.conf 2>&1 || :
fi
rm -f /etc/sysconfig/i18n >/dev/null 2>&1 || :

ln -sf /proc/self/mounts /etc/mtab

rm -rf /root/.zypp

cat >> /etc/os-release  << EOF
BUILD_ID=@BUILD_ID@
EOF

ln -sf /usr/share/plymouth/themes/tizen/tizen-installer.script /usr/share/plymouth/themes/tizen/tizen.script

# lock root account
#passwd -l root

####################### from  IVI 3.0 (http://download.tizen.org/releases/milestone/tizen/ivi/tizen_20130829.9/images/ivi-release-mbr-i586/ivi-release-mbr-i586.ks)

# rpm.post
rm -f /var/lib/rpm/__db*
rpmdb --rebuilddb

# Initialize the native application database
pkg_initdb

# Add 'app' user to the weston-launch group
#APPMODE
/usr/sbin/groupmod -A app weston-launch
#ADMINMODE
#/usr/sbin/groupmod -A admin weston-launch

# Temporary work around for bug in filesystem package resulting in the 'app' user home
# directory being only readable by root
chown -R app:app /opt/home/app

# base-weston-default.post
mkdir -p /usr/lib/systemd/system/graphical.target.wants
#APPMODE
ln -sf ../user-session@.service /usr/lib/systemd/system/graphical.target.wants/user-session@5000.service
#ADMINMODE
#ln -sf ../user-session@.service /usr/lib/systemd/system/graphical.target.wants/user-session@9999.service
ln -sf weston.target  /usr/lib/systemd/user/default.target

######################################## WRT WIDGETS PREINSTALL ####################
# WRT install
echo "============== GROUIK WRT ! ============================"
cd /tmp
zypper --non-interactive --no-gpg-checks in http://obs.vannes:82/Tizen:/common:/WebRunTime/standard_Efl178/noarch/wrt-widgets-0.1-3.2.noarch.rpm
prepare_widgets.sh
install_widgets.sh
######################################## END WRT WIDGETS PREINSTALL ####################

# Add over-riding environment to enable the web runtime to
# run on an IVI image as a different user then the tizen user
cat > /etc/sysconfig/wrt <<EOF
#APPMODE 
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/5000/dbus/user_bus_socket
XDG_RUNTIME_DIR=/run/user/5000
#ADMINMODE
#DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/9999/dbus/user_bus_socket
#XDG_RUNTIME_DIR=/run/user/9999
ELM_ENGINE=wayland_egl
ECORE_EVAS_ENGINE=wayland_egl
ELM_THEME=tizen-HD-light
WRT_PROCESS_POOL_DISABLE=1
EOF

# Use the same over-rides for the native prelaunch daemon
cp /etc/sysconfig/wrt /etc/sysconfig/launchpad
cp /etc/sysconfig/wrt /etc/sysconfig/prelaunch

# Add a rule to ensure the app user has permissions to
# open the graphics device
cat > /etc/udev/rules.d/99-dri.rules <<EOF
SUBSYSTEM=="drm", MODE="0666"
EOF

# sdx: set DBUS env inside weston shell (login shell)
cat >/etc/profile.d/user-dbus.sh <<EOF
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$UID/dbus/user_bus_socket
EOF

################################### end IVI 3.0

# Run prelink to speed up dynamic binary/library loading
/usr/sbin/prelink --all

# generate system-installer configuration
/usr/sbin/installer-conf-creator

%end

