
use File::Basename;

my @files = @ARGV;
my $alpha = 1;
my %rate;
my $rate_tot;
my $u;
foreach $files (@files) {
	++$u;
	($name,$dir,$ext) = fileparse($files,'\..*');
	$num = $name;
	$num =~ s/tmp//;
	$tree = $name.'.trees';
	system ("mv $files tmp");
	system ("cp root_calib $tree");
	system ("echo 'clock = 1' >> tmp");
	system ("perl -pe 's/getSE = 2/getSE = 0/' tmp > $files");
	system ("/lustre/scratch/WUR/ABGC/liu194/paml/src/baseml $files");
	$out = $name.'.out';
	open MY, "$out";
	my $check;
	while ($line = <MY>) {
		chomp($line);
		if ($line =~ /Substitution rate is per time unit/) {
			$check = 1;
			print "$line\n";
			next;
		
		}
		if ($check == 1) {
			$rate{$num} = $line;
			$check = 0;
			$rate_tot += $rate{$num};
			print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$rate{$num}<<<<<<<<<<<<<<<<<<<<<<<<<<<\n";
		}
	}	
	
}
my $rate_mean = $rate_tot / $u;
my $beta = int($alpha / $rate_mean);
open RG, '>tmp_rgene';
print RG "rgene_gamma = $alpha $beta\n";
open OUT, ">rates.txt";
foreach $key (keys %rate) {
        print OUT "$rate{$key}\n";
}
print "$alpha $beta\n";
