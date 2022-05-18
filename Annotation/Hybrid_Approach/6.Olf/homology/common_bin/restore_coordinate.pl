#!/usr/bin/perl -w 
use strict;
use FindBin qw($Bin $Script);
use Data::Dumper;

die "Usage: $0 <pre_gff> <new_gff> <new_seqment_seq> \n" if @ARGV<3;

my $gff1=shift;
my $gff2=shift;
my $sequence=shift;

open IN1,"$gff1" || die "$!\n";
my %gff1;
while (<IN1>){
	chomp;
	next if (/^\#/);
	my @info=split(/\t/);
	if ($info[8]=~/^ID=(\S+?);/){
		my $id=$1;
		push @{$gff1{$id}},(@info);
#                print Dumper (%gff1);
	}
}
close IN1;

open IN2,"$gff2" || die "$!\n";
my %gff2;
my $num=0;
while (<IN2>){
       chomp;
       next if (/^\#/);
       my @info=split(/\t/);
       if ($info[8]=~/^ID=(\S+?);/ || $info[8]=~/^Parent=(\S+?);/){
	       my $id="$1\_$num";
	       push @{$gff2{$id}},(@info);
#	        print Dumper ($id);
       }
       $num++;
}
close IN2;

open IN3,"$sequence" || die "$!\n";
my %seq_len;
$/=">";<IN3>;$/="\n";
while (<IN3>){
	my $scaf=$1 if (/^(\S+)/);
	$/=">";
	my $seq=<IN3>;
        chomp($seq);
	$seq=~s/\s+//g;
	$seq=~tr/atcg/ATCG/;
	$/="\n";
	$seq_len{$scaf}=length($seq);
}
close IN3;
#print Dumper (%seq_len);

open OUT ,">$gff2.restore" || die "$!\n";
foreach my $geneid2(sort keys %gff2){
	my $name=$gff2{$geneid2}[0];
	my $start2=$gff2{$geneid2}[3];
	my $end2=$gff2{$geneid2}[4];
	my $strand2=$gff2{$geneid2}[6];
	my $len2=$seq_len{$name};

	my $scaf1=$gff1{$name}[0];
	my $start1=$gff1{$name}[3];
	my $end1=$gff1{$name}[4];
	my $strand1=$gff1{$name}[6];

	my($start,$end);
        if ($strand1 eq "+"){
		if (($start1-1000)>=0){
			$start=($start1-1000)+$start2;
			$end=($start1-1000)+$end2;
		}else{
                        $start=$start2;
		        $end=$end2;
		}
		$strand2 =($strand2 eq "+") ? "+" :"-";

	}else{
		if(($start1-1000)>=0){
			$start=($start1-1000)+($len2-$end2);
			$end=($start1-1000)+($len2-$start2);
		}else{
			$start=$len2-$end2;
			$end=$len2-$start2;
		}
		$strand2 =($strand2 eq "+") ? "-" :"+";

	}
	
		print OUT "$scaf1\tAUGUSTUS\t$gff2{$geneid2}[2]\t$start\t$end\t$gff2{$geneid2}[5]\t$strand2\t$gff2{$geneid2}[7]\t$gff2{$geneid2}[8]\n";
}
close OUT;
         
        `perl $Bin/sort_gff.pl $gff2.restore > $gff2.restore.gff`;
	`rm -rf $gff2.restore`;


#	`perl /ifs2/BC_GAGP/Group/zhongxiao/Litchi/gene/cDNA_map_genome/unigene1_513_map/Unigene_unoverlapOGS.gene.structure/gff_id_sort.pl $gff2.restore.coordinate.sort > $gff2.restore.coordinate.id.sort`;




















