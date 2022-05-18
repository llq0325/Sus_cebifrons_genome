#!/usr/bin/perl

use strict;

die "perl $0 attr.file > outfile\n" if @ARGV < 1;

my $infile=shift;

open IN,$infile or die $!;
while(<IN>){
	next if /^#/;
	chomp;
	my @a=split /\t/;
	my @aa=split /;/,$a[2];
	for(my $i=0;$i<@aa;$i++){
		print "$a[0]\t$a[1]\t$aa[$i]\n";
	}
}
close IN;
