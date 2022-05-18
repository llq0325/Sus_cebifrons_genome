#!/usr/bin/perl -w
use strict;
use Data::Dumper;

my $gff=shift;

my %hash;
open IN1,"$gff" ||die "$!\n";
while (<IN1>){
	chomp;
	my $line = $_;
	next if (/^#/);
	my @info=split(/\t/);
	my $id = $1 if ($info[8]=~/=A(\d+);/);
	
	$hash{$id}{mRNA}=\@info if ($info[2]=~/mRNA/);
	push @{$hash{$id}{CDS}}, [@info] if ($info[2]=~/CDS/);
}

close IN1;


foreach my $k1 (sort {$a <=> $b} keys %hash){
	print join("\t",@{$hash{$k1}{mRNA}})."\n";
		
	@{$hash{$k1}{CDS}} = sort {$a->[3]<=>$b->[3] or $a->[4]<=>$b->[4]} @{$hash{$k1}{CDS}};

	for (my $i=0;$i<@{$hash{$k1}{CDS}};$i++ )
	{
		print join("\t",@{$hash{$k1}{CDS}[$i]})."\n";
	}
}
