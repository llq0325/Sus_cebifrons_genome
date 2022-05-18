#!/usr/bin/perl -w
use strict;

open IN,$ARGV[0] || die "$!\n";
#open OUT,">$ARGV[1]" || die "$!\n";

$/=">";<IN>;$/="\n";
my $all_len=0;
while (<IN>){
	my $id=$1 if (/^(\S+)/);
	$/='>';
	my $seq=<IN>;
	chomp($seq);
	$seq=~s/\s//g;
	$seq=~tr/atcg/ATCG/;
	my $len=length($seq);

#	print ">$id\t$len\n";

	$all_len +=$len;

	$/="\n";
}
close IN;

print ">total_length\t$all_len\n";
#print OUT "$all_len\n";
#close OUT;

