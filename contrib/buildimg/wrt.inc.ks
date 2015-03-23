# WRT Specific Repo & packages

repo --cost=1 --name=base --baseurl=http://intel00:8002/releases/Base:/System/standard/packages/ --ssl_verify=no
repo --cost=1 --name=wrt --baseurl=http://obsvannes.vannes:82/WRT-TIZEN-2.1/Base_System_standard/ --ssl_verify=no

%packages

wrt-widgets 

%end

%post

cat >> /etc/zypp/repos.d/base.repo  << EOF
[base]
name=base
enabled=1
autorefresh=0
baseurl=http://intel00.vannes:8002/releases/Base:/System/standard/packages/
type=rpm-md
gpgcheck=0
EOF

cat >> /etc/zypp/repos.d/wrt.repo  << EOF
[wrt]
name=wrt
enabled=1
autorefresh=0
baseurl=http://obsvannes.vannes:82/WRT-DEVEL/Base_System_standard/?ssl_verify=no
type=rpm-md
gpgcheck=0
EOF

# uncomment to remove repo definition
#rm /etc/zypp/repos.d/wrt.repo

%end


