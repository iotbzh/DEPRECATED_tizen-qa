part / --fstype="ext4" --ondisk=sda --size=6144 --active --label tizen-pc-@BRANCH@

#bootloader  --timeout=1  --append="rw vga=current quiet splash"   
bootloader  --timeout=3  --append="rw vga=current quiet splash rootwait rootfstype=ext4" --location=mbr --menus="install:Wipe and Install:systemd.unit=system-installer.service:test"


