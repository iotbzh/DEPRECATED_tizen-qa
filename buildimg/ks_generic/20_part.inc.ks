part / --fstype="ext4" --ondisk=sda --size=6144 --active --label tizen-pc-@BRANCH@

#bootloader  --timeout=1  --append="rw vga=current quiet splash"   
bootloader  --timeout=3  --append="rw vga=current splash rootwait rootfstype=ext4 plymouth.enable=0" --location=mbr --menus="install:Wipe and Install:systemd.unit=system-installer.service:test"

#installerfw_plugins "bootloader"

