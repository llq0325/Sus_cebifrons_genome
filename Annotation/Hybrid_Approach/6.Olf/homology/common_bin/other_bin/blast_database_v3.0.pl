#!/usr/bin/perl

=head1 Name

blast_database.pl  --  the pipeline to run blast against several databases

=head1 Description

This program is the pipeline to run blast. Note that the databases except user defined 
database must be formated previously, better to use formatdb in the same version with
blastall invoked in this program. The "--program" option must be set corrected corresponding
to the databases. 

Nucleotide database: nt,
Protein database: nr, swissprot, trembl, cog, kegg, 

=head1 Version

  Author: Fan Wei, fanw@genomics.org.cn
  Version: 3.0,  Date: 2008-12-11
  Note:

=head1 Usage
  
  perl blast_database.pl [options] <sequences.fa>
  --program      set the program of blastall, default blastp
  --evalue       set the E-val for blast, default 1e-5
  --nr           search against Nr database
  --nt           search against Nt database
  --swissprot    search against SwissProt database	
  --trembl       search against TrEMBL database
  --cog          search against Cog database
  --kog 	 search against Kog database
  --kegg         search against	Kegg database
  --tedna        search against Repbase's RepeatMasker DNA database
  --tepep        search against RepeatProteinMask protein database
  --db <str>     search against user defined database
  --cutf <int>   set the number of subfiles to generate, default=100
  --cpu <int>	 set the cpu number to use in parallel, default=30   
  --run <str>    set the parallel type, qsub, or multi, default=qsub
  --note <str>   set the compute note, default h=compute-0-150
  --vf <str>  set the vf, default 0.9G
  --outdir <str>  set the result directory, default="."
  --verbose   output running progress information to screen  
  --help      output help information to screen  

=head1 Exmple

  nohup perl ../bin/blast_database.pl --program blastn --nt --tedna ../input/cucumber.reas.fa -run multi -cpu 2 -outdir cucumber_reas &
  nohup perl ../bin/blast_database.pl --program blastp --nr  --swissprot --trembl --cog  --kegg --tepep ../input/rice_prot3000.fa -outdir ./rice_prot3000 -run multi -cpu 4 &
  

=cut

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname); 
use Data::Dumper;
use File::Path;  ## function " mkpath" and "rmtree" deal with directory
use lib "$Bin/../../common_bin";
use GACP qw(parse_config);


my ($Program,$Evalue,$Nr,$Nt,$Swissprot,$TrEMBL,$Cog,$Kog,$Kegg,$TEdna,$TEpep,$Vf,$Userdb,$Cutf,$Cpu,$Run,$Outdir);
my ($Verbose,$Help,$Node);
GetOptions(
	"program:s"=>\$Program,
	"evalue:s"=>\$Evalue,
	"nr"=>\$Nr,
	"nt"=>\$Nt,
	"swissprot"=>\$Swissprot,
	"trembl"=>\$TrEMBL,
	"cog"=>\$Cog,
	"kog"=>\$Kog,
	"kegg"=>\$Kegg,
	"tedna"=>\$TEdna,
	"tepep"=>\$TEpep,
	"db:s"=>\$Userdb,
	"cutf:i"=>\$Cutf,
	"cpu:i"=>\$Cpu,
	"run:s"=>\$Run,
        "node:s"=>\$Node,
        "vf:s"=>\$Vf,
	"outdir:s"=>\$Outdir,
	"verbose"=>\$Verbose,
	"help"=>\$Help
);
$Program ||= "blastp";
$Evalue ||= 1e-5;
$Cutf ||= 100;
$Cpu ||= 30;
#$Node ||= "h=compute-0-189";
my $Node_para=(defined $Node)?"-node $Node":"";
$Vf ||= "0.9G";
$Run ||= "qsub";
$Outdir ||= ".";
die `pod2text $0` if (@ARGV == 0 || $Help);

my $seq_file = shift;
my $seq_file_name = basename($seq_file);

my $userdb;
$userdb = basename($Userdb) if(defined $Userdb);

my $config_file = "$Bin/../../config.txt";
my $common_bin = "$Bin/../../common_bin";


my $blast = parse_config($config_file,"blastall")." -b 500  -v  500 -F F";;
my $formatdb = parse_config($config_file,"formatdb");

my $nr = parse_config($config_file,"nr")."/nr";
my $nt = parse_config($config_file,"nt")."/nt";
my $swissprot = parse_config($config_file,"swissprot");
my $trembl = parse_config($config_file,"trembl");
my $cog = parse_config($config_file,"cog");
my $kog = parse_config($config_file,"kog");
my $kegg = parse_config($config_file,"kegg");
my $tedna = parse_config($config_file,"tedna");
my $tepep = parse_config($config_file,"tepep");

my $fastaDeal = "$common_bin/fastaDeal.pl";
my $blast_parser = "$common_bin/blast_parser.pl";
my $qsub_sge = "$common_bin/qsub-sge.pl";
my $multi_process = "$common_bin/multi-process.pl";

