#!/usr/bin/env perl

use strict;
use warnings;
use Devel::Peek;
use feature 'say';
$Devel::Peek::pv_limit = 16;

sub big_const {
	return "a" x 80000;
}
sub big_string {
#	my $offset = shift;
	my $x;
	Dump $x;
	#$x = chr(ord("a") + $offset)  x 80000;
	#$x = "a" x 80000;
	$x = big_const;
	Dump $x;
	return substr( $x, 0, 400);
#	return $x;
}
{
my $y1 = big_string(1);
Dump $y1;


my $y2 = big_string(2);
Dump $y2;
}

__END__
