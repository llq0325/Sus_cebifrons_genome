#!/bin/bash
#SBATCH --time=20-10:10:10
#SBATCH --mem=250000
#SBATCH --ntasks=20
#SBATCH --nodes=1
#SBATCH --output=outputWGA.txt
#SBATCH --error=error_outputWGA.txt
#SBATCH --job-name=svmu
#SBATCH --qos=std

export PATH=$PATH:/lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/bin/last-980/bin
module load gcc
module load python
module load perl

#/lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/bin/mummer-4.0.0beta2/nucmer -t 20 /lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/Genome_Compare/Genome_ensembl/ENSEMBL_sm/pig.sm.fa /lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/Genome_Compare/Genome_ensembl/ENSEMBL_sm/SCEB.sm.id.fa -p pig_SCEB


#/lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/svmu/svmu pig_SCEB.delta /lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/Genome_Compare/Genome_ensembl/ENSEMBL_sm/pig.sm.fa /lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/annotation/Hybrid_Approach_SCEB13/0.Repeat/SCEB.masked.fa 100 l > pig_SCEB.100.txt.20191219

/lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/svmu/svmu /lustre/nobackup/WUR/ABGC/liu194/analysis/SUS_PAN/WGA/ALLvsSSC_pilon_null/WARTHOG.delta /lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/Genome_Compare/Genome_ensembl/ENSEMBL_sm/pig.sm.fa /lustre/nobackup/WUR/ABGC/liu194/analysis/SUS_PAN/WARTHOG/WARTHOG.fa.masked 100 l > pig_WARTHOG.100.txt.20201030



#/lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/bin/mummer-4.0.0beta2/delta-filter -1 SCEB.delta > SCEB.filter

#/lustre/nobackup/WUR/ABGC/liu194/analysis/Vasayan_Warty_pig_10X/bin/MUMmer3.20/src/tigr/delta2maf SCEB.filter > SCEB.maf

#./delta2maf SCEB.filter > SCEB.maf

#perl rename.pl SCEB.maf SCEB > SCEB.n.maf


