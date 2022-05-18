#!/usr/bin/perl
use strict;
use warnings;

#A pipeline to build gene-scaffold using partial_multi genes

die "Usage:$0 <genewise.support> <all.out.pair.gff.end> \n\n" if @ARGV<2;

my $sup_file=shift;
my $end_file=shift;

my %Sup;
read_sup($sup_file,\%Sup);

my %End;
read_end($end_file,\%End);

foreach my $pid (sort keys %End){
	my $num=scalar(keys %{$End{$pid}});
	my $tag=0;
	foreach my $id ( sort {$Sup{$a}[0]<=>$Sup{$b}[0]} keys %{$End{$pid}} ){
		#print join("\t",$id,@{$End{$pid}{$id}})."\n";
		next if $End{$pid}{$id}[5] eq 'start';# 'start' means needing start piece
		foreach my $id2 ( sort { $Sup{$a}[0]<=>$Sup{$b}[0] } keys %{$End{$pid}} ){
			next if $id eq $id2;
			next if $End{$pid}{$id2}[5] eq 'END';# 'END' meads needing end piece
			if ( $Sup{$id}[2]-$Sup{$id2}[1]+1>10 || $Sup{$id2}[2]-$Sup{$id}[2]+1<10 ){
				next;
			}else{
				$tag++;
				print ">$pid $num $tag\n";
				print join("\t",$id,@{$End{$pid}{$id}},@{$Sup{$id}} )."\n";
				print join("\t",$id2,@{$End{$pid}{$id2}},@{$Sup{$id2}} )."\n";	
				last;
			}
		}
		last if $tag>0;
	}
	print ">$pid $num $tag\n" if $tag==0;
}

###Sub
sub read_sup{
	my ($file,$p)=@_;
	open IN,$file or die "$!";
	while(<IN>){
		next if /^#/;
		chomp;
		my @c=split(/\t/);
		@{$p->{$c[0]}}=@c[1..4];#pep_len,pep_start,pep_end,aligned_len
	}
	close IN;
}

sub read_end{
	my ($file,$p)=@_;
	open IN,$file or die "$!";
	while(<IN>){
		next if /^#/;
		chomp;
		my @c=split(/\t/);
		next if ($c[6] ne 'partial_multi' && $c[11] ne 'partial_multi');
		if ($c[2] eq $c[7]){
			my $type='both';#maybe miss both ends of the gene
			my $pid;
			if ($c[2]=~/^(\S+)-D\d+/){
				$pid=$1;
			}else{
				die "Format error!\n";
			}
			@{$p->{$pid}{$c[2]}}=(@c[0,1,3,4,5],$type) if $c[6] eq 'partial_multi';
		}else{
			#the gene on 5'-end
			my ($type5,$pid5);
			if ($c[5] eq '-'){
				$type5='end';
			}else{
				$type5='start';
			}
			if ($c[2]=~/^(\S+)-D\d+/){
                                $pid5=$1;
                        }else{
                                die "Format error!\n";
                        }
                        @{$p->{$pid5}{$c[2]}}=(@c[0,1,3,4,5],$type5) if $c[6] eq 'partial_multi';
			
			#the gene on 3'-end
			my ($type3,$pid3);
			if ($c[10] eq '-'){
				$type3='start';
			
			}else{
				$type3='end';
			}
			if ($c[7]=~/^(\S+)-D\d+/){
                                $pid3=$1;
                        }else{
                                die "Format error!\n";
                        }
                        @{$p->{$pid3}{$c[7]}}=(@c[0,1,8,9,10],$type5) if $c[11] eq 'partial_multi';
		}
	}
	close IN;
}
