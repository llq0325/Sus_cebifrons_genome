#!/usr/bin/perl 


###########################################################################
#																																																			#
#			Trfparser: a perl program to parse the results from Tandem Repeat Finder (http://tandem.bu.edu/trf/trf.html)		#
#			Requirements: Unix OS/ perl																																				#
#			Developed By: Deepak Grover																																				#
#			Release date: August 10, 2009, Version: 1																															#
#																																																			#
###########################################################################

use warnings;
use strict;

my ($dat, $flag, $file);

$dat = $ARGV[0];
$flag = $ARGV[1];
chomp($flag);

if (($ARGV[0] eq "") || ($ARGV[1] eq "")) {
	print "Usage: program filename flag\nPlease provide the required parameters and run again\n";
	exit;
}

my @arr = split("dat", $dat);
$file = $arr[0];


open(O1, ">".$file."dat.parse");
print  O1 ("Repeat Start\tRepeat End\tPeriod Size\tCopy No.\tAlignment Score\tConsensus\n");

system("cat ".$file."*txt.html > ".$file."tmp");

open(DAT, $dat) or die ("can not open trf data file");

while(my $line=<DAT>) {

my ($rep_start, $rep_end, $period_size, $copy_no, $pattern_size, $percent_match, $percent_indel, $align_score, $a_percent, $c_percent, $g_percent, $t_percent, $entropy, $consensus, $repeat);			
			chomp($line);
			if ($line =~ /^[0-9]/) {
			my @arr = split(" ", $line);

			$rep_start = $arr[0];
			$rep_end = $arr[1];
			$period_size = $arr[2];
			$copy_no = $arr[3];
			$pattern_size = $arr[4]; 
			$percent_match = $arr[5];
			$percent_indel = $arr[6];
			$align_score = $arr[7];
			$a_percent = $arr[8];
			$c_percent = $arr[9];
			$g_percent = $arr[10];
			$t_percent = $arr[11];
			$entropy = $arr[12];
			$consensus = $arr[13];
			$repeat = $arr[14];
			print O1 ("$rep_start\t$rep_end\t$period_size\t$copy_no\t$align_score\t$consensus\n");
			}

}


& flanking;
system("paste ".$file."dat.parse ".$file."txt.parse > ".$file."final.parse");
exit;

sub flanking {

my ($line_txt, $count, $start, $end, $left_start, $left_end, $right_start, $right_end, $left_seq, $right_seq);
$count = 0;	

open(O2, ">".$file."txt.parse" || die "can not open output file for alignment");
return if($flag==0);
print  O2 ("Left Flanking Sequence\tRight Flanking Sequence\n");

open(TXT, $file."tmp") or die ("can not open trf txt/html file");


while($line_txt=<TXT>) {

				chomp($line_txt);
				my @arr = split("[ :-]", $line_txt);

			if ($line_txt =~ "    Indices:") {
				$start = $arr[6]; 
				$end = $arr[8];
				$count = 1;
			}
			
			elsif  ($line_txt =~ "Left flanking sequence:") {
				$left_start = $arr[5]; 
				$left_end = $arr[9];
				chomp($line_txt = <TXT>);
					until ($line_txt eq "") {
						$left_seq .= $line_txt;
						chomp($line_txt = <TXT>);
						}
			}

			elsif  ($line_txt =~ "Right flanking sequence:") {
				$right_start = $arr[5]; 
				$right_end = $arr[9];
				chomp($line_txt = <TXT>);
					until ($line_txt eq "") {
						$right_seq .= $line_txt;
						chomp($line_txt = <TXT>);
						}
			}

			elsif((($line_txt =~ "Found at i:") || (eof)) && ($count == 1)){
				print  O2 ("$left_seq\t$right_seq\n");
    			$start = $end = $left_start = $left_end = $right_start = $right_end = $count = 0;
    			$left_seq = $right_seq = "";
			}


  }
}


