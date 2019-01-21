#!/usr/bin/env perl

use strict;
use warnings;
use Devel::Peek;
use feature 'say';
$Devel::Peek::pv_limit = 16;

sub big_string {
	my $x;
	Dump $x;
	$x = "a" x 80000;
	Dump $x;
	$x = "b";
	Dump $x;
	$x = 1;
	Dump $x;
}
big_string;

__END__
