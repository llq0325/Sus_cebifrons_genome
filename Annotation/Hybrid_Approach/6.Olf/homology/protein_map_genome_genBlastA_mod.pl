#!/usr/bin/perl

=head1 NAME	

protein_map_genome.pl  --  the pipeline of mapping protein to genome for draft sequence.

=head1 DESCRIPTION

This script invokes tblastn, genBlastA, and genewise, and finally
give result in gff3 format.

The total time sometimes depends on the some tasks of genewise,
which becomes very slowly when the protein and DNA sequence is
too large. 

Alert that in this program, "|"  in protein name is not allowed.
All sequence must be in fasta format ,and head line should be include ID only.
Otherwise,genBlastA will make a big error !
So,before running this pipeline,you shuld run $Bin/SimpleID.pl to simplify sequences ID.

=head1 Version

    Author: Huang Quanfei,huangqf@genomics.org.cn
    Mender: Liu Shiping,liushiping@genomics.org.cn
    Version: 2.0    Date: 2009-6-3
    Update: 2.1     Data: 2010-07-26
    Update: 2.2     Data: 2010-09-19
    Mender: Lyndi.He, Lyndi.He@genomics.cn
    Update: 2016a   Data: 2016-03-11

=head1 Usage

    perl protein_map_genome.pl [options] protein.fa genome.fa
    --cpu <int>	          set the cpu number to use in parallel, default=100
    --run <str>           set the parallel type, qsub, or multi, default=qsub
    --outdir <str>        set the result directory, default="./"
    --align_rate <num>    set the aligned rate for solar result, default 0.01
    --extend_len <num>    set the extend length for genewise DNA fragment, default 500
    --genblasta_opt <str> set the genblasta options, default Genblasta_opt=" -p T -e 1e-2 -g T -f F -a 0.5 -d 100000 -r 100 -c 0.5 -s -100 "
    --filter_rate <num>	  set the filter rate for the best hit of geneblastA result,default 0.7
    --step <num>          set the which step to run(1234567), default 1234. Step 567 is the Synteny analysis of the two species
    --net <str>           set the net directory result(lastz result).
    --rgene <str>         set the reference gene file with gff.
    --queue <str>         set the queue ,default no
    --pro_code <str>      set the project code ,default no
    --lines <int>         set the --lines option of qsub-sge.pl,required.must define
    --resource <vf=XXG>	  set the qsub-sge commond.default vf=1.0G
    --verbose             output verbose information to screen,default no  
    --help                output help information to screen,default no

=head1 Example

  perl ../bin/protein_map_genome.pl -cpu 100 -verbose ../input/Drosophila_melanogaster_protein.1000.fa ../input/test_chr_123.seq &

=cut

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use lib "$Bin/lib";
use Data::Dumper;
use File::Basename qw(basename dirname); 
use YAML qw(Load Dump);
use List::Util qw(reduce max min);
use Collect qw(Read_fasta);
use Cwd qw(abs_path);

##get options from command line into variables and set default values
my ($Cpu,$Run,$Outdir,$Net,$Ref_gene);
my ($Align_rate,$Extend_len,$Genblasta_opt,$Filter_rate,$Step);
my ($Cpu,$Resource,$Verbose,$Help);
my ($Queue,$Pro_code);
my $Line;
GetOptions(
	"lines:i"=>\$Line,
	"cpu:i"=>\$Cpu,
	"run:s"=>\$Run,
	"outdir:s"=>\$Outdir,
    "genblasta_opt:s"=>\$Genblasta_opt,
	"align_rate:f"=>\$Align_rate,
	"extend_len:i"=>\$Extend_len,
	"filter_rate:f"=>\$Filter_rate,
	"step:s"=>\$Step,
	"net:s"=>\$Net,
	"rgene:s"=>\$Ref_gene,
	"cpu:i"=>\$Cpu,
	"queue:s"=>\$Queue,
    "pro_code:s"=>\$Pro_code,
	"resource:s"=>\$Resource,
	"verbose!"=>\$Verbose,
	"help!"=>\$Help
);
$Align_rate ||= 0.01;
$Extend_len ||= 500;
$Filter_rate ||= 0.7;
$Step ||= '1234';
$Step =~ s/5//g unless(-d "$Net" && -e "$Ref_gene");
$Cpu ||= 100;
$Resource ||= "vf=1.5G,p=1";
$Run ||= "qsub";
$Outdir ||= ".";
$Outdir = abs_path($Outdir);
#my $Queue_para=(defined $Queue)?"-queue $Queue":'';
my $Queue_para;
$Queue_para.=" --queue $Queue" if (defined $Queue);
$Queue_para.=" --pro_code $Pro_code" if (defined $Pro_code);
$Queue_para .= " --resource $Resource" if (defined $Resource);

