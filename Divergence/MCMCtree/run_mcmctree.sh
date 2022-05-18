#!/bin/bash
#SBATCH --time=10-10:10:10
#SBATCH --mem=32001
#SBATCH --ntasks=10
#SBATCH --nodes=1
#SBATCH --output=outputmakeinoput.txt
#SBATCH --error=error_outputmakeinput.txt
#SBATCH --job-name=test-makeinput_matrix
#SBATCH --qos=std


###making input###


###making matrix###
module load javacd bi

cd tmp2

cp /lustre/nobackup/WUR/ABGC/liu194/analysis/Analysis11.1/PAML/readseq.jar ./

module load java
ID=`cat /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Gene_evolution/Orth_0905/seqlist.txt.test`
for Line in $ID;do

#java -cp readseq.jar run -f 12 -o $Line.phy ../tmp1/$Line

/cm/shared/apps/SHARED/RAxML/RAxML8.0.0/raxmlHPC-PTHREADS-SSE3 -T 10 -f x -t ../bin/fixed_tree_cons -m GTRGAMMA -n $Line -s /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Gene_evolution/Orth_0905/SCO_seq/$Line.fix.phylip

done
#rename .fasta "" RAxML_distances*.fasta
cd ..

###mcmctree###
mkdir paml;cd paml

cp /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Divergence/MCMCtree/bin/* ./

perl make_matrix.pl ../tmp2/RAxML_distances* > matrix_distance.txt

module load R

Rscript clustering_20.R

perl make_input_cluster_mod.pl cluster.txt /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Gene_evolution/Orth_0905/SCO_seq > input_PAMclust_20.txt

mkdir Rgene

module load paml/4.9c

perl auto_mcmctree.pl Rgene input_PAMclust_20.txt calib 1 1 1 100

cd Rgene;cp /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Divergence/MCMCtree/bin/rgene.pl rgene.pl;cp /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Divergence/MCMCtree/bin/root_calib root_calib

mcmctree mcmctree_BV.ctl

perl rgene.pl tmp*ctl | tail -1 > rgene.txt

