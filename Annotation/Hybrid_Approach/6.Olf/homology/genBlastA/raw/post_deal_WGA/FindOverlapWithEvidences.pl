#!/usr/bin/perl

=head1 Usage

	This pipeline can clust genes which have overlaps with each other ,being lead by one gene at glean.gff.
	Only work with gff format now.

	Liu Shiping,liushiping@genomics.org.cn
	2010-5-14

	perl  FindOverlapWithEvidences.pl [option] --glean glean.gff --homolog homolog.gff --homolog homolog.gff ...
	--cutoff	set the cutoff [0 ~ 1].[default & 0.1]
	--length	set the cutoff with length (bp) . (If set --length ,then --cutoff will can't work)
	--help		print this information.

=cut

use strict;
use Getopt::Long;
use File::Basename qw(basename);

my ($Glean_file,@Homolog_file,$Overlap_cutoff,$Length,$Help);
GetOptions(
	"cutoff:s"=>\$Overlap_cutoff,
	"length:s"=>\$Length,
	"glean:s"=>\$Glean_file,
	"homolog:s"=>\@Homolog_file,
	"help"=>\$Help,
);
die `pod2text $0` if ($Help || !$Glean_file || !@Homolog_file);
$Overlap_cutoff ||=0.1;

my $Glean_file_name=basename($Glean_file);
my $List_file;
$List_file="$ENV{PWD}/$Glean_file_name\_$Overlap_cutoff.list" if(!$Length);
$List_file="$ENV{PWD}/$Glean_file_name\_len$Length.list" if($Length);

my %Glean;
read_gff($Glean_file,\%Glean);

my @Homo;
for (my $i=0;$i<@Homolog_file;$i++){
	read_gff($Homolog_file[$i],\%{$Homo[$i]});
}

my %Lst;
for my $name(keys %Glean){
	for my $g_id(sort {$Glean{$name}{$a}->[0] <=> $Glean{$name}{$b}->[0]} keys %{$Glean{$name}}){
		my $g_gene_p=$Glean{$name}{$g_id};
		foreach(@Homo){
			for my $p_id(sort {$_->{$name}->{$a}->[0] <=> $_->{$name}->{$b}->[0]} keys %{$_->{$name}}){
				my $p_gene_p=$_->{$name}->{$p_id};
				next if($p_gene_p->[1]<$g_gene_p->[0]);
				last if($p_gene_p->[0]>$g_gene_p->[1]);
				my $flog;
				$flog=overlap(\@{$g_gene_p},\@{$p_gene_p},$Overlap_cutoff);
#				$flog=overlap(\@{$g_gene_p},\@{$p_gene_p},$Overlap_cutoff) if($Length);
				push @{$Lst{$g_id}},($p_id,$flog) if($flog != 0);
			}
		}
	}
}

### print out
open OUT,">$List_file" or die $!;
for my $name(keys %Lst){
	for(my $i=0;$i<@{$Lst{$name}};$i+=2){
		print OUT "$name\t$Lst{$name}[$i]\t$Lst{$name}[$i+1]\n";
	}
}
close OUT;


#########
sub read_gff{
	my ($file,$hash)=@_;
	open IN,$file or die $!;
	while(<IN>){
		next if(/^\s|#/);
		my @a=split /\t+/;
		$a[0].=$a[6];
		if($a[2]=~/mRNA/ && $a[8]=~/ID=([^;]+)/){
			@a[3,4]=@a[4,3] if($a[3]>$a[4]);
			@{$$hash{$a[0]}{$1}}=($a[3],$a[4]);
		}
	}
	close IN;
}

sub overlap{
	my ($aa,$bb,$cutoff)=@_;
	my $length_aa=$aa->[1]-$aa->[0]+1;
	my $length_bb=$bb->[1]-$bb->[0]+1;
	my $s=($aa->[0] > $bb->[0])?$bb->[0]:$aa->[0];
	my $e=($aa->[1] > $bb->[1])?$aa->[1]:$bb->[1];
	my $over=$length_aa+$length_bb-($e-$s+1);
	my $short=($length_aa > $length_bb)?$length_bb:$length_aa;
	return ($over/$length_aa) if(!$Length && $over/$length_aa >= $cutoff);
	return $over if($Length && $over >= $Length);
	return 0;
}
