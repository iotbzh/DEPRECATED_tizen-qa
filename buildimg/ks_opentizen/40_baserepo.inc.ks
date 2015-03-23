repo --cost=50 --name=@BRANCH@ --baseurl=@REPO_URL@ --ssl_verify=no 
%post

cat >> /etc/zypp/repos.d/@BRANCH@.repo  << EOF
[@BRANCH@]
name=@BRANCH@
enabled=1
autorefresh=0
priority=50
baseurl=@REPO_URL@/?ssl_verify=no
type=rpm-md
gpgcheck=0
EOF

cat >> /etc/zypp/repos.d/@BRANCH@-debug.repo  << EOF
[@BRANCH@-dbg]
name=@BRANCH@-dbg
enabled=0
autorefresh=0
priority=50
baseurl=@REPO_URL@/debug/?ssl_verify=no
type=rpm-md
gpgcheck=0
EOF

%end

