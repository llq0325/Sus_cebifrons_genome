#!/bin/bash
#SBATCH --time=20-10:10:10
#SBATCH --mem=30000
#SBATCH --ntasks=20
#SBATCH --nodes=1
#SBATCH --output=outputOrtho.txt
#SBATCH --error=error_outputOrtho.txt
#SBATCH --job-name=OrthoFinder
#SBATCH --qos=std

export PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin:/home/WUR/liu194/miniconda2/bin:$PATH

~/miniconda2/bin/python ~/miniconda2/bin/orthofinder -t 20 -a 20 -S diamond -f /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Genome_Compare/OrthoFinder/SSC_SCEB -M msa -T iqtree
