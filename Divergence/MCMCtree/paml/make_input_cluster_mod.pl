my $cluster = $ARGV[0];
my $in_dir = $ARGV[1];
open MY, "$cluster";


my %clusters;
my %n_clust;
my $count;
while (my $line = <MY>) {
        ++$count;
        if ($count == 1) {
                next;
        }
        else {
                chomp($line);
                my @w = split (' ', $line);
                $clusters{$w[0]}=$w[1];
                $n_clust{$w[1]} = 1;
        }
}

my %seq_clust;
my %len_clust;
foreach $clust (keys %clusters) {
        my $files = $in_dir.'/'.$clust.'.aln.fasta'; #match the filename pattern
        open FA, "$files";
        my $id;
        while (my $line = <FA>) {
                chomp($line);
                if ($line =~ /^>.+$/) {
                        $line =~ s/>//g;
                        $id = $line;
                }
                else {
                        $seq_clust{$clusters{$clust}}{$id} .= "$line";
                        my @dna = split ('', $line);
                        $len_clust{$clusters{$clust}}{$id} += scalar @dna;
                }
        }
}

foreach my $clust (keys %seq_clust) {
        print " 7 $len_clust{$clust}{human}\n"; #length and name
        foreach my $species (keys %{ $seq_clust{$clust} }) {
                print "$species  $seq_clust{$clust}{$species}\n";
        }
}

                     
