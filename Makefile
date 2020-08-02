#.SUFFIXES:
.SUFFIXES: .mm .pdf

TESTSRCS=$(shell find -type f -name '*.mm' )
TARGET := $(addsuffix .pdf,$(basename $(TESTSRCS)))

all: run

run: ${TESTSRCS}
	./source-highlight.pl $<

%.pdf: %.ms
	./source-highlight.pl $< | groff -Tps -w w -ms > $@

test: ${TARGET}
	zathura $<

open: test.pdf
	zathura $<

clean:
	rm -f *.pdf

.PHONY: clean all lint test
