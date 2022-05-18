my $dir = $ARGV[0];
my $input = $ARGV[1]; #input file
my $calib = $ARGV[2];
my $sigma2 = $ARGV[3].' '.$ARGV[4];
my $rgene = $ARGV[5].' '.$ARGV[6];
system ("mkdir $dir");
system ("cp $input $dir");
system ("cp $calib $dir");
open CTLBV, ">$dir/mcmctree_BV.ctl";
print CTLBV "seed = -1
seqfile = $input
treefile = $calib
outfile = out_main
ndata = 20 #pam
usedata = 3
clock = 2
RootAge = '<80.0'
model = 4 
alpha = 1
ncatG = 4
cleandata = 1
BDparas = 1 1 0
kappa_gamma = 6 2
alpha_gamma = 1 1
rgene_gamma = $rgene
sigma2_gamma = $sigma2
finetune = 1: .05  0.1  0.12  0.1 .3
print = 1
burnin = 1000
sampfreq = 10
nsample = 1000";
open CTL, ">$dir/mcmctree.ctl";
print CTL "seed = -1
seqfile = $input
treefile = $calib
outfile = out_main
ndata = 20
usedata = 2 in.BV 
clock = 2
RootAge = '<80.0'
model = 4 
alpha = 1
ncatG = 4
cleandata = 1
BDparas = 1 1 0
kappa_gamma = 6 2
alpha_gamma = 1 1
rgene_gamma = $rgene
sigma2_gamma = $sigma2
finetune = 1: .05  0.1  0.12  0.1 .3
print = 1
burnin = 250000000
sampfreq = 1000000
nsample = 1000";

my $cmd = "/lustre/scratch/WUR/ABGC/liu194/paml/src/mcmctree "."mcmctree_BV.ctl\ncp out.BV in.BV\n";
$cmd .= "/lustre/scratch/WUR/ABGC/liu194/paml/src/mcmctree "."mcmctree.ctl";
open SH, ">tmp.sh";
print SH "$cmd\n";
system ("cp tmp.sh $dir/");
chdir "$dir";
#system ("cd $dir");
system("sh tmp.sh");
#system ("cd ../");

#os.system()

