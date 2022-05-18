#!/usr/bin/perl
use strict;
use warnings;

die "Usage:$0 <all.out.pair.gff.end.gs> <human.gff> \n\n" if @ARGV<2;

my $gs=shift;
my $gff=shift;

my %Gene;
open IN,$gff or die "$!";
while(<IN>){
	next if /^#/;
	chomp;
	my @c=split(/\t/);
	if ($c[2] eq 'mRNA' && $c[8]=~/ID=([^;]+)/){
		@{$Gene{$1}{mRNA}}=@c;
	}elsif ($c[2] eq 'CDS' && $c[8]=~/Parent=([^;]+)/){
		push @{$Gene{$1}{CDS}},[@c];
	}
}
close IN;

my %Index;
open IN,$gs or die "$!";
while(<IN>){
	next if /^>/;
	chomp;
	my @c=split(/\t/);
	my $pid;
	if ($c[0]=~/(\S+)-D\d+/){
		$pid=$1;
		$Index{$pid}++;
	}else{
		die;
	}
	print join("\t",@{$Gene{$c[0]}{mRNA}}[0..7],$Gene{$c[0]}{mRNA}[8]."Index=$pid\_$Index{$pid};")."\n";
	foreach my $cds (@{$Gene{$c[0]}{CDS}}){
		print join("\t",@$cds)."\n";
	}
}
close IN;
