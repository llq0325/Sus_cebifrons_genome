#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

die "Usage:$0 <ref.lst> <target.lst> <identity> \n" if @ARGV<3;

my $ref = shift;
my $target = shift;
my $identity = shift;

my @Ref;
$Ref[0] = '0';
open IN,$ref or die "$!";
my $ref_num=1;
while(<IN>){
	next if /^\s/;
	chomp;
	next if($Ref[$ref_num-1] eq $_);
	$Ref[$ref_num]=$_;
	$ref_num++;
}
close IN;

my @Tar;
$Tar[0] = '0';
open IN,$target or die "$!";
my $tar_num=1;
while(<IN>){
	next if /^\s/;
	chomp;
	next if($Tar[$tar_num-1] eq $_);
	$Tar[$tar_num]=$_;
	$tar_num++;
}
close IN;

my %Score;
open IN,$identity or die "$!";
while(<IN>){
	next if /^\s/;
	chomp;
	my @c = split /\t+/;
	$Score{$c[0]}{$c[1]} = $c[2];
}
close IN;

my @DPscore;
my @Direction;

$DPscore[0][0] = 0;
$Direction[0][0] = 0;

for(my $j=1;$j<@Tar;$j++){
	$DPscore[0][$j] = 0;
	$Direction[0][$j] = 'up';
}

#print Dumper @DPscore;

my $T = -40;# gap penalty
my $A = -8;# disorder penalty
my $B =  -4;# disorder extension penalty
my $D1 = -40;# target duplicate penalty			##lsp	my $D1 = 5
my $D2 = -40;# reference duplicate penalty		##lsp	my $D2 = 5
my $S = 80;# add slip math ,left_up			##add by lsp

for(my $i=1;$i<@Ref;$i++){

	#f(i,0)
	$DPscore[$i][0] = $DPscore[$i-1][0]-10;		##lsp $DPscore[$i][0] = $DPscore[$i-1][0]
	$DPscore[$i][0] = 0 if($DPscore[$i][0] < 0);	## add by lsp
	$Direction[$i][0] = '0';
	for(my $j=1;$j<@Tar;$j++){
		#	print join("\t",$i,$j,$DPscore[$i-1][$j],$T)."\n";#error when $i==7 ,$j==1
		if ( $DPscore[$i-1][$j] + $T > $DPscore[$i][0] ){
			$DPscore[$i][0] = $DPscore[$i-1][$j] + $T;
			$Direction[$i][0] = "left_$j";
		}
	}
		
	#f(i,j);
	for(my $j=1;$j<@Tar;$j++){
		if ( not defined $Score{$Ref[$i]}{$Tar[$j]} ){
			$DPscore[$i][$j] = -999;# not alow mismatch!
			$Direction[$i][$j] = 'miss';	
		}else{
			my $max_ij = $DPscore[$i][0]-2+$Score{$Ref[$i]}{$Tar[$j]};
			for(my $k=0;$k<@Tar;$k++){			##lsp	for(my $k=0;$k<@Tar && $k !=$j-1 && $k != $j;$k++){
				next if($k ==$j-1 || $k == $j);		## add by lsp
				my $s = $DPscore[$i-1][$k]+$Score{$Ref[$i]}{$Tar[$j]}+$A+$B*abs($j-$k);
				if ( $s > $max_ij ){
					$max_ij = $s;
					$DPscore[$i][$j] = $max_ij;
					$Direction[$i][$j] = "left_$k";
				}
			}
			my $lu_s = $DPscore[$i-1][$j-1] + $Score{$Ref[$i]}{$Tar[$j]}+$S;
			#	print "test2:".$lu_s."\t".$max_ij."\n";
			if($lu_s > $max_ij && $j-1 != 0){		##lsp	if($lu_s > $max_ij){
				$max_ij = $lu_s;
				$DPscore[$i][$j] = $max_ij;
				$Direction[$i][$j] = 'left_up';
			}
			if ( $DPscore[$i-1][$j]+$Score{$Ref[$i]}{$Tar[$j]}+$D1 > $max_ij ){
				$max_ij = $DPscore[$i-1][$j]+$Score{$Ref[$i]}{$Tar[$j]} + $D1;
				$DPscore[$i][$j] = $max_ij;
				$Direction[$i][$j] = "left";
			}
			if ( $DPscore[$i][$j-1]+$Score{$Ref[$i]}{$Tar[$j]}+$D2 >= $max_ij ){
				$max_ij = $DPscore[$i][$j-1] + $Score{$Ref[$i]}{$Tar[$j]}+$D2;
				$DPscore[$i][$j] = $max_ij;
				$Direction[$i][$j] = "up";
			}

			if ( not defined $DPscore[$i][$j] ){
				$DPscore[$i][$j] = $max_ij;#less that gap
				$Direction[$i][$j] = 'less_gap';
				$DPscore[$i][$j] = $DPscore[$i][$j-1] if($DPscore[$i][$j-1] == $DPscore[$i][$j]);		## add by lsp
				$Direction[$i][$j]= 'up' if($DPscore[$i][$j-1] == $DPscore[$i][$j]);				## add by lsp
			}
		}
#		if($i==6 && $j ==1 ){
#			print "test:$i;$j;$DPscore[$i][$j]\n";
#		}
	}
}

