#!/usr/bin/env perl

use strict;
use warnings;
use Devel::Peek;
use feature 'say';
$Devel::Peek::pv_limit = 16;

sub one_big {
    my $size = shift;
    return "a" x $size;
}

sub none {
    return undef;
}
sub big_string {
    my $size = shift;
    my $x;
    Dump $x;
    $x = one_big(80_000);
    Dump $x;
    $x = none();
    Dump $x;
}

big_string( 80_000 );

__END__
