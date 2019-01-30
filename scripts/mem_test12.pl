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
sub big_string {
    my $size = shift;
    my $x;
    Dump $x;
    $x = one_big($size);
    Dump $x;
}

big_string( 80_000 );
big_string( 40_000 );

__END__
