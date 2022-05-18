#!/usr/bin/perl

=head1 Name

distribute_pre.pl  --  caculate frequence distribution for distribute_svg.pl

=head1 Description

This program is used to prepare data for distribute_svg.pl, to draw frequence
distribution figure of a given set of numbers. It can also caculate frequency,
accumlated frequence, and accumlated frequency. Besides all these, it can 
caculate size(eg,seqeunce length) distriubtion instead of number(sequence number)
distribution, if the "--distrsize" option is used.  

If need to do log convertion on the numbers, you can do this on the input data
outside this program, like this way: echo 1000 | perl -ne 'chomp; print log($_)/log(10),"\n"';

In version 2, to let the figure look more good, we add a function to cut the left edge and 
right edge of figure, by a percent cutoff in whole. Not that the options --cut_left and --cut_right
can't co-work with option --accumulate.

In version 2, we also revised the function to automatically decide the steps of both X and Y axis.

=head1 Version

  Author: Fan Wei, fanw@genomics.org.cn
  Version: 2.0,  Date: 2008-12-23

=head1 Usage
  
  % distribute_pre.pl <infile | STDIN>

  --frequence          caculate frequence distribution, this is default option      
  --frequency          caculate frequency distribution
  --accumulate         caculate frequence/frequency distribution in accumlated way
  --distrsize          caculate size distribution instead of number distribution
	
  --binsize   <num>    specify the bin size for each static unit
  --minborder <num>    specify the minimum value cutoff 
  --maxborder <num>    specify the maxiumu value cutoff
  
  --cut_left <num>     set the percent to cut from left edge, default closed
  --cut_right <num>    set the percent to cut from right edge, default closed

  --header <str>       output a header in format of distribute_svg.pl
  --color  <str>       set a color for the figure
  --mark   <str>       set a mark for the figure

  --verbose            output verbose information to screen  
  --help               output help information to screen
  
  .........            all setting items in distribute_svg.pl can be used here

=head1 Exmple

cat chr10.fa.repeat  | perl ../bin/distribute_pre.pl -frequency -accum -min 0  -binsize 50 -color red -mark repeat -header line -xstart 0 -xend 10000  -note "human chr10" -x "fragment length, kp" -xscale "/1000" -y "percent in number" -xcut 1 -ycut 1 -ystart 0 -yend 100 -markpos br  >  chr10.fa.repeat.nonrepeat.num.lst

cat chr10.fa.nonrepeat | perl ../bin/distribute_pre.pl -frequency -accum -min 0 -max 50000 -binsize 50 -color blue -mark "non-repeat"  >>  chr10.fa.repeat.nonrepeat.num.lst

cat chr10.fa.repeat  | perl ../bin/distribute_pre.pl -frequency -distrsize -accum -min 0  -binsize 50 -color red -mark repeat -header line -xstart 0  -xend 10000  -note "human chr10" -x "fragment length, kp" -xscale "/1000" -y "percent in size" -xcut 1 -ycut 1 -ystart 0 -yend 100 -markpos br  >  chr10.fa.repeat.nonrepeat.size.lst

cat chr10.fa.nonrepeat | perl ../bin/distribute_pre.pl -frequency -distrsize -accum -min 0 -max 50000 -binsize 50 -color blue -mark "non-repeat"  >>  chr10.fa.repeat.nonrepeat.size.lst


=cut

use strict;
use Getopt::Long;
use Data::Dumper;

my ($Cut_left,$Cut_right);
my ($Frequence,$Frequency,$Accumulate,$Distrsize);
my ($BinSize,$MinBorder,$MaxBorder);
my ($Header,$Color,$Mark);
my ($XLeftBorder,$XRightBorder); ##用--cut_left和--cut_right处理之后的Ｘ边界
my ($Verbose,$Help);

my ($Width, $Height, $WholeScale);
my ($MarkPos, $MarkScale, $MarkNoBorder, $MarkStyle);
my ($FontSize,$FontFamily);
my ($Note, $X, $Y, $Note2); 
my ($Xstart, $Xstep, $Xend, $XCut, $XScale); 
my ($Ystart, $Ystep, $Yend, $YCut, $YScale); 
my ($XScaleDiv, $YScaleDiv); 
my ($LineWidth); 
my ($PointSize, $Noconnect); 
my ($XUnit, $UnitPer, $MovePer, $OffsetPer);


