phast(version 1.4)
###conserved elements congstructing

###execute the script to estimate the nonconserve model for each chromosome

###This step estimate the non-conserved model;Input file is the treefile of Ruminantia species and the 4DTV sequence;Output file is the non-conserved model file;
nohup phyloFit --tree Ruminantia.treefile -i FASTA 4d.ruminant.67.fasta  --out-root 4d.nonconserved &


###This step split the maf file of each chromsome;Input file is the maf of each chromsome;Output file is the splited maf file;
mkdir split_maf
cd split_maf
for i in {1..29};do mkdir $i;done
cd $i
msa_split $i.maf --in-format MAF  --windows 1000000,0 --out-root split --out-format SS --min-informative 1000 --between-blocks 5000
cd ..
done

###This step estimate the onserved model;Input file is the non-conserved model;Output file is the consered model;
ls *.ss > ss.list
for ss in `cat ss.list`;do phastCons --estimate-rho $ss --no-post-probs $ss 4d.nonconserved.mod;done  

###Get the average model of conserve and non-conserce model;Input file is the model of each $ss;Output file is the average model file;
ls *.cons.mod >all.cons.mod.list
ls *.noncons.mod > all.noncons.mod.list
phyloBoot --read-mods all.cons.mod.list --output-average Ruminantia.ave.cons.mod
phyloBoot --read-mods all.noncons.mod.list --output-average Ruminantia.ave.noncons.mod

###This step get the High conserve element region;Input file are the average conserve and non-conserve model file from last step, maf file from the first step;Output file is the bed file or HCE;
for i in {1..29};do phastCons --most-conserved Ruminantia.$i.bed --score $i.maf Ruminantia.ave.cons.mod,Ruminantia.ave.noncons.mod \> $i.wig;done

###This step filter the region that outgroup spceises have alignment to ruminant species;Input file is the HCE bed file produce by last step and the lst file produce window/synteny/02.maf2gene.sh;Output file is the location information of the passed position(work.out);
perl maf_bed_filter_Type1.pl 1.HCE.bed 1.maf.lst 

###This step convert the location information into region form;Input file is the work.out file produce by last step;Output file is the bed file of the Type1 highly conserved element;
perl work_out2bed.pl 1.work.out

###This step calculate the conservation different between Outgoup and Ruminant species by using phyloP based on an alignment and a model of neutral evolution;Input file are HCE bed file and non-conserved model file produced by other step,maf file;Output file is the conservation p-values and associated statistics result file;
phyloP --subtree Ruminant --msa-format MAF --features 1.HCE.bed --method LRT --mode CONACC 4D.nonconserced.mod 1.maf > element-scores.txt
