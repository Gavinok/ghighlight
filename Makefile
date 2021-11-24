#.SUFFIXES:
.SUFFIXES: .ms .pdf

TESTSRCS=test.ms
TARGET := $(addsuffix .pdf,$(basename $(TESTSRCS)))
TESTDIR=test
PDFS=$(shell find -type f -name '*.pdf' )

PREFIX = /usr/local
# TODO create a manpage for ghighlight
MANPREFIX = ${PREFIX}/share/man

all: run

ghighlight: ghighlight.pl
	cp -f ghighlight.pl ghighlight

install: ghighlight
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f ghighlight ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/ghighlight
	
run: ${TESTSRCS}
	perl -Mstrict -Mdiagnostics -cw ghighlight.pl $<

man: ${TESTSRCS}
	export GHLENABLECOLOR=1 && ./ghighlight.pl $< | groff -Tascii -w w -ms

# GH_INTRO: instructions before each source code provided by source-highlight
# GH_OUTRO: ------------ after  ---- ------ ---- -------- -- ----------------
# GH_INTRO/GH_OUTRO: values are separated by ';'

GH_INTRO = .nr DI 0;.DS I;.fam C
GH_OUTRO = .fam;.DE
# export GH_INTRO
# export GH_OUTRO

# SHOPTS: cmd line parameter given to source-highlight
SHOPTS = --outlang-def=./my-groff-output.def
#export SHOPTS

custom:
	soelim $(TESTSRCS) |\
		GH_INTRO="$(GH_INTRO)" GH_OUTRO="$(GH_OUTRO)" SHOPTS="$(SHOPTS)" ./ghighlight.pl |\
		groff -Tpdf -w w -ms > test.pdf

%.pdf: %.ms
	soelim $< | ./ghighlight.pl | groff -Tpdf -w w -ms > $@

test: ${TARGET}
	zathura $<
	# recursivly call make
	$(MAKE) clean

clean:
	rm -f ${PDFS} ghighlight

.PHONY: clean all lint test
