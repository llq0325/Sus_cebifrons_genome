#!/bin/bash
#SBATCH --time=20-10:10:10
#SBATCH --mem=150000
#SBATCH --ntasks=2
#SBATCH --nodes=1
#SBATCH --output=outputWGA.txt
#SBATCH --error=error_outputWGA.txt
#SBATCH --job-name=mu
#SBATCH --qos=std

export PATH=$PATH:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/last-980/bin
module load gcc
module load python
module load perl

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/MUMmer3.23/nucmer /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Genome_Compare/Genome_ensembl/pig.fa /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Genome_Compare/Genome_ensembl/human.fa -p human

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/MUMmer3.23/delta-filter -1 human.delta > human.filter

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/MUMmer3.23/delta2maf human.filter > human.maf

perl rename.pl human.maf human > human.n.maf


