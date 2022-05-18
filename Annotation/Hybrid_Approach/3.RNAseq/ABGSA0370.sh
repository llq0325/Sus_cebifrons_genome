#!/bin/bash
#SBATCH --time=4-10:10:10
#SBATCH --mem=20000
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --output=outputABGSA0370.txt
#SBATCH --error=error_outputABGSA0370.txt
#SBATCH --job-name=ABGSA0370
#SBATCH --partition=ABGC_Std

module load samtools

#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/hisat2-2.1.0/hisat2-build /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly/DTG_501_10X_1400M.pseudohap2.2.fasta.rehead SCEB_index

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/hisat2-2.1.0/hisat2 -x SCEB_index -p 8 -1 /lustre/nobackup/WUR/ABGC/shared/Pig/Scebi_RNAseq/ABGSA0370/FCC4JN2ACXX-WHPIGcieTAACRAAPEI-129_L7_1.fq.gz -2 /lustre/nobackup/WUR/ABGC/shared/Pig/Scebi_RNAseq/ABGSA0370/FCC4JN2ACXX-WHPIGcieTAACRAAPEI-129_L7_2.fq.gz  | samtools view -S - -b > ABGSA0370.bam

samtools sort -o ABGSA0370_sorted.bam ABGSA0370.bam

samtools index ABGSA0370_sorted.bam
