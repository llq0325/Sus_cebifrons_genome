#!/bin/bash
#SBATCH --job-name=InfernalRfam
#SBATCH --time=10-10:10:10
#SBATCH --ntasks=15
#SBATCH --nodes=1
#SBATCH --mem=20000
#SBATCH --qos=std
#SBATCH --output=output_InfernalRfam_%j.txt
#SBATCH --error=error_output_InfernalRfam_%j.txt

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/infernal-1.1.2-linux-intel-gcc/binaries/cmscan \
	--cpu 15 \
	--tblout Rfam.out.SCEB13.tsv \
	--fmt 2 \
	--verbose \
	/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/infernal-1.1.2-linux-intel-gcc/Rfam.cm \
	/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_SCEB13/0.Repeat/SCEB.masked.fa
