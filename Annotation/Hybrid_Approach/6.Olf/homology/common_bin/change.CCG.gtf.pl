#! usr/bin/perl -w
use strict;
my $gtf_change=shift;
#`awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$12}' $gtf > ./$gtf.change`;
open IN,"$gtf_change";
while(<IN>){
	chomp;
	my @arry=split /\t/,$_;
	my $id=$1 if($arry[8]=~ /transcript_id "([^"]+)"/);
	print "$arry[0]\t$arry[1]\tmRNA\t$arry[3]\t$arry[4]\t$arry[5]\t$arry[6]\t$arry[7]\tID=$id;\n" if($arry[2]=~/transcript/);
	print "$arry[0]\t$arry[1]\tCDS\t$arry[3]\t$arry[4]\t$arry[5]\t$arry[6]\t$arry[7]\tParent=$id;\n" if($arry[2]=~/exon/);
}
