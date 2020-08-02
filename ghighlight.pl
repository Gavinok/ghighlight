#! /usr/bin/env perl

# ghighlight - A simple preprocessor for adding code highlighting in a groff file

# Copyright (C) 2014-2018 Free Software Foundation, Inc.

# Written by Bernd Warken <groff-bernd.warken-72@web.de>.

my $version = '1.2.6';

# This file is part of 'ghighlight', which is part of 'groff'.

# 'groff' is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.

# 'groff' is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You can find a copy of the GNU General Public License in the internet
# at <http://www.gnu.org/licenses/gpl-2.0.html>.

########################################################################

use strict;
use warnings;
#use diagnostics;

# temporary dir and files
use File::Temp qw/ tempfile tempdir /;

# needed for temporary dir
use File::Spec;

# for 'copy' and 'move'
use File::Copy;

# for fileparse, dirname and basename
use File::Basename;

# current working directory
use Cwd;

# $Bin is the directory where this script is located
use FindBin;


########################################################################
# system variables and exported variables
########################################################################

$\ = "\n";	# final part for print command

########################################################################
# read-only variables with double-@ construct
########################################################################

our $File_split_env_sh;
our $File_version_sh;
our $Groff_Version;

my $before_make;		# script before run of 'make'
{
  my $at = '@';
  $before_make = 1 if '@VERSION@' eq "${at}VERSION${at}";
}

my %at_at;
my $file_perl_test_pl;
my $groffer_libdir;

if ($before_make) {
  my $highlight_source_dir = $FindBin::Bin;
  $at_at{'BINDIR'} = $highlight_source_dir;
  $at_at{'G'} = '';
} else {
  $at_at{'BINDIR'} = '@BINDIR@';
  $at_at{'G'} = '@g@';
}


########################################################################
# options
########################################################################

foreach (@ARGV) {
  if ( /^(-h|--h|--he|--hel|--help)$/ ) {
    print q(Usage for the 'ghighlight' program:);
    print 'ghighlight [-] [--] [filespec...] normal file name arguments';
    print 'ghighlight [-h|--help]        gives usage information';
    print 'ghighlight [-v|--version]     displays the version number';
    print q(This program is a 'groff' preprocessor that handles highlighting source code ) .
      q(parts in 'roff' files.);
    exit;
  } elsif ( /^(-v|--v|--ve|--ver|--vers|--versi|--versio|--version)$/ ) {
    print q('ghighlight' version ) . $version;
    exit;
  }
}


#######################################################################
# temporary file
#######################################################################

my $out_file;
{
  my $template = 'ghighlight_' . "$$" . '_XXXX';
  my $tmpdir;
  foreach ($ENV{'GROFF_TMPDIR'}, $ENV{'TMPDIR'}, $ENV{'TMP'}, $ENV{'TEMP'},
	   $ENV{'TEMPDIR'}, 'tmp', $ENV{'HOME'},
	   File::Spec->catfile($ENV{'HOME'}, 'tmp')) {
    if ($_ && -d $_ && -w $_) {
      eval { $tmpdir = tempdir( $template,
				CLEANUP => 1, DIR => "$_" ); };
      last if $tmpdir;
    }
  }
  $out_file = File::Spec->catfile($tmpdir, $template);
}


########################################################################
# input
########################################################################

my $source_mode = 0;

foreach (<>) {
  chomp;
  s/\s+$//;
  my $line = $_;
  my $is_dot_Source = $line =~ /^[.']\s*SOURCE(|\s+.*)$/;

  unless ( $is_dot_Source ) {	# not a '.SOURCE' line
    if ( $source_mode ) {		# is running in SOURCE mode
      print OUT $line;
    } else {			# normal line, not SOURCE-related
      print $line;
    }
    next;
  }


  ##########
  # now the line is a '.SOURCE' line

  my $args = $line;
  $args =~ s/\s+$//;	# remove final spaces
  $args =~ s/^[.']\s*SOURCE\s*//;	# omit .SOURCE part, leave the arguments

  my @args = split /\s+/, $args;

  ##########
  # start SOURCE mode
  if ( @args == 0 || @args == 1 && $args[0] eq 'start' ) {
    # For '.SOURCE' no args or first arg 'start' means opening 'SOURCE' mode.
    # Everything else means an ending command.
    if ( $source_mode ) {
      # '.SOURCE' was started twice, ignore
      print STDERR q('.SOURCE' starter was run several times);
      next;
    } else {	# new SOURCE start
      $source_mode = 1;
      open OUT, '>', $out_file;
      next;
    }
  }

  ##########
  # now the line must be a SOURCE ending line (stop)

  unless ( $source_mode ) {
    print STDERR 'ghighlight.pl: there was a Python ending without being in ' .
      'SOURCE mode:';
    print STDERR '    ' . $line;
    next;
  }

  $source_mode = 0;	# 'SOURCE' stop calling is correct
  close OUT;		# close the storing of 'SOURCE' commands

  ##########
  # run source-highlight on file
  # array stores prints with \n
  my $sourcecode = `source-highlight -f groff_mm_color  --output STDOUT -i $out_file`;
  print $sourcecode;
  my @print_res = (1);

  # Start argument processing

  # remove 'stop' arg if exists
  shift @args if ( $args[0] eq 'stop' );

  # if ( @args == 0 ) {
  #   # no args for saving, so @print_res doesn't matter
  #   next;
  # }
  # my @var_names = ();
  # my @mode_names = ();

  # my $mode = '.ds';
  # for ( @args ) {
  #   if ( /^\.?ds$/ ) {
  #     $mode = '.ds';
  #     next;
  #   }
  #   if ( /^\.?nr$/ ) {
  #     $mode = '.nr';
  #     next;
  #   }
  #   push @mode_names, $mode;
  #   push @var_names, $_;
  # }

  # my $n_vars = @var_names;

  # if ( $n_vars < $n_res ) {
  #   print STDERR 'ghighlight: not enough variables for Python part: ' .
  #     $n_vars . ' variables for ' . $n_res . ' output lines.';
  # } elsif ( $n_vars > $n_res ) {
  #   print STDERR 'ghighlight: too many variablenames for Python part: ' .
  #     $n_vars . ' variables for ' . $n_res . ' output lines.';
  # }
  # if ( $n_vars < $n_res ) {
  #   print STDERR 'ghighlight: not enough variables for Python part: ' .
  #     $n_vars . ' variables for ' . $n_res . ' output lines.';
  # }

  # my $n_min = $n_res;
  # $n_min = $n_vars if ( $n_vars < $n_res );
  # exit unless ( $n_min );
  # $n_min -= 1; # for starting with 0

  # for my $i ( 0..$n_min ) {
  #   my $value = $print_res[$i];
  #   chomp $value;
  #   print $mode_names[$i] . ' ' . $var_names[$i] . ' ' . $value;
  # }
}


1;
# Local Variables:
# mode: CPerl
# End:
