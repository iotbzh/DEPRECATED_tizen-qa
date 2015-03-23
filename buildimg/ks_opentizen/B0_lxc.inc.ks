repo --cost=5 --name=kernel --baseurl=http://jumbo.vannes/public/depots/sdx/ --ssl_verify=no

%packages

kernel-adaptation-pc
lxc

# for lxc/kernel development
git 
automake 
libtool
gcc
gcc-c++
gdb
strace
make

kernel-adaptation-pc-devel
libcap-devel 

%end

%post

%end


