#!/bin/bash
#SBATCH --time=5-10:10:10
#SBATCH --mem=500000
#SBATCH --ntasks=4
#SBATCH --nodes=1
#SBATCH --output=outputtrf.txt
#SBATCH --error=error_outputtrf.txt
#SBATCH --job-name=trf
#SBATCH --partition=ABGC_Std


/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/trf407b.linux64 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly/DTG_501_10X_1400M.pseudohap2.2.fasta.rehead 2 7 7 80 10 50 2000
