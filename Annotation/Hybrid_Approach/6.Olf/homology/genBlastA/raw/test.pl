#!/usr/bin/perl -w
use strict;
use YAML qw(Load Dump);
my %hash=("liu","dog","he","people");
my $ref=\%hash;
print "hash \n";
foreach (keys %$ref ){

print "type 1  $_: $$ref{$_}";

print "type 2  $_: ${$ref}{$_}:"
}
my @array=qw( 1 4 16 );

my $ref2=\@array;

my $num=3;
while  ($num) {
	print "type 1 $$ref2[$num] ";
	print "type 2 ${$ref2}[$num--]\n";


}
my $Param = Load(<<END);
blastall:
  -p: tblastn
  -e: Blast_eval
  -F: F
filter-solar:
  extent: Extend_len
genewise:
  -genesf:
  -gff:
  -sum:
END
print $Param;

print "Dumper ($Param)";




