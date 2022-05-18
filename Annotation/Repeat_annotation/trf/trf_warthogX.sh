#!/bin/bash
#SBATCH --time=5-10:10:10
#SBATCH --mem=50000
#SBATCH --ntasks=4
#SBATCH --nodes=1
#SBATCH --output=outputtrf.txt
#SBATCH --error=error_outputtrf.txt
#SBATCH --job-name=trf
#SBATCH --qos=std


#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/trf407b.linux64 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly/Hi-C/Sus_cebifrons.fasta 2 7 7 80 10 50 2000 -d -h

#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/trf407b.linux64 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly_quality/RaGOO/ragoo_output_1/SCEB_ragoo.fa 2 7 7 80 10 50 2000 -d -h


#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/trf407b.linux64 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Compare_SSC11.1/GCA_000003025.6_Sscrofa11.1_genomic.fna.fa.rehead  2 7 7 80 10 50 2000 -d -h


/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/trf407b.linux64 /lustre/nobackup/WUR/ABGC/liu194/analysis/SUS_PAN/WGA/ALLvsSSC_pilon_null/chrX/WARTHOG.X.upper.fa 2 7 7 80 10 50 2000 -d -h
