repo --cost=20 --name=@BRANCH@ --baseurl=@REPO_URL@/repos/pc/x86_64/packages --ssl_verify=no

repo --cost=20 --name=google --baseurl=@TZ_URL@/3rdparty/repos/pc/google/ --ssl_verify=no

%post

cat >> /etc/zypp/repos.d/@BRANCH@.repo  << EOF
[@BRANCH@]
name=@BRANCH@
enabled=1
autorefresh=0
priority=20
baseurl=@REPO_URL@/repos/pc/x86_64/packages/?ssl_verify=no
type=rpm-md
gpgcheck=0
EOF

cat >> /etc/zypp/repos.d/@BRANCH@-dbg.repo  << EOF
[@BRANCH@-dbg]
name=@BRANCH@-dbg
enabled=1
autorefresh=0
priority=20
baseurl=@REPO_URL@/repos/pc/x86_64/debug/?ssl_verify=no
type=rpm-md
gpgcheck=0
EOF

cat >> /etc/zypp/repos.d/google.repo  << EOF
[google]
name=google
enabled=1
autorefresh=0
priority=20
baseurl=@TZ_URL@/3rdparty/repos/pc/google/?ssl_verify=no
type=rpm-md
gpgcheck=0
EOF

%end
