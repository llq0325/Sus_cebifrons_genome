#! /usr/bin/env perl
use strict;
use warnings;

my $dir=shift;
my @fa=<$dir/*.fasta>;

foreach my $fa(@fa){
    print "cd /lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/Gene_family/blastp;blastp -db all.fasta -query $fa -out $fa.out -evalue 1e-5 -outfmt 6 -num_threads 3\n";
}
