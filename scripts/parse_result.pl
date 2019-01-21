#!/usr/bin/env perl


use Getopt::Long;
use strict;
use warnings;
use autodie; 
use Chart::Gnuplot;
use List::Util qw( max );
use Data::Dumper;
use feature 'say';
sub usage {
	print <<"EUSAGE";
usage: $0 [-h] result_file
EUSAGE

	exit 9;
}

my $help;
my $title = "Test";
my $out_file = "test.eps";
my @vm;
my $max_cycle = 1;
if ( ! GetOptions('title=s', \$title, 'vm=s', \@vm, 'cycle=i', \$max_cycle, 'out=s', \$out_file, 'help', \$help) || $help ) {
	usage();
}
my %vm_set = map { ($_,1) } @vm;

sub escape_enhanced_text {
	my $s = shift;
	$s =~ s/[_^{}\\@&~]/\\\\$&/g;
	return $s;
}

say escape_enhanced_text('a_b');
sub parse_file {
	my $file = shift;
	my $is_suffix_title = shift;
	my $vm_include = shift;
	my $max_cycle = shift;

    # data[cycle]->{vmstat}->[x,y]
    #
    open my $fd, '<', $file;
	my @data;
	
	my $cycle = 0;
	my $call_no = 0;
    #my @xdata;
    #my @ydata;
	while (<$fd>) {
		if ( /^(Vm\w*):\s*(\d+)/ ) {
			if ( ! $vm_include  || $vm_include->{$1} ) {
				$data[$cycle]->{$1} //= [];
				push @{$data[$cycle]->{$1}}, [$call_no, $2];
			}
#		@{$datra{$1}}, 
#		push @ydata, $1;
#		push @xdata, $call_no;
#		print $1, "\n" if $cycle < 2;
		}
		elsif ( /^sub (\d+)/ ) {
			$call_no = $1;
		}
		elsif ( /^cycle\s+(\d+)/ ) {
			$cycle = $1;
			$call_no = 0;
			$call_no = 0;
			print;
			last if $cycle > $max_cycle;
		}
	}
	close $fd;
	$max_cycle = $cycle if $cycle < $max_cycle;

#	print Dumper( \@data );

	my $max_x = 0;
	my $max_y = 0;

	for my $cdat ( @data ) {
		for my $vm ( keys %$cdat ) {
			for my $dat ( @{$cdat->{$vm}} ) {
				$max_x = $dat->[0] if $dat->[0] > $max_x;
				$max_y = $dat->[1] if $dat->[1] > $max_y;
			}
		}
	}

	say "max x $max_x";
	say "max y $max_y";
	$max_y = ( int( $max_y / 1024 ) + 2 ) * 1024;

	my @datasets;
	for my $vm (sort  keys %{$data[1]} ) {
		say $vm;
		my (@x, @y);
		for my $cycle ( 1 .. $max_cycle ) {
			push @x, map { $_->[0] } @{$data[$cycle]->{$vm}};
#	unshift @x, $data[0]->{$vm}->[0]->[0];
			push @y, map { $_->[1] } @{$data[$cycle]->{$vm}};
#	unshift @y, $data[0]->{$vm}->[0]->[1];
		}
		say join( " ", @x ); 
		say join( " ", @y ); 
		my $series_title = $vm;
		if ( $is_suffix_title ) {
			$series_title .= " $file";
		}
		my $dataset = Chart::Gnuplot::DataSet->new(
			xdata => \@x,
			ydata => \@y,
			title => escape_enhanced_text($series_title),
			style => 'linespoints',
			);

		push @datasets, $dataset 
	}
	return { 
		file => $file,
		datasets => \@datasets,
		max_x => $max_x,
		max_y => $max_y,
	}
}

my $is_multifile = @ARGV > 1;
my @all_file_data;
for my $f ( @ARGV ) {
	my $file_data =  parse_file (
		$f,
		$is_multifile,
		(@vm ? \%vm_set: 0),
		$max_cycle,
		);
	push @all_file_data, $file_data;
}
my $max_x = max map { $_->{max_x} }  @all_file_data;
my $max_y = max map { $_->{max_y} }  @all_file_data;

my $chart = Chart::Gnuplot->new(
	output => $out_file,
	title => $title,
	xlabel => "sub calls",
	ylabel => "kb",
	xrange => [0, $max_x],
	yrange => [0, $max_y],
	);

$chart->plot2d( map { @{$_->{datasets}} } @all_file_data );
__END__

