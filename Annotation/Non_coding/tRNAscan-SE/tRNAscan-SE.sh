#!/bin/bash
#SBATCH --job-name=tRNAscan-SE
#SBATCH --time=10-10:10:10
#SBATCH --ntasks=4
#SBATCH --nodes=1
#SBATCH --mem=20000
#SBATCH --qos=std
#SBATCH --output=output_tRNAscan-SE_%j.txt
#SBATCH --error=error_output_tRNAscan-SE_%j.txt

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/tRNAscan-SE-2.0/tRNAscan-SE -o tRNA_pig_bos_SCEB13 -E -L --tmode strict --emode relaxed -D -c /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/tRNAscan-SE-2.0/tRNAscan-SE.conf /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_SCEB13/0.Repeat/SCEB.masked.fa
