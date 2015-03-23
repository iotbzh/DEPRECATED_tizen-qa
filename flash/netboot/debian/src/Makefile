LOCAL_MIRROR=http://ftp.fr.debian.org
WEB_MIRROR=http://ftp2.fr.debian.org

DISTRIB=testing

IMAGE=iso-hybrid
#IMAGE=netboot

all: help

help:
	@echo "Usage: make <config-standard | config-minimal | build | clean | distclean>"
	@echo "Variables:"
	@echo "  Debian mirror (local)              LOCAL_MIRROR=$(LOCAL_MIRROR)"
	@echo "  Debian mirror (web)                WEB_MIRROR=$(WEB_MIRROR)"
	@echo "  Distribution (testing,unstable)    DISTRIB=$(DISTRIB)"
	@echo "  Type of image (netboot,iso-hybrid) IMAGE=$(IMAGE)"
	@echo ""
	@echo "Example:"
	@echo "make clean config-minimal build"
	@echo "make clean config-standard build IMAGE=netboot"

config-standard:
	lb config \
		--distribution $(DISTRIB) \
		--archive-areas "main contrib non-free" \
		--binary-images $(IMAGE) \
		--mirror-bootstrap $(LOCAL_MIRROR)/debian \
		--mirror-chroot-security $(LOCAL_MIRROR)/debian-security \
		--parent-mirror-chroot-updates $(WEB_MIRROR)/debian \
		--apt-source-archives false \
		--hooks hook_standard.chroot \
		--debian-installer netboot \
		--debian-installer-distribution $(DISTRIB) \
		--debian-installer-gui true \
		--mirror-debian-installer $(WEB_MIRROR)/debian 
	cp -v ./hook_standard.chroot config/hooks/
	rsync -Pa qascripts/ config/includes.chroot/
	chmod -R +x config/includes.chroot/ # make executable
	cat extra_packages_common extra_packages_standard > config/package-lists/recommends.list.chroot

config-minimal:
	lb config \
		--distribution $(DISTRIB) \
		--archive-areas "main contrib non-free" \
		--binary-images $(IMAGE) \
		--mirror-bootstrap $(LOCAL_MIRROR)/debian \
		--mirror-chroot-security $(LOCAL_MIRROR)/debian-security \
		--parent-mirror-chroot-updates $(WEB_MIRROR)/debian \
		-k 686 \
		--apt-indices false \
		--apt-secure false \
		--apt-recommends false \
		--apt-source-archives false \
		--debootstrap-options "--variant=minbase" \
		--firmware-chroot false \
		--memtest none \
		--hooks hook_minimal.chroot 
	cp -v ./hook_minimal.chroot config/hooks/
	rsync -Pa qascripts/ config/includes.chroot/
	chmod -R +x config/includes.chroot/ # make executable
	cat extra_packages_common extra_packages_minimal > config/package-lists/recommends.list.chroot

.PHONY: clean
clean:
	lb clean
	rm -rf config build.log

.PHONY: distclean
distclean: clean
	rm -rf cache 

build:
	lb build 2>&1 | tee build.log

	

