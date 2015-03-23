%include X_locale_fr.inc.ks

repo --cost=50 --name=@FLAVOUR@ --baseurl=http://obs.vannes:82/Tizen:/common:/devel:/private/standard_x86_64/ --ssl_verify=no 
%post

cat >> /etc/zypp/repos.d/@FLAVOUR@.repo  << EOF
[@FLAVOUR@]
name=@FLAVOUR@
enabled=1
autorefresh=0
priority=50
baseurl=@REPO_URL@/?ssl_verify=no
type=rpm-md
gpgcheck=0
EOF

cat >> /etc/zypp/repos.d/@FLAVOUR@-debug.repo  << EOF
[@FLAVOUR@-dbg]
name=@FLAVOUR@-dbg
enabled=0
autorefresh=0
priority=50
baseurl=@REPO_URL@/debug/?ssl_verify=no
type=rpm-md
gpgcheck=0
EOF

%end

user --name admin  --groups audio,video,weston-launch --password 'tizen'

user --name alice  --groups audio,video,weston-launch --password 'tizen'
user --name bob  --groups audio,video,weston-launch --password 'tizen'
user --name carol  --groups audio,video,weston-launch --password 'tizen'