my @S;
#print "##Score Matrix:\n";
#print join("\t",'Ref',@Ref)."\n";
for(my $i=0;$i<@Ref;$i++){
	for(my $j=0;$j<@Tar;$j++){
		$S[$j][$i] = "(".$DPscore[$i][$j]."/".$Direction[$i][$j].")";
	}	
}

for(my $j = 0;$j<@Tar;$j++){
#	print join("\t",$Tar[$j],@{$S[$j]})."\n";
}

my @Align_i = ();
my @Align_j = ();

my $Pos_i = @Ref-1;
my $Pos_j = 0;
my $maxi = $DPscore[$Pos_i][$Pos_j];
for(my $j=0;$j<@Tar;$j++){
	if ( $DPscore[$Pos_i][$j] >= $maxi ){
		$Pos_j = $j;
		$maxi = $DPscore[$Pos_i][$j];
	}
}


traceback(\@DPscore,\@Direction,\@Align_i,\@Align_j);

#print "##Alignment:\n";
#print join("\t",reverse(@Align_i))."\n".join("\t",reverse(@Align_j))."\n";
for(my $i=@Align_i-1;$i>=0;$i--){
	$Align_i[$i]=$Align_i[$i+1] if($Align_i[$i] eq '-');
	$Align_j[$i]=$Align_j[$i+1] if($Align_j[$i] eq '-');
	print "$Align_i[$i]\t$Align_j[$i]\n";
}

sub traceback{
	my ($dp_p,$d_p,$align_i,$align_j) = @_;
#	print join("\t",'tb:',$Pos_i,$Pos_j)."\n";
	my $d = $d_p->[$Pos_i][$Pos_j];
	if ($d eq 'left_up'){
		#match
		push @$align_i,$Ref[$Pos_i];
		push @$align_j,$Tar[$Pos_j];
		$Pos_i--;
		$Pos_j--;
	}elsif($d eq 'left'){
		#ref duplication
		push @$align_i,$Ref[$Pos_i];
		push @$align_j,'-';
		$Pos_i--;
		#Pos_j not changes
	}elsif($d eq 'up'){
		#target duplication
		push @$align_i,'-';
		push @$align_j,$Tar[$Pos_j];
		$Pos_j--;
	}elsif($d=~/left_(\d+)/){
		#left, disorder
		push @$align_i,$Ref[$Pos_i];
		if ( $Pos_j > 0 ){
			push @$align_j,$Tar[$Pos_j];
		}else{
			push @$align_j,'.';#here is a gap. f(i,0)
		}
		$Pos_j = $1;
		$Pos_i--;
	}elsif($d eq 'less_gap'){
		#left column is a gap!
		push @$align_i,$Ref[$Pos_i];
		push @$align_j,$Tar[$Pos_j];
		$Pos_i--;
		$Pos_j=0;#it must be 0??!!
	}elsif($d eq '0'){
		#current column is gap
		push @$align_i,$Ref[$Pos_i];
		push @$align_j,'.';
		$Pos_i--;
		$Pos_j=0;
	}else{
		die "$!";
	}
	traceback($dp_p,$d_p,$align_i,$align_j) if ($Pos_i>0 && $Pos_j>=0);
}