GetOptions(
	"cut_left:i"=>\$Cut_left,
	"cut_right:i"=>\$Cut_right,

	"frequence"=>\$Frequence,
	"frequency"=>\$Frequency,
	"accumulate"=>\$Accumulate,
	"distrsize"=>\$Distrsize,
	
	"binsize:f"=>\$BinSize,
	"minborder:f"=>\$MinBorder,
	"maxborder:f"=>\$MaxBorder,

	"header:s"=>\$Header,
	"color:s"=>\$Color,
	"mark:s"=>\$Mark,

	"verbose"=>\$Verbose,
	"help"=>\$Help,
	
	"Width:n"=>\$Width,
	"Height:n"=>\$Height, 
	"WholeScale:f"=>\$WholeScale, 
	
	"MarkPos:s"=>\$MarkPos, 
	"MarkScale:f"=>\$MarkScale, 
	"MarkNoBorder:n"=>\$MarkNoBorder, 
	"MarkStyle:s"=>\$MarkStyle, 
	
	"FontSize:n"=>\$FontSize, 
	"FontFamily:s"=>\$FontFamily, 
	
	"Note:s"=>\$Note,  
	"X:s"=>\$X,  
	"Y:s"=>\$Y,  
	"Note2:s"=>\$Note2, 
	
	"Xstart:f"=>\$Xstart, 
	"Xstep:f"=>\$Xstep, 
	"Xend:f"=>\$Xend, 
	"XCut:n"=>\$XCut,  
	"XScale:s"=>\$XScale, 
	
	"Ystart:f"=>\$Ystart, 
	"Ystep:f"=>\$Ystep, 
	"Yend:f"=>\$Yend, 
	"YCut:n"=>\$YCut,  
	"YScale:s"=>\$YScale,  
	
	"XScaleDiv:n"=>\$XScaleDiv,  
	"YScaleDiv:n"=>\$YScaleDiv,  
	

	"LineWidth:n"=>\$LineWidth, 

	"PointSize:n"=>\$PointSize,  
	"Noconnect:n"=>\$Noconnect,  

	"XUnit:f"=>\$XUnit, 
	"UnitPer:f"=>\$UnitPer,    
	"MovePer:f"=>\$MovePer,  
	"OffsetPer:f"=>\$OffsetPer

);

die `pod2text $0` if ($Help);

my @data;
my $total;
my %X;
my $output;

while (<>) {
	push @data,$1 if(/([-\d\.eE]+)/);
}
@data = sort {$a<=>$b} @data;
$MinBorder = $data[0] unless(defined $MinBorder);
$MaxBorder = $data[-1] unless(defined $MaxBorder);
$BinSize = ($MaxBorder - $MinBorder) / 50 unless(defined $BinSize);

print STDERR "read data done\n" if($Verbose);

##skip numbers lower than $MinBorder
my $data_pos = 0;
foreach  (@data) {
	if ($_ < $MinBorder) {
		$data_pos++;
	}else{
		last;
	}
}

my ($bin_start,$bin_end,$bin_mid);
for ($bin_start=$MinBorder; $bin_start<$MaxBorder; $bin_start+=$BinSize) {
	$bin_end = $bin_start + $BinSize;
	$bin_mid = $bin_start + $BinSize/2;
	$X{$bin_mid} = 0;	
	while ($data_pos<scalar(@data)) {
		last if($data[$data_pos] >= $bin_end);
		if (! defined $Distrsize) {
			$X{$bin_mid}++;
			$total++;
		}else{
			$X{$bin_mid} += $data[$data_pos];
			$total += $data[$data_pos];
		}
		$data_pos++;
	}
}

## include numbers equal $MaxBorder
while ($data_pos<scalar(@data)) {
	last if($data[$data_pos] > $MaxBorder);
	if (! defined $Distrsize) {
		$X{$bin_mid}++;
		$total++;
	}else{
		$X{$bin_mid} += $data[$data_pos];
		$total += $data[$data_pos];
	}
	$data_pos++;
}

