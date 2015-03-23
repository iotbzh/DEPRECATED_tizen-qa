# do not include X_autouser
# the default tizen user must not be created and the gnome-initial-setup packages will be installed

%post

# from TZ KS
# -------------------

#passwd -l root
# if root is not locked, set the password correctly
#echo tizen | passwd --stdin root

# -------------------

%end



