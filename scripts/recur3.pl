#!/usr/bin/env perl

use strict;
use warnings;
use Devel::Peek;
$Devel::Peek::pv_limit = 16;
use FindBin;
use lib "$FindBin::Bin/../lib";
use ProcVM;

sub get_const {
    my $descale = shift;
    $descale -= 10;
    $descale = 1 if $descale < 1;
    return chr(ord("a")) x ( 800000 / $descale );
}

sub recur {
    my $cnt = shift;
    my $limit = shift;
    return if $cnt >= $limit;
    $cnt++;
    ProcVM::print_proc_vm();
    print "sub $cnt\n";
    my $s;
    Dump $s;
    $s = get_const( $cnt );
    Dump $s;
    return recur($cnt, $limit);
}

print "cycle 1\n";
recur(0, 20);
recur(20, 45);
recur(45, 50);
ProcVM::print_proc_vm();

Dump \&recur;




