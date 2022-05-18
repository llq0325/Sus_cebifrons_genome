#!/bin/bash
#SBATCH --time=5-10:10:10
#SBATCH --mem=200000
#SBATCH --ntasks=4
#SBATCH --nodes=1
#SBATCH --output=outputmummer.txt
#SBATCH --error=error_outputmummer.txt
#SBATCH --job-name=mummer
#SBATCH --partition=ABGC_Std


module load python
module load perl
#module load SHARED/MUMmer/3.23

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/MUMmer3.23/nucmer GCA_000003025.6_Sscrofa11.1_genomic.fna.fa.rehead /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly/Hi-C/Sus_cebifrons.fasta

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/MUMmer3.23/delta-filter -q -r out.delta > SECBvcSSC.filter

#mummerplot --png -q  
