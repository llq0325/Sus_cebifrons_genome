#!/bin/bash
#SBATCH --job-name=cpgplot
#SBATCH --time=5-10:10:10
#SBATCH --ntasks=2
#SBATCH --nodes=1
#SBATCH --mem=10000
#SBATCH --partition=ABGC_Std
#SBATCH --output=output_cpgplot_%j.txt
#SBATCH --error=error_output_cpgplot_%j.txt


#Gardiner-Garden masked approach (Bock et al., 2007)
#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/EMBOSS-6.6.0/emboss/cpgplot DTG_501_10X_1400M.pseudohap2.1.fasta.rehead.masked -window 100 -minlen 200 -minpc 50 -minoe 0.6 -outfile DTG_501_10X_1400M.pseudohap2.1.fasta.rehead.masked.gc -outfeat DTG_501_10X_1400M.pseudohap2.1.fasta.rehead.masked.gc.gff -noplot

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/EMBOSS-6.6.0/emboss/newcpgreport -sequence DTG_501_10X_1400M.pseudohap2.2.fasta.rehead.masked -window 100 -shift 1 -minlen 200 -minpc 50 -minoe 0.6 -outfile DTG_501_10X_1400M.pseudohap2.1.fasta.rehead.masked.cpgreport
