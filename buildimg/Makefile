IMGDIR=images

TZURL=$(shell . ~/.tzconfig && echo $$TZURL)

SNAPSHOT=latest
FLAVOUR=standard

LOCAL_SNAPSHOTS=file://$(shell pwd -P)/snapshots

####################################################################################

### COMMON REMOTE ###

URL_COMMON_UPSTREAM=http://cdn.download.tizen.org/snapshots/tizen/common/$(SNAPSHOT)
URL_COMMON_UPSTREAM_2014Q3=http://cdn.download.tizen.org/snapshots/tizen/common-3.0.2014.Q3/$(SNAPSHOT)
URL_COMMON_UPSTREAM_2015Q1=http://cdn.download.tizen.org/snapshots/tizen/common-3.0.2015.Q1/$(SNAPSHOT)
URL_COMMON_DEVEL_UPSTREAM=http://cdn.download.tizen.org/snapshots/devel/common/$(SNAPSHOT)

### COMMON LOCAL ###

URL_COMMON=$(LOCAL_SNAPSHOTS)/Tizen_Common/$(SNAPSHOT)
URL_COMMON_DEVEL=$(LOCAL_SNAPSHOTS)/Tizen_Common_devel/$(SNAPSHOT)
URL_COMMON_MULTIUSER=$(LOCAL_SNAPSHOTS)/Tizen_Common_multiuser/$(SNAPSHOT)
URL_COMMON_SANDBOX=$(LOCAL_SNAPSHOTS)/Tizen_Common_sandbox/$(SNAPSHOT)
URL_COMMON_X11=$(LOCAL_SNAPSHOTS)/Tizen_Common_x11/$(SNAPSHOT)

### IVI REMOTE ###

URL_IVI_UPSTREAM=http://download.tizen.org/snapshots/tizen/ivi/$(SNAPSHOT)
URL_IVI_UPSTREAM_M14_3=http://download.tizen.org/snapshots/tizen/ivi-3.0.m14.3/$(SNAPSHOT)

### PC REMOTE ###

URL_PC=$(TZURL)/snapshots/trunk/pc/$(SNAPSHOT)
URL_PCDEV=$(TZURL)/snapshots/devel/pc/$(SNAPSHOT)

all: help

################################# TIZEN Common #################################

.PHONY: common-w32
common-w32: snapshots/Tizen_Common/$(SNAPSHOT)/builddata/images/ia32-wayland/image-configurations/common-wayland-mbr-i586.ks
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 $< $(IMGDIR)/$@ "$(URL_COMMON)" "repos/ia32-wayland"

.PHONY: common-w32efi
common-w32efi: snapshots/Tizen_Common/$(SNAPSHOT)/builddata/images/ia32-wayland/image-configurations/common-wayland-efi-i586.ks
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 $< $(IMGDIR)/$@ "$(URL_COMMON)" "repos/ia32-wayland"

.PHONY: common-w64
common-w64: snapshots/Tizen_Common/$(SNAPSHOT)/builddata/images/x86_64-wayland/image-configurations/common-wayland-mbr-x86_64.ks
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 $< $(IMGDIR)/$@ "$(URL_COMMON)" "repos/x86_64-wayland/"

.PHONY: common-w64efi
common-w64efi: snapshots/Tizen_Common/$(SNAPSHOT)/builddata/images/x86_64-wayland/image-configurations/common-wayland-efi-x86_64.ks
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 $< $(IMGDIR)/$@ "$(URL_COMMON)" "repos/x86_64-wayland/"

.PHONY: common-w64-devel
common-w64-devel: snapshots/Tizen_Common_devel/$(SNAPSHOT)/builddata/images/x86_64-wayland/image-configurations/common-wayland-mbr-x86_64.ks
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 $< $(IMGDIR)/$@ "$(URL_COMMON_DEVEL)" "repos/x86_64-wayland/"

.PHONY: common-w64efi-devel
common-w64efi-devel: snapshots/Tizen_Common_devel/$(SNAPSHOT)/builddata/images/x86_64-wayland/image-configurations/common-wayland-efi-x86_64.ks
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 $< $(IMGDIR)/$@ "$(URL_COMMON_DEVEL)" "repos/x86_64-wayland/"

.PHONY: common-w64-multiuser
common-w64-multiuser: snapshots/Tizen_Common_multiuser/$(SNAPSHOT)/builddata/images/x86_64-wayland/image-configurations/common-wayland-mbr-x86_64.ks
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 $< $(IMGDIR)/$@ "$(URL_COMMON_MULTIUSER)" "repos/x86_64-wayland/"

.PHONY: common-w64efi-multiuser
common-w64efi-multiuser: snapshots/Tizen_Common_multiuser/$(SNAPSHOT)/builddata/images/x86_64-wayland/image-configurations/common-wayland-efi-x86_64.ks
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 $< $(IMGDIR)/$@ "$(URL_COMMON_MULTIUSER)" "repos/x86_64-wayland/"

