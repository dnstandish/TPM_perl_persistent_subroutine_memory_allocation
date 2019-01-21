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
	$x = undef;
	Dump $x;
	return;
}

big_string;
big_string;

__END__
