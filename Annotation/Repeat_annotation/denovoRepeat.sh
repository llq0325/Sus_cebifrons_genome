#!/bin/bash
#SBATCH --job-name=denovoRepeatmasker
#SBATCH --time=15-10:10:10
#SBATCH --ntasks=20
#SBATCH --nodes=1
#SBATCH --mem=30000
#SBATCH --qos=std
#SBATCH --output=output_denovoRepeatmodeler_%j.txt
#SBATCH --error=error_output_denovoRepeatmodeler_%j.txt

module load repeatmasker/4.0.7
module load SHARED/RepeatModeler/1.0.7
module load BLAST+


#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/RepeatModeler-open-1.0.11/BuildDatabase -name SCEB /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly/Hi-C/Sus_cebifrons.fasta

export PERL5LIB=/home/WUR/liu194/perl5/perlbrew/perls/perl-5.20.1/lib/5.20.1
#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/RepeatModeler-open-1.0.11/RepeatModeler -pa 10 -database SCEB
#RepeatModeler -database SCEB

#RepeatMasker -lib RM_15691.MonMay61007152019/consensi.fa.classified -pa 8 -dir ./denovo /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly/Hi-C/Sus_cebifrons.fasta

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/RepeatMasker/RepeatMasker -lib RM_94646.ThuMay301006052019/consensi.fa.classified -pa 20 SCEB_repeat.fa -gff

