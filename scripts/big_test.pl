#!/usr/bin/env perl


use feature 'say';

sub dbl_str {
	return $_[0] . $_[0];
}

my $s = 'x';
for my $i ( 1 .. 100 ) {
	print "$i ", length($s), "\n";
	$s = dbl_str( $s );
}

__END__




