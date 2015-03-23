# some help
help:
	@echo ""
	@echo "PRODUCTION OF TEST PLANS"
	@echo ""
	@echo "To produce all the test plans, type:"
	@echo ""
	@echo "  make all"
	@echo "or"
	@echo "  make"
	@echo ""
	@echo "To produce the test plan for tp-gnome.asciidoc, type:"
	@echo ""
	@echo "  make gnome"
	@echo ""
	@echo "To produce the test plan for tp-xxxx.asciidoc, type:"
	@echo ""
	@echo "  make xxxx"
	@echo ""
	@echo "To remove produced files"
	@echo ""
	@echo "  make clean"
	@echo ""

# configuration (can be overwritten on the command line)

THEME = qa
MODE = publish
#MODE=devel

# macro for executables

THEMEDIR = $$(pwd)/themes/$(THEME)

OPTS = --doctype=book \
	--attribute=stylesdir=$(THEMEDIR)/css \
	--attribute=scriptsdir=$(THEMEDIR)/js \
	--attribute=iconsdir=$(THEMEDIR)/icons 

ASCIIDOC = asciidoc $(OPTS) --conf-file=$$(pwd)/common/asciidoc_document.conf

QAEXPORT = ../../bin/qaexport

# rules

ALLDOC = $(wildcard tp-*.asciidoc)
ALLTP = $(ALLDOC:tp-%.asciidoc=%)

.PHONY: $(ALLTP)

all: $(ALLTP)

clean:
	rm -f *.html export_tc_*.asciidoc

$(ALLTP): % : tp-%.html
	@echo "moving $@ to its revision"
	@revision=$$(grep :revnumber: tp-$@.asciidoc |cut -d' ' -f2);\
	 mv tp-$@.html tp-$@-$${revision:-x.y}.html

export_tc_%.asciidoc:
	@echo "Extracting test cases includes $@"
	@$(QAEXPORT) -p doc$(@:export_tc_%.asciidoc=%) -t asciidoc_$(MODE) -o $$(pwd)/$@

tp-%.html: tp-%.asciidoc export_tc_%.asciidoc
	@echo "creating the test plan $@"
	@[ -f $@ ] && rm $@ || true
	@$(ASCIIDOC) -o $@ $(@:%.html=%.asciidoc)
	@chmod a+r $@ || true

