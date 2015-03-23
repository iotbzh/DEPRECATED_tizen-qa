Name: opentizen-config
Summary: Provides opentizen-config.
Version: 1.0
Group: Applications
License: Restricted
Release: 18.20131119142141
Prefix: /
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-qadmin-%(%{__id_u} -n)
BuildArch: noarch

%description
Provides opentizen-config.

%define _rpmdir /home/qadmin/qatizen/buildimg/opentizen

%build
cp /home/qadmin/qatizen/buildimg/opentizen/opentizen-config.tar %{_builddir}/archive.tar

%install
mkdir -p $RPM_BUILD_ROOT/
mv archive.tar $RPM_BUILD_ROOT/archive.tar
cd $RPM_BUILD_ROOT/
tar -xpf $RPM_BUILD_ROOT/archive.tar
rm $RPM_BUILD_ROOT/archive.tar

%clean
rm -fr $RPM_BUILD_ROOT

%files
/
//root/build_opentizen-config
//root/opentizen-config.postinst
//var/lib/alsa/asound.state
//usr/bin/alsamixer
//usr/bin/launch_cam.sh
//usr/bin/launch_video.sh
//home/app/AmazingNature_480p.mp4
//home/app/Photos/
//home/app/Photos/DSCN0024.JPG
//home/app/Photos/IMG_0026.jpg
//home/app/Photos/IMG_0027.jpg
//usr/share/backgrounds/tizen/
//usr/share/backgrounds/tizen/golfe-morbihan.jpg
//usr/share/backgrounds/tizen/golfe-morbihan-tz.jpg
//usr/share/icons/tizen/
//usr/share/icons/tizen/32x32/
//usr/share/icons/tizen/32x32/bubblewrap.png
//usr/share/icons/tizen/32x32/web-browser.png
//usr/share/icons/tizen/32x32/webcam.png
//usr/share/icons/tizen/32x32/video.png
//usr/share/icons/tizen/32x32/go.png
//usr/share/icons/tizen/32x32/terminal.png
//usr/share/icons/tizen/32x32/network.png
//usr/share/icons/tizen/32x32/mancala.png
//usr/share/icons/tizen/32x32/photo.png
//usr/share/icons/tizen/32x32/annex.png
//usr/share/icons/tizen/32x32/calculator.png
//etc/xdg/weston/weston.ini