my $blast_shell_file = "./$seq_file_name.blast.$$.sh"; ##只能放在当前目录下
my $blast_parser_file = "./$seq_file_name.blast_parser.$$.sh";
my @subfiles;

$Outdir =~ s/\/$//;
mkdir($Outdir) unless(-d $Outdir);

`perl $fastaDeal -cutf $Cutf $seq_file -outdir $Outdir`;
@subfiles = glob("$Outdir/$seq_file_name.cut/*.*");

###format the user defined database, judge the type automatically.
if (defined $Userdb) {
		my $seq_type = judge_type($Userdb);
		`$formatdb -p F -o T -i $Userdb` if ($seq_type eq "DNA");
		`$formatdb -p T -o T -i $Userdb` if ($seq_type eq "Protein");
}

##create shell file
open OUT,">$blast_shell_file" || die "fail $blast_shell_file";
foreach my $subfile (@subfiles) {
	print OUT "$blast  -p $Program -e $Evalue  -d $nr -i $subfile -o $subfile.nr.blast; \n" if(defined $Nr);
	print OUT "$blast  -p $Program -e $Evalue  -d $nt -i $subfile -o $subfile.nt.blast; \n" if(defined $Nt);
	print OUT "$blast  -p $Program -e $Evalue  -d $swissprot -i $subfile -o $subfile.swissprot.blast; \n" if(defined $Swissprot);
	print OUT "$blast  -p $Program -e $Evalue  -d $trembl -i $subfile -o $subfile.trembl.blast; \n" if(defined $TrEMBL);
	print OUT "$blast  -p $Program -e $Evalue  -d $cog -i $subfile -o $subfile.cog.blast; \n" if(defined $Cog);
	print OUT "$blast  -p $Program -e $Evalue  -d $kog -i $subfile -o $subfile.kog.blast; \n" if(defined $Kog);
	print OUT "$blast  -p $Program -e $Evalue  -d $kegg -i $subfile -o $subfile.kegg.blast; \n" if(defined $Kegg);
	print OUT "$blast  -p $Program -e $Evalue  -d $Userdb -i $subfile -o $subfile.$userdb.blast; \n" if(defined $Userdb);
	print OUT "$blast  -p $Program -e $Evalue  -d $tedna -i $subfile -o $subfile.tedna.blast; \n" if(defined $TEdna);
	print OUT "$blast  -p $Program -e $Evalue  -d $tepep -i $subfile -o $subfile.tepep.blast; \n" if(defined $TEpep);
}
close OUT;

#die;
#run the shell file
`$qsub_sge  --maxjob $Cpu --resource vf=$Vf $Node_para --reqsub $blast_shell_file` if ($Run eq "qsub");
`$multi_process -cpu $Cpu $blast_shell_file` if ($Run eq "multi");


##cat together the result
open OUT2,">$blast_parser_file" || die "fail $blast_shell_file";

print OUT2 "cat $Outdir/$seq_file_name.cut/*.nr.blast > $Outdir/$seq_file_name.nr.blast; \n" if(defined $Nr);
print OUT2 "cat $Outdir/$seq_file_name.cut/*.nt.blast > $Outdir/$seq_file_name.nt.blast; \n " if(defined $Nt);
print OUT2 "cat $Outdir/$seq_file_name.cut/*.swissprot.blast > $Outdir/$seq_file_name.swissprot.blast; \n " if(defined $Swissprot);
print OUT2 "cat $Outdir/$seq_file_name.cut/*.trembl.blast > $Outdir/$seq_file_name.trembl.blast;  \n " if(defined $TrEMBL);
print OUT2 "cat $Outdir/$seq_file_name.cut/*.cog.blast > $Outdir/$seq_file_name.cog.blast;  \n " if(defined $Cog);
print OUT2 "cat $Outdir/$seq_file_name.cut/*.kog.blast > $Outdir/$seq_file_name.kog.blast;  \n " if(defined $Kog);
print OUT2 "cat $Outdir/$seq_file_name.cut/*.kegg.blast > $Outdir/$seq_file_name.kegg.blast;  \n " if(defined $Kegg);
print OUT2 "cat $Outdir/$seq_file_name.cut/*.$userdb.blast > $Outdir/$seq_file_name.$userdb.blast;  \n " if(defined $Userdb);
print OUT2 "cat $Outdir/$seq_file_name.cut/*.tedna.blast > $Outdir/$seq_file_name.tedna.blast;  \n " if(defined $TEdna);
print OUT2 "cat $Outdir/$seq_file_name.cut/*.tepep.blast > $Outdir/$seq_file_name.tepep.blast;  \n " if(defined $TEpep);


