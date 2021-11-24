.so ./tests/test2.ms

.defcolor darkblue rgb #000999
.defcolor darkred rgb #700000
.defcolor darkgreen rgb #700000
.defcolor brown rgb #700000
.defcolor purple rgb #700000
.defcolor pink rgb #700000
.LP
this is a paragraph

.SOURCE start
#! /usr/bin/env perl

my $version = 'This is a source code block';
.SOURCE stop

.LP
just make sure this prints

.SOURCE start
#! /usr/bin/env perl

my $version = 'This is a source code block';
.SOURCE

.LP
just make sure this prints

.SOURCE perl
#! /usr/bin/env perl

my $version = 'This is a source code block';
.SOURCE

.LP
just make sure this prints

.`` start
#! /usr/bin/env perl

my $version = 'This is a source code block';
print $line;
.`` stop

.`` start
#! /usr/bin/env perl

my $version = 'This is a source code block';
print $line;
.``

.LP
just make sure this prints

.\" start source code block
.`` c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void fun1(){
    int i = 0;
    printf("hello\n");
}
    
int main(int argc, char *argv[])
{
    int t = 1;
    char name[] = "gavin";
    strcpy(name, "o"); // [g][a][v][i][n][\0]
    printf("%s\n", name);
    /* name[0] = "h"; */
    fun1();
    return 0;
}
.`` stop
.\" end source code block

.LP
just make sure this prints

.`` c ps=14 vs=16p
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void fun1(){
    int i = 0;
    printf("hello\n");
}
    
int main(int argc, char *argv[])
{
    int t = 1;
    char name[] = "gavin";
    strcpy(name, "o"); // [g][a][v][i][n][\0]
    printf("%s\n", name);
    /* name[0] = "h"; */
    fun1();
    return 0;
}
.``

.LP
just make sure this prints

.\" this is another code block in c
.`` start
#! /usr/bin/env perl

my $version = 'This is a source code block';
.``
print $line;
.\" end source code block


.`` perl
#! /usr/bin/env perl

my $version = 'This is a source code block';
.`` stop

.LP
just make sure this prints

.SOURCE perl
#! /usr/bin/env perl

my $version = 'This is a source code block';
.`` stop

.`` start
#! /usr/bin/env perl

my $version = 'This is a source code block';
.SOURCE stop

.`` start
#! /usr/bin/env perl

my $version = 'This is a source code block';
.SOURCE
