#!/bin/bash
#SBATCH --time=20-10:10:10
#SBATCH --mem=30000
#SBATCH --ntasks=4
#SBATCH --nodes=1
#SBATCH --output=outputmcmctree.txt
#SBATCH --error=error_outputmcmctree.txt
#SBATCH --job-name=MCMCtree
#SBATCH --qos=std
 
module load paml/4.9c
perl auto_mcmctree_final.pl mcmctree input_PAMclust_20.txt calib 1 1 1 74 

#cd Rgene

#/lustre/scratch/WUR/ABGC/liu194/paml/src/mcmctree mcmctree_BV.ctl

#perl rgene.pl tmp*ctl | tail -1 > rgene.txt
