#!/usr/bin/perl -w
=head1 Version:
	
	Version:1.0,2010-10-27.
	Edited by fanguangyi,Email:fanguangyi@genomics.org.cn.

=head1 Usage:
	
	perl  [options] query.seq reference.seq
	options:
	-c [int]: identity of alingment.[default 90] 
	-o [str]: prefix of output.[default reference.seq]
	-m [str]: memery of qsub [default 2G]
	-q [str]: queue [bc_gag.q]
	-help   : Usage of the program.
	
Tip:	Generally,est sequence is query.seq,scaffold sequence is reference.seq.
=cut
use strict;
use File::Basename qw(basename);
use FindBin qw($Bin);
use Getopt::Long;
my ($cut,$prefix,$memery,$queue,$help);
GetOptions(
	"o:s"=>\$prefix,
	"c:i"=>\$cut,
	"m:s"=>\$memery,
	"q:s"=>\$queue,
	"help"=>\$help
);
die `pod2text $0` if(@ARGV<2 || $help);
my $query=$ARGV[0];
my $ref=$ARGV[1];
chomp($ref);
$prefix ||=basename($ref);
$cut ||=90;
$queue ||="bc_gag.q";
$memery ||= "2G";
my $cwd=`pwd`;
chomp($cwd);
#my $pro="/share/raid1/genome/bin";

##############################  blat  #######################################################
my @len=(0,200,500,1000);
`perl $Bin/fastaDeal.pl -cutf 5 $query`;
`perl $Bin/osh.pl 1 5 $prefix.blat /opt/blc/genome/bin/blat  $ref $cwd/$query.cut/$query.# -out=blast $cwd/$query.cut/$query.blat_out.#`;
print STDERR "Running blat...\n";
`split -l 1 $prefix.blat.sh $prefix.blat.sh_`;
`sh $prefix.blat.sh_aa`;
`sh $prefix.blat.sh_ab`;
`sh $prefix.blat.sh_ac`;
`sh $prefix.blat.sh_ad`;
`sh $prefix.blat.sh_ae`;
`rm $prefix.blat.sh_aa $prefix.blat.sh_ab $prefix.blat.sh_ac $prefix.blat.sh_ad $prefix.blat.sh_ae `;
#`perl $Bin/qsub-sge.pl -resource vf=$memery -queue $queue $prefix.blat.sh`;
print STDERR "Finished blat...\n";
`cat $cwd/$query.cut/$query.blat_out* >$cwd/$query.blat_out.cat`;
#`rm -rf $query.cut`;
open BLAT,">$prefix.blat.output";
printf BLAT ("%8s\t%7s\t%10s\t%7s\t%8s\t%8s\t%8s\t%8s\n","Dataset","Number","Total_len","avg_cov",">90\%_Num",">90\%_per%",">50\%_Num",">50\%_per%");
for(my $i=0;$i<4;$i++){
	my $t=$len[$i];
	`$Bin/map_contig2ref -b $query.blat_out.cat -i $cut -q $t -c >$query.blat_out.cat_90_$t.stat`;
	`tail -12 $cwd/$query.blat_out.cat_90_$t.stat >tail_12_$t.blat_out`;
	my $file_tmp="$cwd/tail_12_$t.blat_out";
	my ($ratio,$num_90,$num_50)=Coverage_ratio($file_tmp);
	my ($num,$t_len)=Fa_len_stat($query,$t);
	`rm tail_12_$t.blat_out`;
	printf BLAT ("%8s\t%7d\t%10d\t%7.2f\t%8d\t%8.2f\t%8d\t%8.2f\n",">$t)bp",$num,$t_len,$ratio,$num_90,$num_90/$num*100,$num_50,$num_50/$num*100);
}
sub Coverage_ratio{
	my $in=shift;
	my ($ratio,$num_90,$num_50);
	open I,$in;
	while(<I>){
		chomp;
		if(/Coverage\s+ratio\s+(\d+\.\d+)/){
			$ratio=$1;		
		}elsif(/Coverage\s+between\s+90---100%\s+(\d+)/){
			$num_90=$1;		
		}elsif(/Coverage\s+higher\s+than\s+50%\s+(\d+)/){
			$num_50=$1;		
		}
}
	return($ratio,$num_90,$num_50);
}

sub Fa_len_stat{
	my ($r,$c)=@_;
	`/ifs2/BC_GAGP/Group/fangy/bin/faSize -detailed $r >$r.size`;
	open SIZE,"<$r.size";
	my $n=0;my $t_l=0;
	while(<SIZE>){
		chomp;
		my @size=split;
		if($size[1]>=$c){
			$n++;
			$t_l+=$size[1];
		}
	}
	return ($n,$t_l);
}

