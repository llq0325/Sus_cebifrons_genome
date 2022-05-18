#!/bin/bash
#SBATCH --job-name=blastp
#SBATCH --time=5-0
#SBATCH --cpus-per-task=10
#SBATCH --mem=20000
#SBATCH --qos=std
#SBATCH --output=output_blast_%j.txt
#SBATCH --error=error_output_blast_%j.txt

module load BLAST+

blastp -query /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/EVM_SCEB13_20200225/EVM.nodot.aa -db /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/uniprot_db/uniprot_sprot -num_threads 10 -outfmt 6 -out translation_to_sprot.tsv

