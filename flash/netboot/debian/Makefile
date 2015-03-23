FS=filesystem.squashfs

all: squashfs

squashfs: rootfs/.lastedit
	mksquashfs rootfs $(FS) -comp xz -no-exports 
	chmod 666 $(FS)

.PHONY: edit
edit:
	[ $$(id -u) != 0 ] && { echo "You must be root"; exit 1; } || true
	if [ ! -d rootfs ]; then \
		mkdir rootfs.tmp; mount $(FS) rootfs.tmp; cp -a rootfs.tmp rootfs; umount rootfs.tmp; rmdir rootfs.tmp; \
	fi
	mkdir -p rootfs/etc/
	cp /etc/resolv.conf rootfs/etc/resolv.conf
	chroot rootfs || true
	echo -n "" >rootfs/etc/resolv.conf
	touch rootfs/.lastedit
	mv $(FS) $(FS).old
	$(MAKE) squashfs
	rm $(FS).old

