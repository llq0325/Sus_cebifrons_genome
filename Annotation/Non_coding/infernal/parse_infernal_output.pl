#!usr/bin/perl
#parse_infernal_output.pl

# parses the infernal output into a gff file

use strict;
use warnings;

die "Usage: <infernal output file> <type for gff file>" unless @ARGV == 2;
my ($file, $type) = @ARGV;

my %info;
my $skip  = "yes";
my $count = 0;
my ($query, $name);

# reads the infernal output and extracts the needed information
open (my $fh, "<", $file) or die "Cannot open $file";
while (<$fh>){
	chomp;

	if ($_ =~ /^Query:\s+(\w+)/){
		$query = $1;
	}

	if ($_ =~ /^>>/){
		$skip = "no";
		$_ =~ (/^>>\s(\S+)/);
		$name = $1;
		$count = 0;
	}
	if ($skip eq "yes"){
		if ($_ =~ /^\s+\(/){ # extracts information from the table near the top of the file
			$_ =~ s/\s+/ /g; # replaces multiple spaces with one space
			my @elements = split(" ", $_);
			$name = $elements[5];
			$info{$name}{evalue} = $elements[2];
			$info{$name}{strand} = $elements[8];
		}
		next;
	}

	if ($count == 3){ # extracts information from the individual sequence alignments below
		$_ =~ s/\s+/ /g; # replaces multiple spaces with one space
		my @elements = split(" ", $_);
		$info{$name}{score} = $elements[3];
		$info{$name}{start} = $elements[9];
		$info{$name}{stop} = $elements[10];
	}
	$count++;
}
close($fh);

# prints the gff file
$count = 1;
my $outfile = $file . ".gff3";
open (my $outfh, ">", $outfile) or die "Cannot open $outfile";
for my $key (keys %info){
	my $output = $key . "\tcmsearch\t" . $type . "\t" . $info{$key}{start} . "\t" . $info{$key}{stop} . "\t" . $info{$key}{score} . "\t" . $info{$key}{strand} . "\t.\t" . "ID=" . "$query" . "_" . $count . ";Name=" . $query . "_" . $count . ";pValue=" . $info{$key}{evalue};
	print $outfh "$output\n";
	$count++;
}
close($outfh);