#!/usr/bin/perl

use strict;

die "perl $0 <shell> <pep.fa.len> [outdir]\n" if @ARGV < 2;

my $Shell=shift;
my $Len=shift;
my $Outdir=shift;


$Outdir ||= ".";
$Outdir =~ s/\/$//;

my (%len,$max_len);
$max_len=0;
open IN,$Len or die $!;
while(<IN>){
	next if /^#/;
	$len{$1}=$2 if(/(\S+)\s+(\S+)/);
    $max_len=$len{$1} if($len{$1}>$max_len);
}
close IN;

my $name = $1 if( $Shell =~ /([^\/]+)$/);
open IN,$Shell or die $!;

if($max_len<1000){
    open OUT,">$Outdir/$name.st1k.shell" or die $!;
    while(<IN>){
        next if /^#/;
        print OUT $_;
    }
    close IN;
    close OUT;
}elsif($max_len>=1000 && $max_len<3000){
    open OUT1,">$Outdir/$name.bt1k.shell" or die $!;
    open OUT2,">$Outdir/$name.st1k.shell" or die $!;
    while(<IN>){
        next if /^#/;
        my @a=split /\s+/;
        my $id;
        $id = $1 if ($a[5] =~ /([^\/]+)\.fa$/);
        $id = $1 if ($a[5] =~ /([^\/]+)-D\d+\.fa$/);
        if($len{$id} >= 1000){
            print OUT1 $_;
        }else{
            print OUT2 $_;
        }
    }
    close IN;
    close OUT;
}else{
    open OUT1,">$Outdir/$name.bt1k.shell" or die $!;
    open OUT2,">$Outdir/$name.st1k.shell" or die $!;
    open OUT3,">$Outdir/$name.bt3k.shell" or die $!;

    while(<IN>){
        next if /^#/;
        my @a=split /\s+/;
        my $id;
        $id = $1 if ($a[5] =~ /([^\/]+)\.fa$/);
        $id = $1 if ($a[5] =~ /([^\/]+)-D\d+\.fa$/);
        if($len{$id} >= 3000){
            print OUT3 $_;
        }elsif($len{$id} >= 1000){
            print OUT1 $_;
        }else{
            print OUT2 $_;
        }
    }
    close IN;
    close OUT1;
    close OUT2;
    close OUT3;
}
