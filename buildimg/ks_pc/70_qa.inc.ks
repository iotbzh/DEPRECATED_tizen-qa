repo --cost=50 --name=qa --baseurl=file://@TOPDIR@/buildimg/qarepo --ssl_verify=no

%packages

#testkit-lite
testkit-lite-kooltux

python-xml # required by testkit-lite, but not included in default distrib
eat-device # for autologin via ssh
cats-host # to satisfy cats
screen # for manual testing

xauth
xrandr
usbutils
which

%end

%post
### satisfy CATS server
# pb: cats-server uses the cats user to log on with ssh on target
# "cats" user name is hardcoded in python code and we don't wish to change that
# 
# we need to run some tests as root but:
# - if the option "run_as=root" is given in the CATS recipe, the sudo command is called on the target host
#   pb: on tizen, there's no sudo command !
# - if the option "run_as" is not specified, the test command is run as user "cats"

### solution 1 (doesn't work for having root rights on target)
# add a regular user and copy eat-device ssh key for user cats
#user --name cats  --groups audio,video --password 'cats'
#mkdir -p /home/cats/.ssh
#cp /root/.ssh/authorized_keys /home/cats/.ssh/
#chown -R cats:users /home/cats

### solution 2 
# create a fake user cats who has the same rights as root !
# password is the same as root ("tizen")
# => this way, no need to have sudo to run as root

# cats user is already created by pkg cats-host: remove it !!!
/usr/sbin/userdel -r cats
/usr/sbin/useradd --uid 0 --gid 0 --groups root --home /root --non-unique --shell /bin/bash --comment root --password stiqeMOtm8THU cats

%end
