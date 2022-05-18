#!/usr/bin/perl -w
use strict;

my ($Qr_file,$Db_file,$infile,$outfile)=@ARGV;
die"Discription: convert the genblasta output format
Author: Lyndi.He\@genomocs.cn  
Version: 2016a      Data:2016-03-13
Usage: perl $0 <query.fa> <database.fa> <infile> <outfile>" if (@ARGV<3);

my %Pep_len;
read_fasta($Qr_file,\%Pep_len);
my %Chr_len;
read_fasta($Db_file,\%Chr_len);


$/="//******************END*******************//";
my %match;
open IN,$infile or die "Fail $infile:$!";
while(<IN>){
    chomp;
    next if(/NONE/);
    my @Lines=split(/\n/);
    my ($pep_id,$chr_id,$chr_start,$chr_end,$strand,$rank);
    my ($hsp_id,$hsp_chr_start,$hsp_chr_end,$hsp_pep_start,$hsp_pep_end,$identity);
    $rank=0;
    foreach my $line(@Lines){
        next if ($line!~/\S/ || $line=~/^\/\//);
#            if ($line=~/^(\S+)\|(\S+)\s+.*:(\d+)\.\.(\d+)\|(\+|-)\|gene cover:\d+\(\S+\)\|score:.+rank:(\d+)/){
        if ($line=~/^(\S+)\|(\S+)\s*:(\d+)\.\.(\d+)\|([+-])\|gene\s*cover:\d+\(\S+\)\|score:.+\|rank:(\d+)/){
            $rank++;
            ($pep_id,$chr_id,$chr_start,$chr_end,$strand)=($1,$2,$3,$4,$5);
            $match{"$pep_id\-D$rank"}{chr}=$chr_id;
            $match{"$pep_id\-D$rank"}{strand}=$strand;
            @{$match{"$pep_id\-D$rank"}{chr_pos}}=($chr_start,$chr_end);
        }elsif($line=~/^HSP_ID\[(\d+)\]:\((\d+)-(\d+)\);query:\((\d+)-(\d+)\);\spid: (\S+)/){
            ($hsp_id,$hsp_chr_start,$hsp_chr_end,$hsp_pep_start,$hsp_pep_end,$identity)=($1,$2,$3,$4,$5,$6);
            push @{$match{"$pep_id\-D$rank"}{hsp}},[$hsp_pep_start,$hsp_pep_end,$hsp_chr_start,$hsp_chr_end,$identity];
#            print "$pep_id\-D$rank\n";
        }
    }
}

close IN;
$/="\n";

my $output;
foreach my $id (sort keys %match){
#    print $id."\n";
    @{$match{$id}{hsp}}=sort{$a->[0]<=>$b->[0]} @{$match{$id}{hsp}};
    my ($pep_start,$pep_end)=($match{$id}{hsp}[0][0],$match{$id}{hsp}[-1][1]);
    my $real_id;
    if ($id=~/^(\S+)-D(\d+)$/){
        $real_id=$1;
    }else{
        $real_id=$id;
    }
    my ($str,$chr)=($match{$id}{strand},$match{$id}{chr});
    my $hsp_num=scalar(@{$match{$id}{hsp}});
    $output.=join("\t",$id,$Pep_len{$real_id},$pep_start,$pep_end,$str,$chr,$Chr_len{$chr},@{$match{$id}{chr_pos}},$hsp_num)."\t";
    my ($total_ide,$total_hsp_len)=(0,0);
    my ($hsp_pos_out,$chr_pos_out,$hsp_ide_out);
    my @pos;
    for(my $i=0;$i<$hsp_num;$i++){
        push @pos,[@{$match{$id}{hsp}[$i]}[0,1]];
        $total_ide+=(abs($match{$id}{hsp}[$i][1]-$match{$id}{hsp}[$i][0])+1)*$match{$id}{hsp}[$i][4];
        $total_hsp_len+=abs($match{$id}{hsp}[$i][1]-$match{$id}{hsp}[$i][0])+1;
        $hsp_pos_out.=join(",",@{$match{$id}{hsp}[$i]}[0,1]).";";
        $chr_pos_out.=join(",",@{$match{$id}{hsp}[$i]}[2,3]).";";
        $hsp_ide_out.=sprintf("%.2f",$match{$id}{hsp}[$i][4]).";";
    }
    my $identity=sprintf("%.2f",$total_ide/$total_hsp_len);
    my $coverage=sprintf("%.2f",Conjoin_fragment(\@pos)/$Pep_len{$real_id}*100);
    $output.=join("\t",$coverage,$hsp_pos_out,$chr_pos_out,$hsp_ide_out)."\n";
}

open OUT,">$outfile" or die "Fail $outfile:$!";
print OUT $output;
close OUT;

##read sequences in fasta format and calculate length of these sequences.
sub read_fasta{
    my ($file,$p)=@_;
    open IN,$file or die "Fail $file:$!";
    $/=">";<IN>;$/="\n";
    while(<IN>){
        my ($id,$seq);
        if ($file eq $Qr_file && /\S\s+\S/ ) {
            die "No descriptions allowed after the access number in header line of fasta file:$file!\n";
        }
        if ( /\|/ ){
            die "No '|' allowed in the access number of fasta file:$file!\n";
        }

        if (/^(\S+)/){
            $id=$1;
        }else{
            die "No access number found in header line of fasta file:$file!\n";
        }
        $/=">";
        $seq=<IN>;
        chomp $seq;
        $seq=~s/\s//g;
        $p->{$id}=length($seq);
        $/="\n";
    }
    close IN;
}

##conjoin the overlapped fragments, and caculate the redundant size
##usage: conjoin_fragment(\@pos);
##               my ($all_size,$pure_size,$redunt_size) = conjoin_fragment(\@pos);
##Alert: changing the pointer's value can cause serious confusion.
sub Conjoin_fragment{
    my $pos_p = shift; ##point to the two dimension input array
    my $distance = shift || 0;
    my $new_p = [];         ##point to the two demension result array

    my ($all_size, $pure_size, $redunt_size) = (0,0,0);
    return (0,0,0) unless(@$pos_p);

    foreach my $p (@$pos_p) {
        ($p->[0],$p->[1]) = ($p->[0] <= $p->[1]) ? ($p->[0],$p->[1]) : ($p->[1],$p->[0]);
        $all_size += abs($p->[0] - $p->[1]) + 1;
    }


    @$pos_p = sort {$a->[0] <=>$b->[0]} @$pos_p;
    push @$new_p, (shift @$pos_p);

    foreach my $p (@$pos_p) {
        if ( ($p->[0] - $new_p->[-1][1]) <= $distance ) { # conjoin two neigbor fragements when their distance lower than 10bp
            if ($new_p->[-1][1] < $p->[1]) {
                $new_p->[-1][1] = $p->[1];
            }

        
        }else{  ## not conjoin
            push @$new_p, $p;
        }
    }
    @$pos_p = @$new_p;

    foreach my $p (@$pos_p) {
        $pure_size += abs($p->[0] - $p->[1]) + 1;
    }

    $redunt_size = $all_size - $pure_size;
    return ($pure_size);
}