$Genblasta_opt ||="Genblasta_opt=\" -p T -e 1e-2 -g T -f F -a 0.5 -d 100000 -r 100 -c 0.5 -s -100 \"";
my ($opt_p,$opt_e,$opt_g,$opt_f,$opt_a,$opt_d,$opt_r,$opt_c,$opt_s);
if($Genblasta_opt=~/Genblasta_opt=.*\-p\s+(\S+)/){$opt_p=$1;}
if($Genblasta_opt=~/Genblasta_opt=.*\-e\s+(\S+)/){$opt_e=$1;}
if($Genblasta_opt=~/Genblasta_opt=.*\-g\s+(\S+)/){$opt_g=$1;}
if($Genblasta_opt=~/Genblasta_opt=.*\-f\s+(\S+)/){$opt_f=$1;}
if($Genblasta_opt=~/Genblasta_opt=.*\-a\s+(\S+)/){$opt_a=$1;}
if($Genblasta_opt=~/Genblasta_opt=.*\-d\s+(\S+)/){$opt_d=$1;}
if($Genblasta_opt=~/Genblasta_opt=.*\-r\s+(\S+)/){$opt_r=$1;}
if($Genblasta_opt=~/Genblasta_opt=.*\-c\s+(\S+)/){$opt_c=$1;}
if($Genblasta_opt=~/Genblasta_opt=.*\-s\s+(\S+)/){$opt_s=$1;}


die `pod2text $0` if (@ARGV == 0 || $Help || (not defined $Line ));

my $Qr_file = shift;
my $Db_file = shift;

my %Pep_len;
read_fasta($Qr_file,\%Pep_len);

my %Chr_len;
read_fasta($Db_file,\%Chr_len);

$Outdir =~ s/\/$//;
mkdir($Outdir) unless(-d $Outdir);

my $Qr_file_basename = basename($Qr_file);
my $genewise_dir = "$Outdir/$Qr_file_basename.genewise";

my $tblastn_shell_file = "$Outdir/$Qr_file_basename.tblastn.shell";
my $genblasta_shell_file = "$Outdir/$Qr_file_basename.genblasta.shell";
my $genewise_shell_file = "$Outdir/$Qr_file_basename.genewise.shell";

my @subfiles;
#my $GBPATH="$Bin/genBlastA";

my %config;
parse_config("$Bin/config.txt",\%config);

my $Formatdb=$config{"formatdb"};
my $Blastall=$config{"blastall"};
my $Genewise=$config{"genewise"};
my $qsub_sge=$config{"qsub_sge.pl"};
my $multi_process=$config{"multi-process.pl"};
my $fastaDeal=$config{"fastaDeal.pl"};
my $genBlastA=$config{"genBlastA"};
my $genBlastA_bin="$Bin/genBlastA";
# $genBlastA="source /ifs4/BC_PUB/biosoft/pipeline/DNA/DNA_annotation/software/gene/genblasta/setup.sh; ".$genBlastA;
# $Genewise="source /ifs4/BC_PUB/biosoft/pipeline/DNA/DNA_annotation/software/gene/genewise/wise2.4.1/setup.sh; ".$Genewise;

##use YAML format to set parameters for blastall, solar, filter, and genewise programs
my $Param = Load(<<END);
genblasta:
  -p: $opt_p
  -e: $opt_e
  -g: $opt_g
  -f: $opt_f
  -a: $opt_a
  -d: $opt_d
  -r: $opt_r
  -c: $opt_c
  -s: $opt_s
filter-solar:
  score: 25
  align_rate: $Align_rate
  extent: $Extend_len
genewise:
  -genesf:
  -gff:
  -sum:
END
print STDERR Dump($Param) if($Verbose);
print STDERR "step = $Step\n" if($Verbose);

