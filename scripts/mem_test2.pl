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
	return $x;
}

my $x1 = big_string;
Dump $x1;
my $x2 = big_string;
Dump $x2;

__END__
