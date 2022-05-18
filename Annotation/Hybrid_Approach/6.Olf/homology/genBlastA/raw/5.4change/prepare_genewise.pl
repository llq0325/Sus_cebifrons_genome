#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use lib "$Bin/../lib";
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
my $Gff=shift;
my %gff;
read_gff($Gff,\%gff) if($Gff);
my @corr;
open IN, "$solar_file" || die "fail $solar_file";
#ENSGALP00000000003-D1   77      1       76      +       Scaffold151     6292079 3074470 3075302 2       98.70   1,42;37,76;
while (<IN>) {
   s/^\s+//;
  my @t = split /\s+/;
  my $query = $t[0];
  my $strand = $t[4];
  my ($query_start,$query_end) = ($t[2] < $t[3]) ? ($t[2] , $t[3]) : ($t[3] , $t[2]);
  my $subject = $t[5];
  my ($subject_start,$subject_end) = ($t[7] < $t[8]) ? ($t[7] , $t[8]) : ($t[8] , $t[7]);
  push @corr, [$query,$subject,$query_start,$query_end,$subject_start,$subject_end,"","",$strand]; ## "6:query_seq""7:subject_fragment"	
}
close IN;
my %fasta;
&Read_fasta($Qr_file,\%fasta);
foreach my $p (@corr) {
     my $query_id = $p->[0];
	$query_id =~ s/-D\d+$//;
	if (exists $fasta{$query_id}) {
	   $p->[6] = $fasta{$query_id}{seq};
	}
}
undef %fasta;
#my %fasta;
&Read_fasta($Db_file,\%fasta);
foreach my $p (@corr) {
        if (exists $fasta{$p->[1]}) {
	   my $parent_id=$p->[0];
	      $parent_id=$1 if($parent_id =~ /(\S+)-D\d+/);#get query id protein again
		     #print "$parent_id\n";
	   my @a=sort {$a->[3] <=> $b->[3]} @{$gff{$parent_id}} if(exists $gff{$parent_id});#sort exon coordinate of query id,
	   my ($query_head_gap,$query_tail_gap)=(0,0);
	      ($query_head_gap,$query_tail_gap)=call($p->[2],$p->[3],\@a) if(scalar @a > 0);#是不是有点多余了，至少有一个外显子么？
#	                $query_head_gap=0 if $query_head_gap < 0;
#			$query_tail_gap=0 if $query_tail_gap < 0;
		        print STDERR "$query_head_gap\t$query_tail_gap\t$p->[2]\t$p->[3]\n";
	      my $seq = $fasta{$p->[1]}{seq};
	      my $len = $fasta{$p->[1]}{len};
	     #print  join("\t",$p->[0],$p->[1],$len,$p->[2],$p->[3],$p->[4],$p->[5],$p->[8],$query_head_gap,$query_tail_gap,$a[0]->[6]);
		 $p->[4] -= ($Param->{'filter-solar'}{extent}+$query_head_gap) if($p->[8] eq '+'); 
		 $p->[4] -= ($Param->{'filter-solar'}{extent}+$query_tail_gap) if($p->[8] eq '-');
		 $p->[4] = 1 if($p->[4] < 1);
		 $p->[5] += ($Param->{'filter-solar'}{extent}+$query_tail_gap) if($p->[8] eq '+');
		 $p->[5] += ($Param->{'filter-solar'}{extent}+$query_head_gap) if($p->[8] eq '-');
		 $p->[5] = $len if($p->[5] > $len);
			#print "\t$p->[4]\t$p->[5]\n";
		 $p->[7] = substr($seq,$p->[4] - 1, $p->[5] - $p->[4] + 1); 
	}
}
undef %fasta;
     mkdir "$genewise_dir" unless (-d "$genewise_dir");
     my $parentdir="00";
     my $subdir = "000";
     my $parentloop=0;
     my $loop = 0;
     my $cmd;
     foreach my $p (@corr) {
	   if($loop % 100 == 0){
	      if($parentloop % 100 ==0){
		 $parentdir++;
		 mkdir ("$genewise_dir/$parentdir");
		 $subdir="000";
	       }
	       $subdir++;
	       mkdir("$genewise_dir/$parentdir/$subdir");
	       $parentloop++;
	   }
	   my $qr_file = "$genewise_dir/$parentdir/$subdir/$p->[0].fa";
	   my $db_file = "$genewise_dir/$parentdir/$subdir/$p->[0]_$p->[1]_$p->[4]_$p->[5].fa";
	   my $rs_file = "$genewise_dir/$parentdir/$subdir/$p->[0]_$p->[1]_$p->[4]_$p->[5].genewise";
	      open OUT, ">$qr_file" || die "fail creat $qr_file";
	      print OUT ">$p->[0]\n$p->[6]\n";
	      close OUT;
	      open OUT, ">$db_file" || die "fail creat $db_file";
	      print OUT ">$p->[1]_$p->[4]_$p->[5]\n$p->[7]\n";
	      close OUT;

	   my $choose_strand = ($p->[8] eq '+') ? "-tfor" : "-trev";
	      $cmd .= "$config{genewise} $choose_strand -sum -gff -genesf $qr_file $db_file > $rs_file 2> /dev/null\n";
	      $loop++;
    }
    undef @corr;
    open OUT, ">$genewise_shell_file" || die "fail creat $genewise_shell_file";
    print OUT $cmd;
    close OUT;
sub read_gff{
	my ($file,$hash)=@_;
	open IN,$file or die $!;
	while(<IN>){
		next if /^#/;
		chomp;
		my @a=split /\t+/;
		@a[3,4]=@a[4,3] if($a[3] > $a[4]);
		if($a[2] eq 'CDS' && $a[8] =~ /Parent=([^;\s]+)/){
			push @{$$hash{$1}},[@a];#将同一个基因ID的外显子坐标存起来
		}
	}
	close IN;
}
sub call{
	my ($gap_head,$gap_tail,$array)=@_;#get the protein start and stop in the solar file,and then query coordinate in the gff file
#	print STDERR join("\n",@{$array})."\n";
	$gap_head--;
	$gap_head=$gap_head*3;
	$gap_tail=$gap_tail*3;
	my ($head_gap,$tail_gap,$cds_len)=(0,0,0);
	if($array->[0]->[6] eq '+'){
		for(@$array){
			$cds_len+=($_->[4]-$_->[3]+1);
			if($cds_len > $gap_head && $head_gap == 0){
				$head_gap=($_->[3]+($gap_head-$cds_len+($_->[4]-$_->[3]+1)));
			}
			if($cds_len >= $gap_tail && $tail_gap == 0){
				$tail_gap=($_->[3]+($gap_tail-$cds_len+($_->[4]-$_->[3]+1)-1));
			}
		}
		($head_gap,$tail_gap)=($head_gap-$array->[0]->[3],$array->[-1]->[4]-$tail_gap);
		return ($head_gap,$tail_gap);
	}else{
		for(reverse @$array){
#			print STDERR join("\t",@{$_})."\n";
			$cds_len+=($_->[4]-$_->[3]+1);
			if($cds_len > $gap_head && $head_gap == 0){
				$head_gap=($_->[3]+($cds_len-$gap_head)-1);
			}
			print STDERR "$cds_len\t$gap_tail\n";
			if($cds_len >= $gap_tail && $tail_gap == 0){
				$tail_gap=($_->[3]+$cds_len-$gap_tail);
			}
		}
		print STDERR "$tail_gap\n";
		($head_gap,$tail_gap)=($array->[-1]->[4]-$head_gap,$tail_gap-$array->[0]->[3]);
		return ($head_gap,$tail_gap);
	}
}
