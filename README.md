# ghighlight

This is a groff preprocessor written in perl that will highlight your code for you. All of the syntax highlighting is done by [GNU Source-highlight](https://www.gnu.org/software/src-highlite/#mozTocId323328) This way the highlighting can be modified and customized as needed. Currently the only macros supported are mm and ms macros.


### NOTE

This project is currently in alpha stages and still needs work before it is functional.

### Prerequisites

You will need the following programs installed:

- Perl (only tested on 5.3)
- GNU Source-highlight
- Groff


### Installing

Edit the Makefile and set the PREFIX for ghighlight to be installed. Then 

``` sh
sudo make install
```

## Usage

Inside your groff file add `.SOURCE start`  and `.SOURCE stop` to start and stop a source code section. source-highlight will automatically detect the syntax based on the source code inside the block. The stop in `.SOURCE stop` is optional and can be replaced with `.SOURCE`

By default ghighlight uses black and white mode to enable color simple set the environmental `GHLENABLECOLOR=1` warning color support is still buggy.

For global use add this to your bashrc or zshrc
```sh
export GHLENABLECOLOR=1
```

For one time use 
```sh
GHLENABLECOLOR=1 && ghighlight INPUTFILE.ms | groff ... > OUTPUTFILE
```

FILE.ms
```roff
.NH
This Is A Heading
.LP
this is a paragraph

.\" start source code block
.SOURCE start
#! /usr/bin/env perl

my $version = 'This is a source code block';
print $line; 
.SOURCE stop
.\" end source code block
```

![Usage Diagram](/image/diagram.png)

```sh
ghighlight FILE.ms | groff -T pdf -ms > output.pdf
```

To specify a syntax use `.SOURCE <language>`
```roff
.SOURCE c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    int i = 0;
    printf("hello\n");
    return 0;
}
.SOURCE stop
```

An alternatives to `.SOURCE is .\`\`` used like so
```roff
.`` c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    int i = 0;
    printf("hello\n");
    return 0;
}
.``
```

![Output](./demo.png)

if you are using ".so"-makros in your files, you must combine the files beforehand using **soelim**, e.g.:

`soelim MAIN.ms | ghighlight | groff -Tpdf > MAIN.pdf`

## Source Arguments

Currently, two instructions are available to customize your code display: `ps` and `vs`.

```roff
.\" There I change the font size and the spacing between lines.
.`` c ps=7 vs=9p
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    printf("hello\n");
    return 0;
}
.``
```

## Environment variables

* GH_INTRO: troff instructions **before** each source code provided by source-highlight
* GH_OUTRO: troff instructions **after** each source code provided by source-highlight

Both GH_INTRO and GH_OUTRO: values are separated by ';'.

Example:

`GH_INTRO=".DS I;.fam C" GH_OUTRO=".fam;.DE" ghighlight file.ms | ...`

* SHOPTS: cmd line parameter given to source-highlight

Example:

`SHOPTS="--outlang-def=./my-groff-output.def" ghighlight file.ms | ...`

## Contributing

Please read [CONTRIBUTING.md](https://github.com/Gavinok/ghighlight/contributing.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Todo
- [x] Toggling (color instead of bold ) (using ENV ENABLECOLORS)
- [x] Arguments to specify language in case source-highlight doesn't recognize it
- [x] Correct error messages
- [ ] Support for mom macros

## Breaking Changes
* Makefile now removes the .pl from ghighlight.pl

## Authors

* **Gavin Jaeger-Freeborn** - *Initial work* - [Gavinok](https://github.com/Gavinok)

See also the list of [contributors](https://github.com/Gavinok/ghighlight/contributors) who participated in this project.

## License

This project is licensed under the GNU General Public License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* gperl written by Bernd Warken was used as the basis for this project
  * Contains a similar .\`\` macro for source code that inspired the preprocessor macro

## Similar works
* [ugrid](https://github.com/pjfichet/ugrind) A troff pre-processor to highlight blocks of code. Fork of Vgrind and Vfontdrp.
* [Mono](https://github.com/Alhadis/Mono) Troff macros for the 21st century.
  * Contains a similar .\`\` macro for source code that inspired the preprocessor macro
* [mom macros](http://schaffter.ca/mom/momdoc/docelement.html#code) has support for in line code blocks.
