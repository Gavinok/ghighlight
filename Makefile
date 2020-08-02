#.SUFFIXES:
.SUFFIXES: .ms .pdf

TESTSRCS=$(shell find -type f -name '*.ms' )
TARGET := $(addsuffix .pdf,$(basename $(TESTSRCS)))

all: run

run: ${TESTSRCS}
	./ghighlight.pl $<

%.pdf: %.ms
	./ghighlight.pl $< | groff -Tps -w w -ms > $@

test: ${TARGET}
	zathura $<

clean:
	rm -f *.pdf

.PHONY: clean all lint test
