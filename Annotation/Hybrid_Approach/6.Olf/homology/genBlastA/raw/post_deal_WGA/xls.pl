#!/usr/bin/perl
use strict;
use warnings;

die "Usage:$0 <dog.fa.len> <dog.nr.tab> <WGA.NotWGA.nr.gff> <all.out.pair.gff.end.gs> <WGA.NotWGA.nr.cds> <dog.genewise.gff> <all.out.pair>\n" if @ARGV<7;

my $genome_len=shift;
my $nr_tab=shift;
my $all_gff=shift;
#my $ref_sort=shift;
my $gs_file=shift;
my $all_cds=shift;
my $all_all_gff=shift;
my $all_pair=shift;

my %Len;
read_len($genome_len,\%Len);

my %WGA;
read_tab($nr_tab,\%WGA);

my %Cover;
my %G;
read_gff($all_all_gff,\%G,\%Cover);

my %Gene;
my %Cover2;
read_gff($all_gff,\%Gene,\%Cover2);

my %Cls;
#read_ref($ref_sort,\%Cls);

my %GS;
read_gs($gs_file,\%GS);

my %Stop;
read_cds($all_cds,\%Stop);

my %Pair;
read_pair($all_pair,\%Pair);

sub read_pair{
	my ($file,$p)=@_;
	open IN,$file or die "$!";
	while(<IN>){
		chomp;
		my @c=split(/\t/);
		if ($c[2] ne '-' ){
			$p->{$c[2]}=$c[1];
		}
	}
	close IN;
}

foreach my $scaf ( sort {$Len{$b}<=>$Len{$a}} keys %Gene ){
	my @sort = sort {$Gene{$scaf}{$a}{start} <=> $Gene{$scaf}{$b}{start}} keys %{$Gene{$scaf}};
	my ($WGA,$chr,$cover);
	if ( exists $WGA{$scaf} ){
		$WGA='yes';
		$chr=$WGA{$scaf}{chr};
		$cover=sprintf("%.2f",$WGA{$scaf}{len}/$Len{$scaf}*100);
	}else{
		$WGA='no';
		$chr='-';
		$cover=0;
	}
	my @scaf_attr=($scaf,$Len{$scaf},$WGA,$chr,$cover);
	for (my $i=0;$i<@sort;$i++){
		my $type;
		if (@sort==1){	
			$type='single'
		}else{
			if ($i==0){
				$type='5end';
			}elsif($i==@sort-1){
				$type='3end';
			}else{
				$type='inter';
			}
		}
		my $id=$sort[$i];
		my $p=$Gene{$scaf}{$id};
		$Stop{$id}=0 if not defined $Stop{$id};
		$GS{$id}=0 if not defined $GS{$id};
		$Cls{$id}{num}=0 if not defined $Cls{$id}{num};
		$Cls{$id}{cover}=0 if not defined $Cls{$id}{cover};
		if ( not defined $Pair{$id} ){
			$Pair{$id}='not' if $WGA eq 'no';
			$Pair{$id}='out' if $WGA eq 'yes';
		}
		my @gene_attr=($id,$$p{str},$$p{start},$$p{len},$$p{cds},$$p{exon},$$p{cover},$$p{shift},$Stop{$id},$GS{$id},$Cls{$id}{num},$Cls{$id}{cover},$Pair{$id},$type);
		print join("\t",@scaf_attr,@gene_attr)."\n";
	}
		
}


sub read_cds{
	my ($file,$p)=@_;
	open IN,$file or die "$!";
	$/=">";<IN>;$/="\n";
	while(<IN>){
		my ($id,$seq);
		if (/^(\S+)/){	
			$id=$1;
		}else{
			die;
		}
		$/=">";
		$seq=<IN>;
		chomp $seq;
		$/="\n";
		$seq=~s/\s//g;
		my $num=0;
		for (my $i=0;$i<=length($seq)-3;$i+=3){
			my $codon=substr($seq,$i,3);
			$num++ if ($codon eq 'TGA' || $codon eq 'TAA' || $codon eq 'TAG' );
		}
		$p->{$id}=$num;
	}
	close IN;
}

sub read_stop{
	my ($file,$p)=@_;
	open IN,$file or die "$!";
	while(<IN>){
		if (/^(\S+)\s+(\d+)/){
			$p->{$1}=$2;
		}
	}
	close IN;
}

sub read_gs{
	my ($file,$p)=@_;
	open IN,$file or die "$!";
	my $gs=0;
	while(<IN>){
		if (/^>\S+\s+\d+\s+(\d+)/){
			$gs=$1;
		}else{
			if (/^(\S+)/){
				$p->{$1}=$gs;
			}
		}
	}
	close IN;
}

sub read_ref{
	my ($file,$p)=@_;
	open IN,$file or die "$!";
	while(<IN>){
		chomp;
		my @c=split(/\t/);
		$p->{$c[2]}{num}=$c[0];
		if ( $c[0] == $c[1] ){
			$p->{$c[2]}{cover}=0;
		}else{
			my $idx=$c[1]+1;
			$p->{$c[2]}{cover}=$Cover{$c[$idx]};
		}
	}
	close IN;
}

sub read_gff{
	my ($file,$p,$p2)=@_;
	open IN,$file or die "$!";
	while(<IN>){
		next if /^#/;
		chomp;
		my @c=split(/\t/);
		@c[3,4] = @c[4,3] if $c[3]>$c[4];
		if ($c[2] eq 'mRNA' && $c[8]=~/ID=([^;]+);Shift=(\d+);/){
			$$p{$c[0]}{$1}{shift}=$2;
			$$p{$c[0]}{$1}{start}=$c[3];
			$$p{$c[0]}{$1}{len}=abs($c[4]-$c[3])+1;
			$$p{$c[0]}{$1}{str}=$c[6];
			$$p{$c[0]}{$1}{cover}=$c[5];
			$p2->{$1}=$c[5];
		}elsif ($c[2] eq 'CDS' && $c[8]=~/Parent=([^;]+)/){
			$$p{$c[0]}{$1}{exon}++;
			$$p{$c[0]}{$1}{cds}+=abs($c[4]-$c[3])+1;
		}
	}
	close IN;
}	

sub read_tab{
	my ($file,$p)=@_;
	open IN,$file or die "$!";
	while(<IN>){
		chomp;
		my @c=split(/\t/);
	  	if (exists $p->{$c[6]} ){
			$p->{$c[6]}{len}+=$c[9];
			if ( $p->{$c[6]}{chr}!~/$c[0];/ ){
				$p->{$c[6]}{chr}.=$c[0].";";
			}
		}else{
			$p->{$c[6]}{len}=$c[9];
			$p->{$c[6]}{chr}=$c[0].";";
		}	
	}
	close IN;
}


sub read_len{
	my ($file ,$p)=@_;
	open IN,$file or die "$!";
	while(<IN>){
		if (/^(\S+)\s+(\S+)/){
			$p->{$1}=$2;
		}
	}
	close IN;
}

