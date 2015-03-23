repo --cost=90 --name=qa --baseurl=file://@TOPDIR@/buildimg/qarepo --ssl_verify=no

%packages

#testkit-lite
#testkit-lite-kooltux

#python-xml # required by testkit-lite, but not included in default distrib
eat-device # for autologin via ssh
#screen # for manual testing

#xauth
#xrandr
#usbutils
#which

%end

