#!/bin/bash
#SBATCH --job-name=repeatmasker
#SBATCH --time=5-10:10:10
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --mem=50000
#SBATCH --partition=ABGC_Std
#SBATCH --output=output_repeatmodeler_%j.txt
#SBATCH --error=error_output_repeatmodeler_%j.txt

module load repeatmasker/4.0.7
module load BLAST+
RepeatMasker -xsmall -species pig -pa 8 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly/Hi-C/Sus_cebifrons.fasta
#RM_225036.WedMay291642212019
