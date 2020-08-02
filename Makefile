#.SUFFIXES:
.SUFFIXES: .mm .pdf

TESTSRCS=$(shell find -type f -name '*.mm' )
TARGET := $(addsuffix .pdf,$(basename $(SRCS)))

all: run

run: ${TESTSRCS}
	./source-highlight.pl $<

test.pdf: ${TESTSRCS}
	./source-highlight.pl $< | groff -Tps -w w -ms > $@

open: test.pdf
	zathura $<

clean:
	rm -f *.pdf

.PHONY: clean all lint test
