#!/bin/bash
#SBATCH --time=15-10:10:10
#SBATCH --mem=200000
#SBATCH --ntasks=10
#SBATCH --nodes=1
#SBATCH --output=outputRaGOO.txt
#SBATCH --error=error_outputRaGOO.txt
#SBATCH --job-name=RaGOO
#SBATCH --qos=std


module load python

#ln -s /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/BRAKER/final_assembly_annotation/sus_cebifrons.fa 
#ln -s /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly_quality/Multi-CSAR/ref/GCA_000003025.6_Sscrofa11.1_genomic.fna.fa.rehead
#ln -s /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly_quality/Gapfiller/jump_reads/20kb.fa 
ln -s /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly_quality/Gapfiller/jump_reads/jump.fa 

python3 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/RaGOO/ragoo.py -C -t 10 -m /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin/minimap2 -R jump.fa -T sr sus_cebifrons.fa GCA_000003025.6_Sscrofa11.1_genomic.fna.fa.rehead
