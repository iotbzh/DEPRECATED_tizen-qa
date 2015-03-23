part / --fstype="ext4" --ondisk=sda --size=4000 --active --label tizen-pc-@BRANCH@

#bootloader  --timeout=1  --append="rw vga=current quiet splash"   
bootloader  --timeout=1  --append="rw vga=current quiet splash rootwait rootfstype=ext4" --location=mbr --menus="install:Wipe and Install:systemd.unit=pc-installer.service:test"


