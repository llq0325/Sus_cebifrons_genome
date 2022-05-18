use warnings;
use strict;
my $bed_file = $ARGV[0];#"/public/home/linzeshan/project/01.conserve/Type_one_re_fileter/new_method/work/29.bed";
my $maf_file = $ARGV[1];#"../data/maf2list/29/29.maf.lst";
my $work_dir = $ARGV[2];

my @arr = ("Camel","Cat","Cheetah","Dog","Dolphin","Horse","Human","MinkeWhale","Mouse","Pig","SpermWhale");
my $species = {};
foreach my $arr(@arr){
	$species->{$arr} = 1;
}

open BED,$bed_file or die $!;
open MAF,$maf_file or die $!;

my $word = <MAF>;
my @first_line = split(/\t/,$word);
my $num = @first_line;
my @locate_arr;

for(my $i = 0;$i<$num;$i++){
	push (@locate_arr,$i) if (exists ($species->{$first_line[$i]}));
}
foreach my $j(@locate_arr){
	print $j."\t";
}

open OUT,">$work_dir/work.out" or die $!;
open ERR,">$work_dir/work.err" or die $!;

while(<BED>){
	my @array = split(/\t/,$_);
	my $pause = "nn";
	for(my $i=$array[1];$i<=$array[2];$i++){
		next if $i == 0;
		my $chu = 1;
		while(1){
			my $nt;
			if ($pause ne "nn"){
				$nt = $pause;
				$pause = "nn";
			}
			else {
				$nt = <MAF>;
			}
			my @nt = split(/\t/,$nt);
			if ($i>$nt[1]){
				next;
			}
			elsif($i == $nt[1]){
				foreach my $pocky(@locate_arr){
					if ($nt[$pocky] ne "-"){
					$chu = 0;
					}
				}
				last;
			}
			else{
				$pause = $nt;
				print ERR "worng bed $i maf $nt[1]\n";
				last;
			}
		}
		print OUT "$i\t+\n" if $chu == 1;
		print OUT "$i\t-\n" if $chu == 0;
	}
}
