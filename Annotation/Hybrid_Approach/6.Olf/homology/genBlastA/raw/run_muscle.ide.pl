#!/usr/bin/perl 

use strict;
use FindBin qw($Bin);

die "Usage:
	perl $0 <dir included sub dir which have .muscle files> \n" if @ARGV <1;

my $dir=shift;

$dir=~s/\/$//;
my @a=<$dir/*/*/*.muscle>;
for my $subfile(@a){
	`perl $Bin/muscle_identity.pl $subfile`;
}