##covert to table format, and keep all the hits
print OUT2 "$blast_parser   $Outdir/$seq_file_name.nr.blast > $Outdir/$seq_file_name.nr.blast.tab; \n " if(defined $Nr);
print OUT2 "$blast_parser   $Outdir/$seq_file_name.nt.blast > $Outdir/$seq_file_name.nt.blast.tab;  \n " if(defined $Nt);
print OUT2 "$blast_parser   $Outdir/$seq_file_name.swissprot.blast > $Outdir/$seq_file_name.swissprot.blast.tab;  \n " if(defined $Swissprot);
print OUT2 "$blast_parser   $Outdir/$seq_file_name.trembl.blast > $Outdir/$seq_file_name.trembl.blast.tab;  \n " if(defined $TrEMBL);
print OUT2 "$blast_parser   $Outdir/$seq_file_name.cog.blast > $Outdir/$seq_file_name.cog.blast.tab;  \n " if(defined $Cog);
print OUT2 "$blast_parser   $Outdir/$seq_file_name.kog.blast > $Outdir/$seq_file_name.kog.blast.tab;  \n " if(defined $Kog);
print OUT2 "$blast_parser   $Outdir/$seq_file_name.kegg.blast > $Outdir/$seq_file_name.kegg.blast.tab;  \n " if(defined $Kegg);
print OUT2 "$blast_parser   $Outdir/$seq_file_name.$userdb.blast > $Outdir/$seq_file_name.$userdb.blast.tab;  \n " if(defined $Userdb);
print OUT2 "$blast_parser   $Outdir/$seq_file_name.tedna.blast  >  $Outdir/$seq_file_name.tedna.blast.tab;  \n " if(defined $TEdna);
print OUT2 "$blast_parser   $Outdir/$seq_file_name.tepep.blast  >  $Outdir/$seq_file_name.tepep.blast.tab;  \n " if(defined $TEpep);


##covert to table format, and get the the best hit
print OUT2 "$blast_parser  -tophit 1 -topmatch 1   $Outdir/$seq_file_name.nr.blast > $Outdir/$seq_file_name.nr.blast.tab.best;\n " if(defined $Nr);
print OUT2 "$blast_parser  -tophit 1 -topmatch 1   $Outdir/$seq_file_name.nt.blast > $Outdir/$seq_file_name.nt.blast.tab.best; \n "if(defined $Nt);
print OUT2 "$blast_parser  -tophit 1 -topmatch 1   $Outdir/$seq_file_name.swissprot.blast > $Outdir/$seq_file_name.swissprot.blast.tab.best; \n " if(defined $Swissprot);
print OUT2 "$blast_parser  -tophit 1 -topmatch 1   $Outdir/$seq_file_name.trembl.blast > $Outdir/$seq_file_name.trembl.blast.tab.best; \n " if(defined $TrEMBL);
print OUT2 "$blast_parser  -tophit 1 -topmatch 1   $Outdir/$seq_file_name.cog.blast > $Outdir/$seq_file_name.cog.blast.tab.best; \n " if(defined $Cog);
print OUT2 "$blast_parser  -tophit 1 -topmatch 1   $Outdir/$seq_file_name.kog.blast > $Outdir/$seq_file_name.kog.blast.tab.best; \n " if(defined $Kog);
print OUT2 "$blast_parser  -tophit 1 -topmatch 1   $Outdir/$seq_file_name.kegg.blast > $Outdir/$seq_file_name.kegg.blast.tab.best; \n " if(defined $Kegg);
print OUT2 "$blast_parser  -tophit 1 -topmatch 1   $Outdir/$seq_file_name.$userdb.blast > $Outdir/$seq_file_name.$userdb.blast.tab.best; \n " if(defined $Userdb);
 print OUT2 "$blast_parser  -tophit 1 -topmatch 1   $Outdir/$seq_file_name.tedna.blast  >  $Outdir/$seq_file_name.tedna.blast.tab.best; \n " if(defined $TEdna);
print OUT2 "$blast_parser  -tophit 1 -topmatch 1   $Outdir/$seq_file_name.tepep.blast  >  $Outdir/$seq_file_name.tepep.blast.tab.best; \n " if(defined $TEpep);
`$qsub_sge  --reqsub  -line 3 $Node_para $blast_parser_file` if ($Run eq "qsub");
`$multi_process -cpu 1  $blast_parser_file`  if ($Run eq "multi");
##clean data files
##`rm -r $Outdir/$seq_file_name.cut`;
`mv $blast_shell_file* $Outdir`;
`rm $Userdb.*p??` if(defined $Userdb);

####################################################
################### Sub Routines ###################
####################################################


##judge DNA or protein automatically
sub judge_type {
	my $file = shift;
	my $sequence;
	open(IN, $file) || die ("can not open $file\n");
	while (<IN>) {
		next if(/^>/);
		$sequence .= $_;
		$sequence =~ s/\s//sg;
		$sequence =~ s/-//sg;
		last if(length($sequence) >= 100000);
	}
	close(IN);
	my $base_num = $sequence=~tr/ACGTNacgtn//;
	my $type = ($base_num / length($sequence) > 0.9) ? "DNA" : "Protein";
	return $type;
}

