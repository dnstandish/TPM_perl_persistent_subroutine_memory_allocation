#!/usr/bin/env perl

use strict;
use warnings;
use Devel::Peek;
$Devel::Peek::pv_limit = 16;
use FindBin;
use lib "$FindBin::Bin/../lib";
use ProcVM;

sub get_const {
	return chr(ord("a")) x 800000;
}

sub recur {
	my $cnt = shift;
	my $limit = shift;
	return if $cnt >= $limit;
	$cnt++;
	ProcVM::print_proc_vm();
    print "sub $cnt\n";
		recur($cnt, $limit);
	my $s;
	Dump $s;
    $s = get_const();
	Dump $s;
}

print "cycle 1\n";
recur(0, 20);
recur(20, 45);
ProcVM::print_proc_vm();

#Dump \&recur;
#print "sub 21\n";
#ProcVM::print_proc_vm();




