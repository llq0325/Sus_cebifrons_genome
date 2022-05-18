

my @files=@ARGV;

foreach my $files (@files) {
        my @sp = split (/\./, $files);
        open MY, "$files";
        my $pair;
        while (my $line = <MY>) {
                chomp($line);
                my @w = split (' ', $line);
                $pair .= "\t".$w[2];
        }
       #RAxML_distances.ENSSSCT00000000291_tAlign       
                print "$sp[$#sp]$pair\n";
 
}
               
