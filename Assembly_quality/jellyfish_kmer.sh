#!/bin/bash
#SBATCH --time=10-10:10:10
#SBATCH --mem=80000
#SBATCH --ntasks=10
#SBATCH --nodes=1
#SBATCH --job-name=21mer
#SBATCH --partition=ABGC_Std

#module load SHARED/jellyfish/2.1.1

#zcat /lustre/nobackup/WUR/ABGC/shared/Pig/Visayan_Warty_pig_10X/data/DTG_DNA_501_S65_R1_001.fastq.gz | /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/jellyfish-linux count -t 10 -C -m 21 -s 5G -o SCEB_25mer /dev/fd/0
#<(zcat /lustre/nobackup/WUR/ABGC/shared/Pig/Visayan_Warty_pig_10X/data/DTG_DNA_501_S65_R1_001.fastq.gz) <(zcat /lustre/nobackup/WUR/ABGC/shared/Pig/Visayan_Warty_pig_10X/data/DTG_DNA_501_S65_R2_001.fastq.gz)

#srun gunzip -c /lustre/nobackup/WUR/ABGC/shared/Pig/Visayan_Warty_pig_10X/data/DTG_DNA_501_S65_R1_001.fastq.gz /lustre/nobackup/WUR/ABGC/shared/Pig/Visayan_Warty_pig_10X/data/DTG_DNA_501_S65_R2_001.fastq.gz |jellyfish count -m 19 -t 8 -C -s 5G -o SCEB_25mer --min-qual-char=? /dev/fd/0 

#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/jellyfish-linux histo -t 10 -o SECB_25mer.histo_0 SCEB_25mer_0
#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/jellyfish-linux histo -t 10 -o SECB_25mer.histo_1 SCEB_25mer_1
#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/jellyfish-linux histo -t 10 -o SECB_25mer.histo_2 SCEB_25mer_2
#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/jellyfish-linux histo -t 10 -o SECB_25mer.histo_3 SCEB_25mer_3
/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/jellyfish-linux merge -o SCEB_25mer.jf SCEB_25mer_*
/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/jellyfish-linux histo -t 10 -o SECB_25mer.histo SCEB_25mer.jf


#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/kmerfreq/kmerfreq -k 19 -t 10 kmerfreq.lib 
