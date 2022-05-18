#!/bin/bash
#SBATCH --job-name=FEELnc
#SBATCH --time=10-0
#SBATCH --cpus-per-task=4
#SBATCH --mem=16000
#SBATCH --qos=std
#SBATCH --output=output_FEELnc_%j.txt
#SBATCH --error=error_output_FEELnc_%j.txt

source ~/miniconda2/bin/activate /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/FEELnc

#Filter
#FEELnc_filter.pl -i /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/3.RNAseq/C1/SCEB.gtf -a /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/BRAKER_20190823/final_assembly_annotation/sus_cebifrons.gtf.gene_id -b transcript_biotype=protein_coding -p 4 > candidate_lncRNA.gtf

#Coding Potential
FEELnc_codpot.pl -i candidate_lncRNA.gtf -a /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/BRAKER_20190823/final_assembly_annotation/sus_cebifrons.gtf.gene_id -b transcript_biotype=protein_coding -g /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/BRAKER_20190823/final_assembly_annotation/sus_cebifrons.fa --mode=shuffle

#Classifier
FEELnc_classifier.pl -i feelnc_codpot_out/candidate_lncRNA.gtf.lncRNA.gtf -a /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/BRAKER_20190823/final_assembly_annotation/sus_cebifrons.gtf.gene_id > candidate_lncRNA_classes.txt
