#!/usr/bin/perl
use strict;
use warnings;

die "Usage:$0 <all.out.pair.NotWGA.over70.pair.gff> <xls.70.out> <cutoff> <single>\n\n" if @ARGV<4;

my $gff=shift;
my $out=shift;
my $cutoff=shift;
my $single=shift;

my %Gene;
open IN,$gff or die "$!";
while(<IN>){
	next if /^#/;
	my @c=split(/\t/);
	if ($c[2] eq 'mRNA' && $c[8]=~/ID=([^;]+)(-D\d+);Shift=(\d+)/){
		$Gene{$1}{$1.$2}-=$3;
	}elsif ($c[2] eq 'CDS' && $c[8]=~/Parent=([^;]+)(-D\d+)/){
		$Gene{$1}{$1.$2}++;
	}
}
close IN;

my %Multi;
foreach my $pid ( sort keys %Gene ){
	foreach my $id ( sort  { $Gene{$pid}{$b}<=>$Gene{$pid}{$a} } keys %{$Gene{$pid}} ){
		if ( $Gene{$pid}{$id} == 1 ){
			$Multi{$pid}=0;
		}else{
			$Multi{$pid}=1;
		}
		last;
	} 
}

open IN,$out or die "$!";
while(<IN>){
	next if /^#/;	
	chomp;
	my @c=split(/\t/);
	next if ($c[17] eq 'not' || $c[17] eq 'out');
	my $pid;
	my $id;
	if ($c[5]=~/^(\S+)(-D\d+)/){
		$pid=$1;	
		$id=$1.$2;
	}
	if ( $single>0 && $Gene{$pid}{$id} > 1 ){
		next;
	}elsif ($single ==0 && $Gene{$pid}{$id}==1){
		next;
	}
	if ( $c[12] + $c[13] >= $cutoff ){
		print join("\t",$c[5],$Gene{$pid}{$id},$c[12],$c[13])."\n";
	}
}
close IN;
