#!/use/bin/perl

use strict;
use Getopt::Long;
use FindBin qw($Bin);

die "perl $0 fasta > outfile\n" if @ARGV < 1;
my $infile=shift;
open IN,$infile or die $!;
while(<IN>){
	if(/^(>\S+)/){
		print $1."\n";
	}else{
		print $_;
	}
}
close IN;