if ($Step =~/1/){
	##format the database for tblastn
    print STDERR  "\n\n$Formatdb -i $Db_file -p F -o T\n"  if($Verbose);
	`$Formatdb -i $Db_file -p F -o T` unless (-f $Db_file.".nhr");

	##cut query file into small subfiles
	`perl $fastaDeal -cutf $Cpu $Qr_file -outdir $Outdir`;
	@subfiles = glob("$Outdir/$Qr_file_basename.cut/*.*");

	##creat the tblastn shell file
	my $opt_genblasta = join(" ",%{$Param->{genblasta}});
	open OUT,">$tblastn_shell_file" || die "fail $tblastn_shell_file";
	foreach my $qrfile (@subfiles) {
		print OUT "$genBlastA $opt_genblasta -t $Db_file -q $qrfile -o $qrfile.genblast.out >$qrfile.genblast.out.log 2> $qrfile.genblast.out.err \n";
	}
	close OUT;

	print STDERR "run the tblastn shell file"  if($Verbose);
	if ($Run eq "qsub") {
		`perl $qsub_sge  $Queue_para --convert no --reqsub --resource --maxjob $Cpu   $tblastn_shell_file`;
	}
	if ($Run eq "multi") {
		`perl $multi_process -cpu $Cpu $tblastn_shell_file`;
	}

	##cat together the tblastn result
	`cat $Outdir/$Qr_file_basename.cut/*.genblast.out > $Outdir/$Qr_file_basename.genblast.out`;
}

if ($Step =~/2/){
	print  STDERR "run genBlastA to conjoin HSPs\n"  if($Verbose);
    open (OUT1,">$genblasta_shell_file") || die "fail $genblasta_shell_file";
	
    `ln -s $Qr_file` if ( not -f "./$Qr_file_basename"); 
    print OUT1 "perl $genBlastA_bin/convert_genBlastA.pl $Outdir/$Qr_file_basename $Db_file $Outdir/$Qr_file_basename.genblast.out $Outdir/$Qr_file_basename.genblast.tab\n";
    print OUT1 "perl $genBlastA_bin/filter.tab.pl $Outdir/$Qr_file_basename.genblast.tab $Filter_rate > $Outdir/$Qr_file_basename.genblast.tab.best\n";
	
    if ($Run eq "qsub") { 
        `perl $qsub_sge  $Queue_para --reqsub --lines 10 --maxjob $Cpu $genblasta_shell_file`;
    }
    if ($Run eq "multi") {
        `perl $multi_process -cpu $Cpu $genblasta_shell_file`;
    }
}

if ($Step =~/3/){
	print STDERR "preparing genewise input directories and files\n" if ($Verbose);
	&prepare_genewise("$Outdir/$Qr_file_basename.genblast.tab.best","$Ref_gene");

	print STDERR "run the genewise shell file\n" if ($Verbose);
	`perl $fastaDeal -attr id:len $Qr_file > $Outdir/$Qr_file_basename.len`;
	`perl $genBlastA_bin/classBigProtein.pl $genewise_shell_file $Outdir/$Qr_file_basename.len $Outdir`;
	if ($Run eq "qsub") {
        if(-e "$genewise_shell_file.st1k.shell"){
           if(-s "$genewise_shell_file.st1k.shell")	{
                `perl $qsub_sge $Queue_para --reqsub  --maxjob $Cpu --lines $Line   $genewise_shell_file.st1k.shell`;
           }else{
                `rm "$genewise_shell_file.st1k.shell"`;
           }
        }
		my $Line_2=int($Line/10);
		$Line_2=1 if($Line_2 < 1);
        if (-e "$genewise_shell_file.bt1k.shell"){
            if(-s "$genewise_shell_file.bt1k.shell"){
                `perl $qsub_sge  $Queue_para --reqsub  --maxjob $Cpu --lines $Line_2 $genewise_shell_file.bt1k.shell`;
            }else{
                `rm "$genewise_shell_file.bt1k.shell"`;
            }
        }
        if (-e "$genewise_shell_file.bt3k.shell"){
            if(-s "$genewise_shell_file.bt3k.shell"){
                `perl $qsub_sge  $Queue_para --reqsub --maxjob $Cpu --lines 1 $genewise_shell_file.bt3k.shell` ;
            }else{
                `rm "$genewise_shell_file.bt3k.shell"`;
            }
        }
	}
	if ($Run eq "multi") {
		`perl $multi_process -cpu $Cpu $genewise_shell_file`;
	}
}