.PHONY: common-x64-x11
common-x64-x11: snapshots/Tizen_Common_multiuser/$(SNAPSHOT)/builddata/images/x86_64-x11/image-configurations/common-x11-mbr-x86_64.ks
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 $< $(IMGDIR)/$@ "$(URL_COMMON_X11)" "repos/x86_64-x11/"

.PHONY: common-w64-sandbox
common-w64-sandbox: snapshots/Tizen_Common_sandbox/$(SNAPSHOT)/builddata/images/x86_64-wayland/image-configurations/common-wayland-mbr-x86_64.ks
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 $< $(IMGDIR)/$@ "$(URL_COMMON_SANDBOX)" "repos/x86_64-wayland/"

#b	############################## COMMON UPSTREAM ###########################

.PHONY: common-w64-upstream
common-w64-upstream: 
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 "$(URL_COMMON_UPSTREAM)/builddata/images/x86_64-wayland/image-configurations/common-wayland-mbr-x86_64.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM)" "repos/x86_64-wayland/"

.PHONY: common-x64-upstream
common-x64-upstream: 
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 "$(URL_COMMON_UPSTREAM)/builddata/images/x86_64-x11/image-configurations/common-x11-mbr-x86_64.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM)" "repos/x86_64-x11/"


.PHONY: common-w64efi-upstream
common-w64efi-upstream: 
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 "$(URL_COMMON_UPSTREAM)/builddata/images/x86_64-wayland/image-configurations/common-wayland-efi-x86_64.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM)" "repos/x86_64-wayland/"

.PHONY: common-w64-upstream-noqa
common-w64-upstream-noqa: 
	@time bin/create_image2 $@ noqa x86_64 "$(URL_COMMON_UPSTREAM)/builddata/images/x86_64-wayland/image-configurations/common-wayland-mbr-x86_64.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM)" "repos/x86_64-wayland/"

.PHONY: common-w64-upstream-img
common-w64-upstream-img:
	@time bin/download_image images/$@ "$(URL_COMMON_UPSTREAM)" images/x86_64-wayland/common-wayland-mbr-x86_64/@SNAPSHOT@_common-wayland-mbr-x86_64-sda.raw.bz2	

.PHONY: common-w64-upstream-2014Q3
common-w64-upstream-2014Q3: 
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 "$(URL_COMMON_UPSTREAM_2014Q3)/builddata/images/x86_64-wayland/image-configurations/common-wayland-mbr-x86_64.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM_2014Q3)" "repos/x86_64-wayland/"

.PHONY: common-w64-upstream-2015Q1
common-w64-upstream-2015Q1: 
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 "$(URL_COMMON_UPSTREAM_2015Q1)/builddata/images/x86_64-wayland/image-configurations/common-wayland-mbr-x86_64.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM_2015Q1)" "repos/x86_64-wayland/"

.PHONY: common-w64efi-upstream-2015Q1
common-w64efi-upstream-2015Q1: 
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 "$(URL_COMMON_UPSTREAM_2015Q1)/builddata/images/x86_64-wayland/image-configurations/common-wayland-efi-x86_64.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM_2015Q1)" "repos/x86_64-wayland/"

.PHONY: common-w32-upstream
common-w32-upstream: 
	@time bin/create_image2 $@ $(FLAVOUR) i686 "$(URL_COMMON_UPSTREAM)/builddata/images/ia32-wayland/image-configurations/common-wayland-mbr-i586.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM)" "repos/ia32-wayland"

.PHONY: common-x32-upstream
common-x32-upstream: 
	@time bin/create_image2 $@ $(FLAVOUR) i686 "$(URL_COMMON_UPSTREAM)/builddata/images/ia32-x11/image-configurations/common-x11-mbr-i586.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM)" "repos/ia32-x11"

.PHONY: common-w32efi-upstream
common-w32efi-upstream: 
	@time bin/create_image2 $@ $(FLAVOUR) i686 "$(URL_COMMON_UPSTREAM)/builddata/images/ia32-wayland/image-configurations/common-wayland-efi-i586.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM)" "repos/ia32-wayland"

.PHONY: common-w32-upstream-img
common-w32-upstream-img:
	@time bin/download_image images/$@ "$(URL_COMMON_UPSTREAM)" images/ia32-wayland/common-wayland-mbr-i586/@SNAPSHOT@_common-wayland-mbr-i586-sda.raw.bz2	

.PHONY: common-installer-upstream
common-installer-upstream: 
	@time bin/create_image2 $@ $(FLAVOUR) i686 "$(URL_COMMON_UPSTREAM)/builddata/images/ia32-wayland/image-configurations/common-installer-mbr-i586.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM)" "repos/ia32-wayland"