print STDERR "bin caculate done\n" if($Verbose);


if (defined $Frequency) {
	foreach my $bin_mid (sort {$a<=>$b} keys %X) {
		$X{$bin_mid} /= $total/100;
	}
	$total = 1;
}


if (defined $Accumulate) {
	my $add_value;
	foreach my $bin_mid (sort {$a<=>$b} keys %X) {
		$add_value += $X{$bin_mid};
		$X{$bin_mid} = $add_value;
	}
}


##output the main data
$output .= "\nColor: $Color\n" if(defined $Color);
$output .= "Mark: $Mark\n" if(defined $Mark);

my $total_value = 0; ##在下面重新计算
foreach my $bin_mid (sort {$a<=>$b} keys %X) {
	$total_value += $X{$bin_mid};
}

my $accum_percent = 0;
foreach my $bin_mid (sort {$a<=>$b} keys %X) {
	$accum_percent += $X{$bin_mid}/$total_value*100;
	next if(defined $Cut_left && $accum_percent < $Cut_left);
	$XLeftBorder = $bin_mid unless(defined $XLeftBorder);
	$output .= "$bin_mid: $X{$bin_mid}\n";
	$XRightBorder = $bin_mid;
	last if(defined $Cut_right && $accum_percent > 100 - $Cut_right);
}

my $header_part;
if (defined $Header) {
	&header_default();
	$header_part = &header_output();
}

print $header_part.$output;



####################################################
################### Sub Routines ###################
####################################################

##calculate the unit automatically
sub auto_unit{
	my ($number,$divide) = @_;
	$divide ||= 5;
	my ($unit,$base,$exponent);
	
	my $temp = $number / $divide;
	$temp = sprintf("%e",$temp);
	if ($temp =~ /([\d\.]+)e([+-\d]+)/) {
		$base = $1;
		$exponent = $2;
	}
	
	$base = int ( $base + 0.5 );
	$unit = $base * 10 ** $exponent;
	return $unit;
}

##calculate the start automatically
sub auto_start{
	my $number = shift;
	my ($base,$exponent);
	my $temp = sprintf("%e", $number);
	if ($temp =~ /([-\d\.]+)e([+-\d]+)/) {
		$base = $1;
		$exponent = $2;
	}
	$base = int $base;

	$number = $base * 10 ** $exponent;
	return $number;
}

