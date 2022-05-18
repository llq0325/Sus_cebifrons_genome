#!/usr/bin/perli -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;

my $help=<<USAGE;
	-l <int>	least length of hits.
	-p <int 0~100>	least percentage of aa.
	-h		show this help information.
USAGE

my $len=20;	# the least length.
my $per=20;	# the least percentage.

my %opt;
GetOptions(\%opt,"l:i","p:i","h");
$len=$opt{l};
$per=$opt{p};

die $help if(@ARGV < 1 || $opt{h});

my $infile=shift;

# ENSP00000000233-D12     180     43      174     +       C26646944       436     2       397     1       73.33   43,174; 2,397;  64.39;
open IN,$infile or die $!;
while(<IN>){
	chomp;
	next if /^#/;
	my @a=split /\t/;
	next if ($a[10] < $per || abs($a[3]-$a[2]) < $len);
	print join("\t",@a)."\n";
}
close IN;