.PHONY: common-installer-upstream-img
common-installer-upstream-img:
	@time bin/download_image images/$@ "$(URL_COMMON_UPSTREAM)" images/ia32-wayland/common-installer-mbr-i586/@SNAPSHOT@_common-installer-mbr-i586-sda.raw.bz2	

.PHONY: common-warm-upstream
common-warm-upstream: 
	@time bin/create_image2 $@ $(FLAVOUR) armv7l "$(URL_COMMON_UPSTREAM)/builddata/images/arm-wayland/image-configurations/common-wayland-2parts-armv7l.ks" $(IMGDIR)/$@ "$(URL_COMMON_UPSTREAM)" "repos/arm-wayland/"

#################################### COMMON DEVEL ##################################

.PHONY: common-w64-upstream-devel
common-w64-upstream-devel: 
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 "$(URL_COMMON_DEVEL_UPSTREAM)/builddata/images/x86_64-wayland/image-configurations/common-wayland-mbr-x86_64.ks" $(IMGDIR)/$@ "$(URL_COMMON_DEVEL_UPSTREAM)" "repos/x86_64-wayland/"

.PHONY: common-w64-upstream-devel-temp
common-w64-upstream-devel-temp: 
	wget -O /tmp/foo.ks "$(URL_COMMON_DEVEL_UPSTREAM)/builddata/images/x86_64-wayland/image-configurations/common-wayland-mbr-x86_64.ks"
	gvim -f /tmp/foo.ks
	@time bin/create_image2 $@ $(FLAVOUR) x86_64 /tmp/foo.ks $(IMGDIR)/$@ "$(URL_COMMON_DEVEL_UPSTREAM)" "repos/x86_64-wayland/"

.PHONY: common-w32-upstream-devel
common-w32-upstream-devel: 
	@time bin/create_image2 $@ $(FLAVOUR) i686 "$(URL_COMMON_DEVEL_UPSTREAM)/builddata/images/ia32-wayland/image-configurations/common-wayland-mbr-i586.ks" $(IMGDIR)/$@ "$(URL_COMMON_DEVEL_UPSTREAM)" "repos/ia32-wayland/"

#################################### IVI ##################################

.PHONY: ivi-upstream
ivi-upstream: 
	@time bin/create_image2 $@ $(FLAVOUR) i686 "$(URL_IVI_UPSTREAM)/builddata/images/atom/image-configurations/ivi-mbr-i586.ks" $(IMGDIR)/$@ "$(URL_IVI_UPSTREAM)" "repos/atom"

.PHONY: ivi-upstream-m14.3
ivi-upstream-m14.3: 
	@time bin/create_image2 $@ $(FLAVOUR) i686 "$(URL_IVI_UPSTREAM_M14_3)/builddata/images/atom/image-configurations/ivi-mbr-i586.ks" $(IMGDIR)/$@ "$(URL_IVI_UPSTREAM_M14_3)" "repos/atom"

.PHONY: ivi-upstream-img
ivi-upstream-img: 
	@time bin/download_image images/$@ "$(URL_IVI_UPSTREAM)" images/ivi-mbr-i586/@SNAPSHOT@_ivi-mbr-i586-sdb.raw.bz2

################################### PC ##################################

######## trunk ############

.PHONY: pc
pc: ks_pc/base.ks
	@time bin/create_image pc $(FLAVOUR) x86_64 $< $(IMGDIR)/$@-$(FLAVOUR) "$(URL_PC)"

.PHONY: pc-usb
pc-usb: ks_pc/base.ks
	@time bin/create_image pc $(FLAVOUR) x86_64 $< $(IMGDIR)/$@-$(FLAVOUR) "$(URL_PC)" liveusb

######## devel ############

.PHONY: pcdev
pcdev: ks_pc/base.ks
	@time bin/create_image pcdev $(FLAVOUR) x86_64 $< $(IMGDIR)/$@-$(FLAVOUR) "$(URL_PCDEV)"

.PHONY: pcdev-usb
pcdev-usb: ks_pc/base.ks
	@time bin/create_image pcdev $(FLAVOUR) x86_64 $< $(IMGDIR)/$@-$(FLAVOUR) "$(URL_PCDEV)" liveusb

######## hybrid ############

.PHONY: hybrid
hybrid: ks_hybrid/base.ks
	@time bin/create_image hybridpc $(FLAVOUR) x86_64 $< $(IMGDIR)/$@-$(FLAVOUR) "$(URL_HYBRIDPC)"

.PHONY: hybrid-usb
hybrid-usb: ks_hybrid/base.ks
	@time bin/create_image hybridpc $(FLAVOUR) x86_64 $< $(IMGDIR)/$@-$(FLAVOUR) "$(URL_HYBRIDPC)" liveusb

