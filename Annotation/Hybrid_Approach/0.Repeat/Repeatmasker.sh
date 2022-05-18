#!/bin/bash
#SBATCH --job-name=repeatmasker
#SBATCH --time=20-10:10:10
#SBATCH --ntasks=20
#SBATCH --nodes=1
#SBATCH --mem=50000
#SBATCH --qos=std
#SBATCH --output=output_repeatmodeler_%j.txt
#SBATCH --error=error_output_repeatmodeler_%j.txt

#module load repeatmasker/4.0.7
module load BLAST+
/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/RepeatMasker/RepeatMasker -xsmall -species pig -pa 20 SCEB_repeat.fa -gff

#RM_225036.WedMay291642212019
