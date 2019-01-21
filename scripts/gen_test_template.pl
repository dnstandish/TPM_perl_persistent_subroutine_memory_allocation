#!/usr/bin/env perl


use Getopt::Long;
use strict;
use warnings;
use autodie; 
use Template;

sub usage {
	print <<"EUSAGE";
usage: $0 [-h] -nfunc numer_of_functions -size string_size [-aundef] [-cundef] [-use_devel_peek] [-dump] -out outfile -repeat_call n_call_subs
EUSAGE

	exit 9;
}
my $help;
my $n_func = 1;
my $n_call = 1;
my $size = 1;
my $assign_undef = 0;
my $call_undef = 0;
my $use_devel_peek;
my $do_dump = 0;
my $out;
my $template_file;

if ( ! GetOptions( 'help', \$help, 'nfunc=i', \$n_func, 'size=i', \$size, 'repeat_call=i', \$n_call, 'aundef', \$assign_undef, 'cundef', \$call_undef, 'use_devel_peek', \$use_devel_peek, 'dump', \$do_dump, 'out=s', \$out, 'template=s', \$template_file ) || $help || $n_func < 1 || $size < 1 || $n_call < 1 || !defined $out ) {
	usage();
}
if ( $call_undef && $assign_undef ) {
	print STDERR "speficy only one of -aundef and -cundef\n";
	usage();
}


my $config = {
	INCLUDE_PATH => '.',
	POST_CHOMP => 1,
};
my $template = Template->new($config);
my $input = $template_file;

open my $fd, '>', $out;

$template->process( $input,
{
	template_file => $template_file,
	use_devel_peek => $use_devel_peek,
	n_func => $n_func,
	n_call => $n_call,
	suf_list => [ 1 .. $n_func ],
	call_list => [ 1 .. $n_call ],
	size => $size,
	assign_undef => $assign_undef,
	call_undef => $call_undef,
},
	$fd,
	) || die $Template::ERROR, "\n";

close $fd;
chmod 0755, $out;




