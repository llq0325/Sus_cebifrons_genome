#!/usr/bin/perl -w
use strict;

die "usage: perl filter_glean_genome.pl <genome.fa> <evidence.gff> <out_file>\n" if (@ARGV < 3);

open IN1,"$ARGV[0]" ||die "$!\n";
$/='>';<IN1>;$/="\n";
my %sequen;
while(<IN1>){
	chomp;
	my $id=$1 if(/^(\S+)/);
        $/='>';
	my $seq=<IN1>;
	chomp($seq);
	$sequen{$id}=$seq;
	$/="\n";
}
close IN1;

open IN2,"$ARGV[1]" || die "$!\n";
my %data;
while(<IN2>){
	next if (/^#/);
	chomp;
	my @lines=split(/\t/,$_);
	$data{$lines[0]}=1;
}
close IN2;

open OUT,">$ARGV[2]" ||die "$!\n";
foreach my $key(keys %sequen){
	print OUT ">$key\n$sequen{$key}" if (exists $data{$key});
}
close OUT;
