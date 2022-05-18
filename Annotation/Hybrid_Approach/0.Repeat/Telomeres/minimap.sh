#!/bin/bash
#SBATCH --time=5-10:10:10
#SBATCH --mem=50000
#SBATCH --ntasks=10
#SBATCH --nodes=1
#SBATCH --output=outputmummer.txt
#SBATCH --error=error_outputmummer.txt
#SBATCH --job-name=mummer
#SBATCH --qos=std


module load python
module load perl
module load gcc
module load SHARED/MUMmer/3.23
export PERL5LIB=/home/WUR/liu194/perl5/perlbrew/perls/perl-5.20.1/lib/perl5


/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/minimap2/minimap2 -x asm5 -t 10 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/EVM_SCEB13_20200225/final_assembly_annotation/sus_cebifrons.fa Telo_pig.fa > Telo_SCEB.paf
