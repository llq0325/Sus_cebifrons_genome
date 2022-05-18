#!/bin/bash
#SBATCH --time=10-10:10:10
#SBATCH --mem=10000
#SBATCH --ntasks=2
#SBATCH --nodes=1
#SBATCH --output=outputPhylo-HMRF.txt
#SBATCH --error=error_outputPhylo-HMRF.txt
#SBATCH --job-name=PHYLO
#SBATCH --qos=std

export PATH=$PATH:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Phylo-HMRF

/lustre/nobackup/WUR/ABGC/liu194/analysis/bin/miniconda2/bin/python /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Phylo-HMRF/phylo_hmrf_two_SCEB_SSC.py -n 20 -r 1 --reload 0 --chromvec 16 --miter 100 --ref_species SSC --output $PWD/chr16_output
