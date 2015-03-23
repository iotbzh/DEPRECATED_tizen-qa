repo --cost=80 --name=opentizen --baseurl=file://@TOPDIR@/buildimg/opentizen --ssl_verify=no

%packages

opentizen-config

%end

%post

/root/opentizen-config.postinst

%end

