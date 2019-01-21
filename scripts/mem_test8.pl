#!/usr/bin/env perl

#use strict;
use warnings;
use Devel::Peek;
use feature 'say';
$Devel::Peek::pv_limit = 16;

sub big_string {
	my $offset = shift;

	local $x;
	Dump $x;
	$x = (chr(ord("a") + $offset)) x (80000 - $offset * 16);
	Dump $x;
	return;
}

big_string(1);
#Dump \&big_string;
big_string(2);

__END__
