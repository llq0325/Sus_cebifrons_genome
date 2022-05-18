#!/usr/bin/perl -w
use strict;

die "usage:perl $0 <pre_seq> <seq_len_cutoff> <line_leng_cutoff> \n"if(@ARGV<1);

my $pre_seq=shift;

my $Seq_length_cutoff=shift;
$Seq_length_cutoff ||= 150;
my $Line_length=shift;
$Line_length ||= 50;

my $file_out="$pre_seq.$Seq_length_cutoff";

open (IN,$pre_seq) || die "$!\n";
my ($scaf,$seq,%genome);
$/=">";<IN>;$/="\n";
while(<IN>){
	chomp;
	$scaf=$_;
#	$scaf=$1 if (/^(\S+)/);
	$/=">";
	$seq=<IN>;
	chomp($seq);
	$seq=~s/\s+//g;
	$seq=~tr/atcg/ATCG/;
        $/="\n";
	$genome{$scaf}=$seq;
}
close IN;

open OUT,"> $file_out"|| die "$!\n";
foreach my $name(keys %genome){
	$seq=$genome{$name};
        
	my $len=length($seq);
	next if ($len<$Seq_length_cutoff);

	print OUT ">$name\n";
	for(my $i=0; $i<$len; $i +=$Line_length) {
		my $seq2=substr($seq,$i,$Line_length);#."\n";
		print OUT "$seq2\n";
	}
}
close OUT;
      
