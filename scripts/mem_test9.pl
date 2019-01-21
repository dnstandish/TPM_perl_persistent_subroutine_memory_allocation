#!/usr/bin/env perl

use strict;
use warnings;
use Devel::Peek;
$Devel::Peek::pv_limit = 16;


sub sub_gen {
	my $offset = shift;
    print STDERR "gen $offset\n";
	my $s;
	Dump $s;
    $s = (chr(ord("a") + $offset)) x 800000;
	Dump $s;
	return { 
		info => sub {
			print STDERR "info $offset\n";
			Dump $s;
		},
		clear => sub {
			print STDERR "clear $offset\n";
			undef( $s );
		},
	}
}

my $c1 = sub_gen( 1 );
my $c2 = sub_gen( 2 );
$c1->{info}->();
$c1->{clear}->();
$c1->{info}->();
$c2->{info}->();
$c2->{clear}->();
$c2->{info}->();



