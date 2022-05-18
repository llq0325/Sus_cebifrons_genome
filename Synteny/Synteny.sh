#!/bin/bash
#SBATCH --time=5-10:10:10
#SBATCH --mem=50000
#SBATCH --ntasks=10
#SBATCH --nodes=1
#SBATCH --output=outputSynteny.txt
#SBATCH --error=error_outputSynteny.txt
#SBATCH --job-name=Synteny
#SBATCH --partition=ABGC_Std


export GENEMARK_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/gm_et_linux_64/gmes_petap
export AUGUSTUS_CONFIG_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/config
export AUGUSTUS_BIN_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/bin
export AUGUSTUS_SCRIPTS_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/scripts
export PERL5LIB=/home/WUR/liu194/perl5/perlbrew/perls/perl-5.20.1/lib/perl5
export PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/bin:$PATH

module load java
module load bamtools
module load samtools
module load BLAST+/2.2.28
module load python
module load perl

makeblastdb -in Sus_scrofa.Sscrofa11.1.pep.all.fa -dbtype prot -parse_seqids -out SSC.db
#makeblastdb -in /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/BRAKER/final_assembly_annotation/sus_cebifrons_protein.fa -dbtype prot -parse_seqids -out SCEB.db

blastp -query SCEB.fa -db SSC.db -out SCEBvsSSC.blast -evalue 1e-10 -num_threads 10 -outfmt 6 -num_alignments 5

#cat /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/BRAKER/final_assembly_annotation/sus_cebifrons.gff /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Genome_Compare/Genome_ensembl/pig.gff3 > SCEBvsSSC.gff

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/MCScanX/MCScanX SCEBvsSSC
