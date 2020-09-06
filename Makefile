#.SUFFIXES:
.SUFFIXES: .ms .pdf

TESTSRCS=test.ms
TARGET := $(addsuffix .pdf,$(basename $(TESTSRCS)))
TESTDIR=test
PDFS=$(shell find -type f -name '*.pdf' )

all: run

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
	rm -f ${PDFS}

.PHONY: clean all lint test