############################## QA ###################################

.PHONY:qa-check
qa-check:
	@if [[ -z "$(TARGET)" ]]; then \
	    echo "Invalid TARGET"; \
		echo "Usage: qabuildimg $@ TARGET=<hostname> [SUITE=...]"; \
		exit 1; \
	fi; \
	echo "Getting target status..."; \
	status=$$(qatarget status '$(TARGET)'); \
	if [[ "$$status" =~ unreachable ]]; then \
	    echo "TARGET $(TARGET) is unreachable"; \
		exit 1; \
	fi; \
	echo $$status

SUITE=sanity

qa-w32: qa-check
	qamanager $(TARGET) common_$(SUITE) -r qareport_common_w32_local

qa-w64: qa-check
	qamanager $(TARGET) common_$(SUITE) -r qareport_common_w64_local

qa-w32-upstream: qa-check
	qamanager $(TARGET) common_$(SUITE) -r qareport_common_w32_upstream

qa-w64-upstream: qa-check
	qamanager $(TARGET) common_$(SUITE) -r qareport_common_w64_upstream

qa-w64-daily: qa-check
	for suite in sanity multimedia graphics; do \
       qamanager $(TARGET) common_$$suite -r qareport_common_w64_local; \
	done

qa-w64-weekly: qa-check
	for suite in sanity multimedia graphics crosswalk; do \
       qamanager $(TARGET) common_$$suite -r qareport_common_w64_local; \
	done

############################## Tools ###################################

.PHONY: poll
poll:
	@bin/poll_snapshot -t 30 \
		"common-w64=$(URL_COMMON)" \
		"common-w32=$(URL_COMMON)" \
		"common-w64-devel=$(URL_COMMON)" \
		"common-w64-multiuser=$(URL_COMMON)" \
		"common-x64-x11=$(URL_COMMON)" \
		"common-w64-upstream=$(URL_COMMON_UPSTREAM)" \
		"common-w32-upstream=$(URL_COMMON_UPSTREAM)"

.PHONY: poll-exec
poll-exec:
	@screen bin/poll_snapshot -t 30 \
		"common-w64-upstream=$(URL_COMMON_UPSTREAM)" \
		"common-w32-upstream=$(URL_COMMON_UPSTREAM)" \
		-- ../bin/qasnapshot_autotest

.PHONY: help
help:
	@echo "qabuildimg <image type> [SNAPSHOT=<id> (default=latest)] [FLAVOUR=<id> (for trunk and devel only, default=standard)]"
	@echo
	@echo "Available targets and snapshots:"
#	@sid=$$(bin/get_snapshot '$(URL_PC)');  echo "- pc:  SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON)');					echo "- common-w32 / common-w32efi: SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON)');					echo "- common-w64 / common-w64efi: SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON_DEVEL)');			echo "- common-w64-devel / common-w64efi-devel: SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON_MULTIUSER)');		echo "- common-w64-multiuser / common-w64efi-multiuser: SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON_SANDBOX)');		    echo "- common-w64-sandbox: SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON_X11)');				echo "- common-x64-x11: SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON_UPSTREAM)');			echo "- common-w32-upstream / common-w32efi-upstream / common-x32-upstream: SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON_UPSTREAM)');			echo "- common-w64-upstream / common-w64efi-upstream / common-x64-upstream: SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON_UPSTREAM_2014Q3)');	echo "- common-w64-upstream-2014Q3: SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON_UPSTREAM_2015Q1)');	echo "- common-w64-upstream-2015Q1: SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON_DEVEL_UPSTREAM)');	echo "- common-w32-upstream-devel:  SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_COMMON_DEVEL_UPSTREAM)');	echo "- common-w64-upstream-devel:  SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_IVI_UPSTREAM)');		    echo "- ivi-upstream: SNAPSHOT=$$sid"
	@sid=$$(bin/get_snapshot '$(URL_IVI_UPSTREAM_M14_3)');	    echo "- ivi-upstream-m14.3: SNAPSHOT=$$sid"
	@echo
	@echo "QA targets:"
	@echo "- qa-w32 TARGET=lenovoXX SUITE=yyyyy: local QA report for 32 bits target"
	@echo "- qa-w64 TARGET=lenovoXX SUITE=yyyyy: local QA report for 64 bits target"
	@echo "- qa-w32-upstream TARGET=lenovoXX SUITE=yyyyy: upstream QA report for 32 bits target"
	@echo "- qa-w64-upstream TARGET=lenovoXX SUITE=yyyyy: upstream QA report for 64 bits target"
	@echo "- qa-w64-daily TARGET=lenovoXX: more daily tests reported upstream"
	@echo "- qa-w64-weekly TARGET=lenovoXX: extended tests reported upstream"


