#!usr/bin/perl
#parse_infernal_output.pl

# parses the infernal output into a gff file, and also outputs a table

use strict;
use warnings;
use Data::Dumper;

die "Usage: <infernal output file> <source for gff file> <type for gff file>" unless @ARGV == 3;
my ($file, $source, $type) = @ARGV;

my %info;
my $skip  = "yes";
my $count = 0;
my ($query, $name);

# reads the infernal output and extracts the needed information
my $outtable = $file . ".table";
open (my $tablefh, ">", $outtable) or die "Cannot open $outtable";
open (my $fh, "<", $file) or die "Cannot open $file";
while (<$fh>){
	chomp;

	if ($_ =~ /^Query:\s+(\w+)/){
		$query = $1;
		$skip = "yes";
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
			$info{$query}{$name}{evalue} = $elements[2];
			$info{$query}{$name}{score} = $elements[3];
			$info{$query}{$name}{strand} = $elements[8];
			$info{$query}{$name}{start} = $elements[6];
			$info{$query}{$name}{stop} = $elements[7];
		}
		next;
	}

	if ($count == 3){ # extracts information from the individual sequence alignments below
		$_ =~ s/\s+/ /g; # replaces multiple spaces with one space
		print $tablefh "$query\t$name\t$_\n"; # prints the output table
	}
	$count++;
}
close($tablefh);
close($fh);

# prints the gff file
$count = 1;
my $outgff3 = $file . ".gff3";
open (my $gff3fh, ">", $outgff3) or die "Cannot open $outgff3";
for my $query (keys %info){
	for my $name (keys %{ $info{$query} }){
		my $output = $query . "\t". $source . "\t" . $type. "\t" . $info{$query}{$name}{start} . "\t" . $info{$query}{$name}{stop} . "\t" . $info{$query}{$name}{score}. "\t" . $info{$query}{$name}{strand} . "\t.\t" . "ID=" . $query . "_" . $count . ";Name=" . $query . "_" . $count . ";pValue=" . $info{$query}{$name}{evalue};
		print $gff3fh "$output\n";
		$count++;
	}
}
close($gff3fh);