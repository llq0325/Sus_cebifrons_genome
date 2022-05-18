#!/usr/bin/perl

use strict;

die "perl $0 <Synteny.out> > outfile\n" if @ARGV < 1;

my $file=shift;
#10     22556432        12755   35997   23243   -       scaffold304     2262840 2296633 33794
#ENSGALP00000004070      ENSGALP00000004070-D1
my %hit;
open IN,$file or die $!;
$/="#";<IN>;$/="\n";
while(<IN>){
	$/="#";
	my $info=<IN>;
	chomp $info;
	$/="\n";
	next if($info =~ /^\s+/);
	my %flog;
	my @lines=split /\n/,$info;
	for(my $i=0;$i<@lines;$i++){
		my ($pid,$sid)=("","");
		($pid,$sid)=($1,$2) if($lines[$i]=~/(\S+)\s+(\S+)/);
		$flog{$pid}++;
		if($flog{$pid}==1){
			$hit{$pid}{hit}++;
			$flog{$pid}++;
		}
		if($sid eq '.' || $sid =~/^\s+/){
			$hit{$pid}{miss}++;
			push @{$hit{$pid}{genes}},'-';
			next;
		}
		$hit{$pid}{match}++;
		push @{$hit{$pid}{genes}},$sid;
	}
}
close IN;

for my $id(keys %hit){
	my $type;
	if($hit{$id}{hit} == 1){
		if(not exists $hit{$id}{match}){
			$type='miss';
		}elsif($hit{$id}{match} == 1){
			$type='single';
		}else{
			$type='multi';
		}
	}else{
		if(not exists $hit{$id}{match}){
			$type='partial_miss';	
		}elsif($hit{$id}{match} == 1){
			$type='partial_single';
		}else{
			$type='partial_multi';
		}
	}
	if($type eq 'partial_single'){
		my $v1=shift @{$hit{$id}{genes}};
		my $v2=shift @{$hit{$id}{genes}};
		if($v1 eq '-'){
			push @{$hit{$id}{genes}},$v2;
		}else{
			push @{$hit{$id}{genes}},$v1;
		}
	}
	# delete the redundancy in the partial_multi and change some attribute into what they real are.
	if($type eq 'partial_multi'){
		my @aa;
		for(my $i=0;$i<@{$hit{$id}{genes}};$i++){
			my $flog=0;
			for(my $j=$i+1;$j<@{$hit{$id}{genes}};$j++){
				$flog=1 if($hit{$id}{genes}[$i] eq $hit{$id}{genes}[$j]);
			}
			push @aa,$hit{$id}{genes}[$i] if ($flog == 0);
		}
		$type = 'single' if(scalar @aa == 1);
		@{$hit{$id}{genes}}=@aa;
	}
	print join("\t",$id,$type,join(";",@{$hit{$id}{genes}}))."\n";
}