if ($Step =~/4/){
	print  STDERR "convert result to gff3 format\n"  if($Verbose);
	`for i in $Outdir/$Qr_file_basename.genewise/* ;do for k in \$i/* ;do for j in \$k/*.genewise ;do cat \$j;done ;done ;done >$Outdir/$Qr_file_basename.genblast.genewise`;
	`perl $fastaDeal -attr id:len $Qr_file >$Outdir/$Qr_file_basename.len`;
	`perl  $genBlastA_bin/gw2gffWithShift.pl $Outdir/$Qr_file_basename.genblast.genewise $Outdir/$Qr_file_basename.len >$Outdir/$Qr_file_basename.genblast.genewise.gff`;
#	`perl $Bin/filter_gff_gene_lenght.pl --threshold 100 --exons 2 --score 50 $Outdir/$Qr_file_basename.genblast.genewise.gff > $Outdir/$Qr_file_basename.genblast.genewise.filter.gff`;
	`ln -s $Outdir/$Qr_file_basename.genblast.genewise.gff $Outdir/$Qr_file_basename.genblast.genewise.filter.gff`;
	`perl $genBlastA_bin/gw2support.pl $Outdir/$Qr_file_basename.genblast.genewise $Outdir/$Qr_file_basename.len > $Outdir/$Qr_file_basename.genblast.genewise.support`;
	`perl $genBlastA_bin/gw2support_change.pl $Outdir/$Qr_file_basename.genblast.genewise $Outdir/$Qr_file_basename.len > $Outdir/$Qr_file_basename.genblast.genewise.support2`;
}

