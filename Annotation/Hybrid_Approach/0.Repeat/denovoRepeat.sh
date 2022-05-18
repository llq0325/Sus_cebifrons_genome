#!/bin/bash
#SBATCH --job-name=denovoRepeatmasker
#SBATCH --time=15-10:10:10
#SBATCH --ntasks=10
#SBATCH --nodes=1
#SBATCH --mem=30000
#SBATCH --qos=std
#SBATCH --output=output_denovoRepeatmodeler_%j.txt
#SBATCH --error=error_output_denovoRepeatmodeler_%j.txt

module load repeatmasker/4.0.7
module load SHARED/RepeatModeler/1.0.7
module load BLAST+


#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/RepeatModeler-open-1.0.11/BuildDatabase -name SCEB_denovo SCEB_repeat.fa

export PERL5LIB=/home/WUR/liu194/perl5/perlbrew/perls/perl-5.20.1/lib/5.20.1
#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/RepeatModeler-open-1.0.11/RepeatModeler -pa 10 -database SCEB_denovo
#RepeatModeler -database SCEB_denovo

RepeatMasker -xsmall -lib /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/0.Repeat/RM_16129.FriDec131058302019/consensi.fa.classified -pa 10 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly_quality/RaGOO/ragoo_output_1/SCEB_ragoo.fa

