#!/usr/bin/perl
#!/bin/sh

=head1 name

	fa_quality.pl

=head1 descripyion
	 
	 @ARGV  input fa file 
	 -len
	 -gap
	 -N
	 -gc
	 -Head
	 

=head1 author

	nixiaoming   nixiaoming@genomics.cn

=head1 version	    

	1.0

=head1 example
	
	perl  fa_quality.pl -h
	perl  fa_quality.pl -Head -len -gap -N -gc > out_file

=cut
use warnings;
use strict;
use Getopt::Long;

my ($help,$len,$gap,$N,$gc,$Head);
GetOptions(
	"help"=>\$help,	
	"len"=>\$len,
	"gap"=>\$gap,
	"N"=>\$N,
	"gc"=>\$gc,
	"Head"=>\$Head,
);
die `pod2text $0` if ( $help );
die `pod2text $0` if ( @ARGV==0 );
my @files=@ARGV;
foreach my $fa (@files) {
	open FILE,$fa or die "Can't open the fa file $fa ";
#	open OUT,'>',$fa.'.quality.xls' or die "Can't open the fa file $fa.quality.xls ";
	if (defined $Head) {
		my $tab='ID';
		if (defined $len) {
			$tab.="\t".'len';
		}
		if (defined $N) {
			$tab.="\t".'N%';
		}
		if (defined $gc) {
			$tab.="\t".'GC%';
		}
		if (defined $gap) {
			$tab.="\t".'gap';
		}		
#		print OUT $tab."\n";
		print $tab."\n";
	}

        my $circle=0;
	my $total_len; $total_len=0;
	my $total_N; $total_N=0;
        my $total_GC; $total_GC=0;
	my $total_gap_num; $total_gap_num=0;

	$/=">";<FILE>;$/="\n";
	while (<FILE>) {
		chomp;
		my $head=$_;
		my $title=$1 if($head=~/^(\S+)/);
		$/=">";
		my $seq=<FILE>;
		chomp $seq;
		$seq=~s/\s+//g;
		$/="\n";

#		print OUT $title;
		print  $title;
		
		my $Len=length($seq);
		$total_len +=$Len;

		if (defined $len) {
#			print OUT "\t".$Len;
			print "\t".$Len;
		}
		if (defined $N) {
			
			my $N=$seq=~tr/Nn/Nn/;
			$total_N +=$N;

                        my $N_rate;
			if ($N != 0) {
				$N_rate=$N/$Len*100;
#				printf OUT "\t%.4f",$N;
				printf "\t%.2f",$N_rate;
			}else{
#				print OUT "\t".$N;
				print "\t".$N;
			}			
		}
		if (defined $gc) {

			my $GC=$seq=~tr/GCgc/GCgc/;
			$total_GC +=$GC;

			my $GC_rate=$GC/$Len*100;
#			printf OUT "\t%.4f",$GC;
			printf "\t%.2f",$GC_rate;
		}
		if (defined $gap) {
			my $number=0;
			while ($seq=~/N{1,}/gi) {
				$number++;
			}
#			print OUT "\t".$number;
			print "\t".$number;
			$total_gap_num++ if ($number>0);
		}
#		print OUT "\n";
                print  "\n";		
		$circle++;
	}
        print  "\n";
	
        print  "Quality\tAverage_len\ttotal_N%\ttotal_GC%\tGap_circle_rate%\n";
	print  "Total";
	printf  "\t%.2f",$total_len/$circle;
	printf  "\t%.2f",$total_N/$total_len*100;
	printf  "\t%.2f",$total_GC/$total_len*100;
	printf  "\t%.2f",$total_gap_num/$circle*100;

	close FILE;
#	close OUT;
}
