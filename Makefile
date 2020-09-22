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

%.pdf: %.ms
	soelim $< | ./ghighlight.pl | groff -Tpdf -w w -ms > $@

test: ${TARGET}
	zathura $<
	# recursivly call make
	$(MAKE) clean

clean:
	rm -f ${PDFS} ghighlight

.PHONY: clean all lint test