if ($Step =~ /5/){
	print STDERR "running Synteny ...\n" if ($Verbose);
	my $netdir="$Outdir/net2tab";
	`mkdir $netdir` unless(-d "$netdir");
	my @nets=<$Net/*>;
	for (@nets){
		my $netname=basename $_;
		`perl $genBlastA_bin/net2tab.pl $_ > $netdir/$netname.tab`;
		`perl $genBlastA_bin/filter_redundance.pl $netdir/$netname.tab $netdir 100`;
		`rm $netdir/$netname.tab`;
	}
	undef @nets;
	my @nets=<$netdir/*.nr.tab>;
	open SySH,">$Outdir/$Qr_file_basename.genblast.genewise.gff.SyShell" or die $!;
	for (@nets){
		my $netname=basename $_;
		print SySH "perl $genBlastA_bin/prepareFor.pl $_ $Ref_gene $Outdir/$Qr_file_basename.genblast.genewise.gff\n";
	}
	close SySH;

	if ($Run eq "qsub") {
		`perl $qsub_sge $Queue_para --reqsub --lines 1  --maxjob $Cpu  $Outdir/$Qr_file_basename.genblast.genewise.gff.SyShell`;
	}
	if ($Run eq "multi") {
		`perl $multi_process -cpu $Cpu $Outdir/$Qr_file_basename.genblast.genewise.gff.SyShell`;
	}
	`for i in $netdir/*.nr.tab;do cat \$i;done > $Outdir/$Qr_file_basename.genblast.genewise.gff.nr.net2tab`;
	`for i in $netdir/*.Synteny;do cat \$i;done > $Outdir/$Qr_file_basename.genblast.genewise.gff.Synteny.list`;
	`for i in $netdir/*.out;do cat \$i;done > $Outdir/$Qr_file_basename.genblast.genewise.gff.Synteny.out`;
#	`rm -rf $netdir`;
	`perl $Bin/fishInWinter.pl -bf table -bc 2 -ff gff $Outdir/$Qr_file_basename.genblast.genewise.gff.Synteny.out $Outdir/$Qr_file_basename.genblast.genewise.gff > $Outdir/$Qr_file_basename.genblast.genewise.gff.Synteny.gff`;
}

if ($Step =~ /6/){
	my $GFF="$Outdir/$Qr_file_basename.genblast.genewise.filter.gff";
	print STDERR "Running Muscle for getting identitive ...\n" if ($Verbose);
	`perl $genBlastA_bin/product_di_lst.pl $GFF > $GFF.id.list`;
	`perl $genBlastA_bin/getGene.pl $GFF $Db_file > $GFF.cds`;
	`perl $genBlastA_bin/cds2aa.pl $GFF.cds > $GFF.pep`;
	`perl $genBlastA_bin/run_muscle.pl $GFF.id.list $GFF.pep $Qr_file`;
	`perl $qsub_sge $Queue_para --reqsub --lines $Line  --maxjob $Cpu  $GFF.id.list.muscle.sh`;
	`for i in $GFF.id.list.cut*/*;do for j in \$i/*;do for k in \$j/*.muscle;do perl $Bin/muscle_identity.pl \$k;done;done;done > $GFF.ident.list`;
#	`perl $Bin/run_muscle.ide.pl $GFF.id.list.cut* > $GFF.ident.list`;
	`awk '\$3 >= 30 && \$6 >= 50 && \$7 >= 10 && \$8 >= 25' $GFF.ident.list > $GFF.ident.list.filter`;
#	`rm -rf $GFF.id.list.cut*`;
}

if ($Step =~ /7/){
	my $GFF="$Outdir/$Qr_file_basename.genblast.genewise.filter.gff";
	print STDERR "Running extend gene and remove pseudo shift ...\n" if ($Verbose);
	`perl $genBlastA_bin/filterShiftN.pl $GFF $Db_file > $GFF.noShift`;
	`perl $genBlastA_bin/extendEnds.pl $GFF $GFF.ident.list.filter $Db_file > $GFF.Extend.gff 2> $GFF.Extend.log`;
	`perl $genBlastA_bin/noShiftGff.pl $GFF.noShift $GFF.Extend.gff > $GFF.noShiftExt.gff`;
}

print  STDERR "All tasks finished\n"  if($Verbose);


####################################################
################### Sub Routines ###################
####################################################

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


sub parse_config{
	my $conifg_file = shift;
	my $config_p = shift;
	
	my $error_status = 0;
	open IN,$conifg_file || die "fail open: $conifg_file";
	while (<IN>) {
		next if /^#/;
		if (/(\S+)\s*=\s*(\S+)/) {
			my ($software_name,$software_address) = ($1,$2);
			$config_p->{$software_name} = $software_address;
			if (! -e $software_address){
				warn "Non-exist:  $software_name  $software_address\n"; 
				$error_status = 1;
			}
		}
	}
	close IN;
	die "\nExit due to error of software configuration\n" if($error_status);
}


##prepare data for genewise and make the qsub shell
####################################################


sub prepare_genewise{
	my $solar_file = shift;
	my $Gff=shift;
	my %gff;
	read_gff($Gff,\%gff) if($Gff);
	my @corr;

	open IN, "$solar_file" || die "fail $solar_file";
#ENSGALP00000000003-D1   77      1       76      +       Scaffold151     6292079 3074470 3075302 2       98.70   1,42;37,76;
	while (<IN>) {
		s/^\s+//;
		my @t = split /\s+/;
		my $query = $t[0];
		my $strand = $t[4];
		my ($query_start,$query_end) = ($t[2] < $t[3]) ? ($t[2] , $t[3]) : ($t[3] , $t[2]);
		my $subject = $t[5];
		my ($subject_start,$subject_end) = ($t[7] < $t[8]) ? ($t[7] , $t[8]) : ($t[8] , $t[7]);
		push @corr, [$query,$subject,$query_start,$query_end,$subject_start,$subject_end,"","",$strand]; ## "6:query_seq" "7:subject_fragment"	
	}
	close IN;
	my %fasta;
	&Read_fasta($Qr_file,\%fasta);
	foreach my $p (@corr) {
		my $query_id = $p->[0];
		$query_id =~ s/-D\d+$//;
		if (exists $fasta{$query_id}) {
			$p->[6] = $fasta{$query_id}{seq};
		}
	}
	undef %fasta;
	my %fasta;
	&Read_fasta($Db_file,\%fasta);
	foreach my $p (@corr) {
		if (exists $fasta{$p->[1]}) {
			my $parent_id=$p->[0];
			$parent_id=$1 if($parent_id =~ /(\S+)-D\d+/);
			#print "$parent_id\n";
			my @a=sort {$a->[3] <=> $b->[3]} @{$gff{$parent_id}} if(exists $gff{$parent_id});
			my ($query_head_gap,$query_tail_gap)=(0,0);
			($query_head_gap,$query_tail_gap)=call($p->[2],$p->[3],\@a) if(scalar @a > 0);#################
			if ($query_head_gap < 0 || $query_tail_gap < 0){
				die "Please check the length of .pep and CDS for $p->[0]\n";
			}
			my $seq = $fasta{$p->[1]}{seq};
			my $len = $fasta{$p->[1]}{len};
			#print  join("\t",$p->[0],$p->[1],$len,$p->[2],$p->[3],$p->[4],$p->[5],$p->[8],$query_head_gap,$query_tail_gap,$a[0]->[6]);
			$p->[4] -= ($Param->{'filter-solar'}{extent}+$query_head_gap) if($p->[8] eq '+'); 
			$p->[4] -= ($Param->{'filter-solar'}{extent}+$query_tail_gap) if($p->[8] eq '-');
			$p->[4] = 1 if($p->[4] < 1);
			$p->[5] += ($Param->{'filter-solar'}{extent}+$query_tail_gap) if($p->[8] eq '+');
			$p->[5] += ($Param->{'filter-solar'}{extent}+$query_head_gap) if($p->[8] eq '-');
			$p->[5] = $len if($p->[5] > $len);
			#print "\t$p->[4]\t$p->[5]\n";
			$p->[7] = substr($seq,$p->[4] - 1, $p->[5] - $p->[4] + 1); 
		}
	}
	undef %fasta;
	mkdir "$genewise_dir" unless (-d "$genewise_dir");
	my $parentdir="00";
	my $subdir = "000";
	my $parentloop=0;
	my $loop = 0;
	my $cmd;
	my $opt_genewise = join(" ",%{$Param->{genewise}});
	foreach my $p (@corr) {
		if($loop % 100 == 0){
			if($parentloop % 100 ==0){
				$parentdir++;
				mkdir ("$genewise_dir/$parentdir");
				$subdir="000";
			}
			$subdir++;
			mkdir("$genewise_dir/$parentdir/$subdir");
			$parentloop++;
		}
		
		my $qr_file = "$genewise_dir/$parentdir/$subdir/$p->[0].fa";
		my $db_file = "$genewise_dir/$parentdir/$subdir/$p->[0]_$p->[1]_$p->[4]_$p->[5].fa";
		my $rs_file = "$genewise_dir/$parentdir/$subdir/$p->[0]_$p->[1]_$p->[4]_$p->[5].genewise";
		
		open OUT, ">$qr_file" || die "fail creat $qr_file";
		print OUT ">$p->[0]\n$p->[6]\n";
		close OUT;
		open OUT, ">$db_file" || die "fail creat $db_file";
		print OUT ">$p->[1]_$p->[4]_$p->[5]\n$p->[7]\n";
		close OUT;

		my $choose_strand = ($p->[8] eq '+') ? "-tfor" : "-trev";
		$cmd .= "$Genewise $choose_strand $opt_genewise $qr_file $db_file > $rs_file 2> /dev/null\n";
		$loop++;
	}
	undef @corr;

	open OUT, ">$genewise_shell_file" || die "fail creat $genewise_shell_file";
	print OUT $cmd;
	close OUT;
}

sub call{
	my ($gap_head,$gap_tail,$array)=@_;
	$gap_head--;
	$gap_head=$gap_head*3;
	$gap_tail=$gap_tail*3;
	my ($head_gap,$tail_gap,$cds_len)=(0,0,0);
	if($array->[0]->[6] eq '+'){
		for(@$array){
			$cds_len+=($_->[4]-$_->[3]+1);
			if($cds_len > $gap_head && $head_gap == 0){
				$head_gap=($_->[3]+($gap_head-$cds_len+($_->[4]-$_->[3]+1)));
			}
			if($cds_len >= $gap_tail && $tail_gap == 0){
				$tail_gap=($_->[3]+($gap_tail-$cds_len+($_->[4]-$_->[3]+1)-1));
			}
		}
		($head_gap,$tail_gap)=($head_gap-$array->[0]->[3],$array->[-1]->[4]-$tail_gap);
		return ($head_gap,$tail_gap);
	}else{
		for(reverse @$array){
			$cds_len+=($_->[4]-$_->[3]+1);
			if($cds_len > $gap_head && $head_gap == 0){
				$head_gap=($_->[3]+($cds_len-$gap_head)-1);
			}
			if($cds_len >= $gap_tail && $tail_gap == 0){
				$tail_gap=($_->[3]+$cds_len-$gap_tail);
			}
		}
		($head_gap,$tail_gap)=($array->[-1]->[4]-$head_gap,$tail_gap-$array->[0]->[3]);
		return ($head_gap,$tail_gap);
	}
}

sub read_gff{
	my ($file,$hash)=@_;
	open IN,$file or die $!;
	while(<IN>){
		next if /^#/;
		chomp;
		my @a=split /\t+/;
		@a[3,4]=@a[4,3] if($a[3] > $a[4]);
		if($a[2] eq 'CDS' && $a[8] =~ /Parent=([^;\s]+)/){
			push @{$$hash{$1}},[@a];
		}
	}
	close IN;
}

