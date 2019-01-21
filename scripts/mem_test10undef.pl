#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use ProcVM;
use Devel::Peek;
$Devel::Peek::pv_limit = 16;

sub big_string {
	my $size = shift;

    return "a" x $size;
}

sub mem_test {
	my $size = shift;
	print STDERR "mem_test $size\n";
	my $s;
	Dump $s;
    big_string( $size );
    $s = big_string( $size );
	undef $s ;#if $size == 0;
	Dump $s;
	return;
}

print "cycle 1\n";
my $i = 1;
#for my $kb ( 256, 512, 768, 1024, 768, 512, 256, 512, 768, 1024, 2048, 1024, 768, 512, 256, 128, 0, 256, 512, 768 ) {
for my $kb ( 250, 500, 750, 1000, 750, 500, 250, 500, 750, 1000, 2000, 1000, 750, 500, 250, 500, 750 ) {
ProcVM::print_proc_vm();
print "sub $kb\n";
mem_test( $kb * 1024 - 4 );
$i++
}
ProcVM::print_proc_vm();




