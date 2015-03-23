VERSION=1.0

all: opentizen-config

opentizen-config: opentizen-config.tar
	@echo $$(( $$(<RELEASE) + 1 )) >RELEASE
	@echo "Building RELEASE $$(<RELEASE)"
	../bin/tar2rpm.sh -t / --arch noarch --version 1.0 --release $$(<RELEASE).$$(date +%Y%m%d%H%M%S) $<
	createrepo .

clean:
	rm -rf x86_64 noarch