sub header_default{
	
	$Width = 640 unless(defined $Width);
	$Height = 480 unless(defined $Height);
	$WholeScale = 0.8 unless(defined $WholeScale);
	
	$MarkPos = 'tr' unless(defined $MarkPos);
	$MarkScale = 0.8 unless(defined $MarkScale);
	$MarkNoBorder = 0  unless(defined $MarkNoBorder);
	$MarkStyle = 'v' unless(defined $MarkStyle);
	
	$FontSize = 46 unless(defined $FontSize);
	$FontFamily = 'ArialNarrow-Bold'  unless(defined $FontFamily);
	
	unless(defined $Note){
		$Note = 'Frequence';
		$Note = 'Frequency' if(defined $Frequency);
		$Note = 'Accumulated Frequence' if($Accumulate);
		$Note = 'Accumulated Frequency' if($Accumulate && $Frequency);
		

	}
	$X = 'Range of value' unless(defined $X);
	unless(defined $Y){
		$Y = 'Number of sample';
		$Y = 'Percent of sample' if(defined $Frequency);
	}
	$Note2 = '' unless(defined $Note2);
	
	$Xend = $XRightBorder unless(defined $Xend);
	if (!defined $Xstart) {
		$Xstart = (defined $Cut_left) ? $XLeftBorder : $MinBorder;
		$Xstart = auto_start($Xstart);
	}
	if (!defined $Xend) {
		$Xend = (defined $Cut_right) ? $XRightBorder : $MaxBorder;
	}
	$Xstep = auto_unit($Xend - $Xstart) unless(defined $Xstep);
	$XCut = 0 unless(defined $XCut);

	my @temp;
	if(! defined $XScale){	
		$XScale = '';
		for (my $i=$Xstart; $i<=$Xend; $i+=$Xstep) {
			push @temp,$i;
		}
		
	}elsif($XScale =~ /\/([-\d\.Ee]+)/){ ## 除以某个尺度
		$XScale = "";
		for (my $i=$Xstart; $i<=$Xend; $i+=$Xstep) {
			push @temp, $i / $1;
		}

	}else{
		$XScale =~ s/^\s+//;
		$XScale =~ s/\s+$//;
		@temp = split /\s+/,$XScale;
		$XScale = "";
		foreach  (@temp) {
			s/^_/-/;
		}
	}
	
	foreach  (@temp) {
		$XScale .= $_."\n";
	}
	
	$Ystart = 0 unless(defined $Ystart);
	$Ystart = auto_start($Ystart);
	unless(defined $Yend){
		foreach my $bin_mid (sort {$a<=>$b} keys %X) {
			$Yend = $X{$bin_mid} if($X{$bin_mid} > $Yend);
		}
		$Yend = $Yend * 1.1;
	}
	$Ystep = auto_unit($Yend - $Ystart) unless(defined $Ystep);
	$YCut = 0 unless(defined $YCut);
	
	my @temp;
	if(! defined $YScale){	
		$YScale = '';
		for (my $i=$Ystart; $i<=$Yend; $i+=$Ystep) {
			push @temp,$i;
		}
		
		
	}elsif($YScale =~ /\/([-\d\.Ee]+)/){ ## 除以某个尺度
		$YScale = "";
		for (my $i=$Ystart; $i<=$Yend; $i+=$Ystep) {
			push @temp, $i / $1;
		}

	}else{
		$YScale =~ s/^\s+//;
		$YScale =~ s/\s+$//;
		@temp = split /\s+/,$YScale;
		$YScale = "";
		foreach  (@temp) {
			s/^_/-/;
		}
	}
	foreach  (@temp) {
		$YScale .= $_."\n";
	}
	$XScaleDiv = 1 unless(defined $XScaleDiv);
	$YScaleDiv = 1 unless(defined $YScaleDiv);
	

	$LineWidth = 3 unless(defined $LineWidth);

	$PointSize = 3 unless(defined $PointSize);
	$Noconnect = 1 unless(defined $Noconnect);

	$XUnit = 1  unless(defined $XUnit);
	$UnitPer = $BinSize  unless(defined $UnitPer);
	$MovePer = -$BinSize/2 unless(defined $MovePer);
	$OffsetPer = 0 unless(defined $OffsetPer);

}


sub header_output{
	my ($common,$line,$point,$rect);

	$common = <<HEADER;
Width:$Width
Height:$Height
WholeScale:$WholeScale
MarkPos:$MarkPos
MarkScale:$MarkScale
MarkNoBorder:$MarkNoBorder
MarkStyle:$MarkStyle
FontSize:$FontSize
FontFamily:$FontFamily
Note:$Note 
X:$X
Y:$Y
Xstart:$Xstart
Xstep:$Xstep 
Xend:$Xend
XCut:$XCut
XScale:
$XScale:End
Ystart:$Ystart
Ystep:$Ystep 
Yend:$Yend
YCut:$YCut
YScale:
$YScale:End
XScaleDiv:$XScaleDiv
YScaleDiv:$YScaleDiv
Note2:
$Note2:End
HEADER
	
	
	$line = <<HEADER;
Type:Line
LineWidth:$LineWidth
$common:End

HEADER

	$point =  <<HEADER;
Type:Point
PointSize:$PointSize
Noconnect:$Noconnect
$common:End

HEADER

	$rect =  <<HEADER;
Type:Rect
XUnit:$XUnit
UnitPer:$UnitPer     
MovePer:$MovePer  
OffsetPer:$OffsetPer
$common:End

HEADER

	return $line if( $Header =~ /line/i);
	return $point if( $Header =~ /point/i);
	return $rect if( $Header =~ /rect/i);
}



