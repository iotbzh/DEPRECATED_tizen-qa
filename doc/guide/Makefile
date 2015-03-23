THEME = qa
THEMEDIR=$$(pwd)/themes/$(THEME)

OPTS = --doctype=book \
	--attribute=stylesdir=$(THEMEDIR)/css \
	--attribute=scriptsdir=$(THEMEDIR)/js \
	--attribute=iconsdir=$(THEMEDIR)/icons \
	--conf-file=$$(pwd)/common/asciidoc_document.conf

all: installation.html overview.html usage.html

installation.html :	installation.asciidoc
							asciidoc $(OPTS) $<

overview.html :		overview.asciidoc
							asciidoc $(OPTS) $<

usage.html :	usage.asciidoc		
							asciidoc $(OPTS) $<

clean :
							rm -rf *.html


