#!/usr/bin/perl -w
use strict;
use FindBin qw($Bin $Script);
use lib "$Bin/../lib";
use Getopt::Long;
use Collect qw(Read_fasta);

my ($Db_file,$Qr_file,$genewise_dir,$genewise_shell_file,$Solar_extend,$Genewise);
GetOptions(
	"Qr:s"=>\$Qr_file,
	"Db:s"=>\$Db_file,
	"wise_dir:s"=>\$genewise_dir,
	"wise_shell_file:s"=>\$genewise_shell_file,
	"solar_extend:s"=>\$Solar_extend,
	"genewise:s"=>\$Genewise
);

my $solar_file = shift;
my @corr;
open IN,$solar_file || die $!;
while (<IN>) {
	s/^\s+//;
	my @t = split /\s+/;
	my $query = $t[0];
	my $strand = $t[4];
	my ($query_start,$query_end) = ($t[2] < $t[3]) ? ($t[2] , $t[3]) : ($t[3] , $t[2]);#sort query id,protein sequence;
	my $subject = $t[5];
	my ($subject_start,$subject_end) = ($t[7] < $t[8]) ? ($t[7] , $t[8]) : ($t[8] , $t[7]);#sort subject id,genome sequence;
	push @corr, [$query,$subject,$query_start,$query_end,$subject_start,$subject_end,"","",$strand]; ## "query_seq" "subject_fragment"
}
close IN;
my %fasta;
&Read_fasta($Qr_file,\%fasta);
foreach my $p (@corr) {
	my $query_id = $p->[0];
	$query_id =~ s/-D\d+$//;
	if (exists $fasta{$query_id}) {
		$p->[6] = $fasta{$query_id}{seq};# give it the protein sequence;
	}
}
undef %fasta;
#my %fasta;
&Read_fasta($Db_file,\%fasta);
foreach my $p (@corr) {
	if (exists $fasta{$p->[1]}) {
		my $seq = $fasta{$p->[1]}{seq};#give it the genome sequence;
		my $len = $fasta{$p->[1]}{len};#give it the genome length;
		$p->[4] -= $Solar_extend;
		$p->[4] = 1 if($p->[4] < 1);
		$p->[5] += $Solar_extend;
		$p->[5] = $len if($p->[5] > $len);
		$p->[7] = substr($seq,$p->[4] - 1, $p->[5] - $p->[4] + 1);
	}
}
undef %fasta;
mkdir "$genewise_dir" unless (-d "$genewise_dir");
my $subdir = "000";
my $loop = 0;
my $cmd;
foreach my $p (@corr) {
	if($loop % 200 == 0){
		$subdir++;
		mkdir("$genewise_dir/$subdir");
	}

	my $qr_file = "$genewise_dir/$subdir/$p->[0].fa";
	my $db_file = "$genewise_dir/$subdir/$p->[0]_$p->[1]_$p->[4]_$p->[5].fa";
	my $rs_file = "$genewise_dir/$subdir/$p->[0]_$p->[1]_$p->[4]_$p->[5].genewise";

	open OUT, ">$qr_file" || die "fail creat $qr_file";
	print OUT ">$p->[0]\n$p->[6]\n";
	close OUT;
	open OUT, ">$db_file" || die "fail creat $db_file";
	print OUT ">$p->[1]_$p->[4]_$p->[5]\n$p->[7]\n";
	close OUT;

	my $choose_strand = ($p->[8] eq '+') ? "-tfor" : "-trev";
	$cmd .= "$Genewise $choose_strand -sum -gff -genesf $qr_file $db_file > $rs_file 2> /dev/null;\n";
	$loop++;
}
undef @corr;

open OUT, ">$genewise_shell_file" || die "fail creat $genewise_shell_file";
print OUT $cmd;
close OUT;
