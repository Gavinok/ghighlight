#.SUFFIXES:
.SUFFIXES: .ms .pdf

TESTSRCS=$(shell find -type f -name '*.ms' )
TARGET := $(addsuffix .pdf,$(basename $(TESTSRCS)))
TESTDIR=test
PDFS=$(shell find -type f -name '*.pdf' )

all: run

run: ${TESTSRCS}
	perl -Mstrict -Mdiagnostics -cw ghighlight.pl $<

man: ${TESTSRCS}
	export GHLENABLECOLOR=1 && ./ghighlight.pl $< | groff -Tascii -w w -ms

%.pdf: %.ms
	./ghighlight.pl $< | groff -Tps -w w -ms > ./$@

test: ${TARGET}
	zathura $<
	make clean

clean:
	rm -f ${PDFS}

.PHONY: clean all lint test
