
.PHONY: all clean install

ALLSRC = $(wildcard *.[1-9]qa.txt)
ALLHTML = $(ALLSRC:.txt=.html)
ALLMAN = $(ALLSRC:.txt=.gz)
MANDIR = /usr/share/man

all: $(ALLHTML) $(ALLMAN)

clean:
	rm -r man[1-9]qa 2>/dev/null || true
	rm *.[1-9]qa.gz *.[1-9]qa.html 2>/dev/null || true

%.html: %.txt
	asciidoc --doctype=manpage --backend=html5 $<

%.gz: %.txt
	a2x --doctype=manpage --format=manpage $<; gzip -f $(<:.txt=)

install-man-pages: $(ALLMAN)
	@if [ $$(whoami) != root ]; then echo you should be root; exit 1; fi; 
	@for mp in *.*qa.gz; do \
	    d="$(MANDIR)/man$$(echo $$mp|sed 's:.*\.\([1-9]qa\).gz:\1:')"; \
	    if ! [ -d $$d ]; then mkdir -p $$d; fi; \
	    l=$$d/$$mp; \
	    if [ -f $$l ]; then rm $$l; fi; \
	    cp $$mp $$l ; \
	done
	@mandb -p

