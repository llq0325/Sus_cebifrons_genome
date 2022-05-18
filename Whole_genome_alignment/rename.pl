#! /usr/bin/env perl
use strict;
use warnings;

my $name1="human";
my $name2="@ARGV[1]";

print "##maf version=1 scoring=last\n";
while(my $line=<>){
    if($line=~/^#/){
        next;
    }
    elsif($line=~/^p/){
        next;
    }
    else{
        print "$line";
    }
    if($line=~/^a score/){
        my $first = <>;
        my $second = <>;
        $first=~s/^s\s/s $name1./;
        $second=~s/^s\s/s $name2./;
        print "${first}${second}";
    }
}
