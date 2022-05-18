#! usr/bin/perl -w
use strict;
#scaffold110     GLEAN   mRNA    509319  509822  0.518447        -       .       ID=termite_GLEAN_10007532;
#perl sort.gff.pl termite_v1.0.fa.Glean.gff > termite_v1.0.fa.Glean.sort.gff
my $gff=shift;
open IN,"$gff";
my (%hash_mrna,%hash_cds,%hash_sort);
while(<IN>){
	chomp;
	my @arry= split /\s+/,$_;
	my $zhi=$_;
	if ($arry[2]=~/mRNA/){
	my $id_mrna=$1 if($arry[8]=~/ID=(\S+?);/);
	my $value_mrna=$zhi;
	push @{$hash_mrna{$id_mrna}},$value_mrna;
	}
	if($arry[2]=~/CDS/){
	my $id_cds=$1 if($arry[8]=~/Parent=(\S+?);/);
	my $value_cds=$zhi;
	my $cds1=$arry[3];
	push @{$hash_cds{$id_cds}{$cds1}},$value_cds;
	push @{$hash_sort{$id_cds}},$cds1;
	}
}
foreach my $key (keys %hash_sort){
	@{$hash_sort{$key}} = sort {$a <=> $b} @{$hash_sort{$key}};
}
foreach my $key (sort keys %hash_sort){
	print "${$hash_mrna{$key}}[0]\n";
	my $num=@{$hash_sort{$key}};
	for (my $i=0;$i<$num;$i++){
		my $cds_key=${$hash_sort{$key}}[$i];
		print "${$hash_cds{$key}{$cds_key}}[0]\n"
	}
}
