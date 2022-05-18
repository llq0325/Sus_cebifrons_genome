#!/usr/bin/perl -w
use strict;

open IN,$ARGV[0] || die "$!\n";
#open OUT,">$ARGV[1]"|| die "$!\n";

my ($scaf,$seq,%genome);
$/=">";<IN>;$/="\n";
while(<IN>){
	$scaf=$1 if (/^(\S+)/);
	$/=">";
	$seq=<IN>;
	chomp($seq);
	$seq=~s/\s+//g;
	$seq=~tr/atcg/ATCG/;
        $/="\n";
	$genome{$scaf}=$seq;
#	print OUT ">$scaf\n$seq\n";
}
close IN;

open OUT,">$ARGV[1]"|| die "$!\n";
foreach my $name(keys %genome){
	$seq=$genome{$name};

        my $len=length($seq);
	next if ($len<2000);

	print OUT ">$name\n";
	for(my $i=0; $i<$len; $i +=50) {
		my $seq2=substr($seq,$i,50);#."\n";
		print OUT "$seq2\n";
	}
}
close OUT;
      
