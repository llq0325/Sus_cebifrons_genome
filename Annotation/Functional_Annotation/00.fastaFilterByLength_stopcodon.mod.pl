#! /usr/bin/perl
use strict;

my $seq_fa = shift;
my $length_cut = shift;
my $length_file = shift;

my($seq_id,$Seq,$len,$key1,$key2);
my %hash;

open(F,$seq_fa) or die;
open(N,">$length_file") or die;
$/=">";<F>;$/="\n";

while(<F>)
{
	chomp;
	my$aa=$_;
	$aa=~s/\s+/_/g;
	$seq_id=$aa;
	$/=">";
	$Seq=<F>;
	chomp $Seq;
	$/="\n";
	$Seq=~s/\n//g;
	$len=length$Seq;
	my $count1=$Seq=~tr/././;
	my $count2=$Seq=~tr/U/U/;
	#print N "$seq_id\t$len\n";
	if (($len < $length_cut)||$count1>0||$count2>0) {
		print ">$seq_id\n$Seq\n";
	}
	else{
		print N ">$seq_id\n$Seq\n";
	}
}
close N;
close F;
