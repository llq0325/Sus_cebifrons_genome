#!/bin/bash
#SBATCH --job-name=interproscan
#SBATCH --time=10-0
#SBATCH --cpus-per-task=20
#SBATCH --mem=16000
#SBATCH --qos=std
#SBATCH --output=output_ip_%j.txt
#SBATCH --error=error_output_ip_%j.txt

module load BLAST+
module load java/jre/1.8.0/144 
module load python

for Start in $(seq 1 1000 44000);do

End=`expr $Start + 999`

~/miniconda2/bin/seqkit range -r ${Start}:${End} /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/EVM_SCEB13_20200225/EVM.nodot.aa > tmp.fasta

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/interproscan-5.35-74.0/interproscan.sh --cpu 20 -i tmp.fasta -f tsv

cat tmp.fasta.tsv >> interproscan.tsv

rm tmp.fasta tmp.fasta.tsv

done

#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/interproscan-5.35-74.0/interproscan.sh --cpu 8 -i /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/braker/sus_cebifrons_hic_sceb/sceb.braker.translation.nodot.fa -f tsv -dp
