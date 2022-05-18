#!/bin/bash
#SBATCH --time=20-10:10:10
#SBATCH --mem=200000
#SBATCH --ntasks=2
#SBATCH --nodes=1
#SBATCH --output=outputWGA.txt
#SBATCH --error=error_outputWGA.txt
#SBATCH --job-name=mu
#SBATCH --qos=std

export PATH=$PATH:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/CNSpipeline:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/last-980/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/paper-zhang2014/Whole_genome_alignment/multiple/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/CNSpipeline/kentUtils/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/multiz
module load gcc
module load python
module load perl

#roast - T=. E=pig "((human mouse) (dog (horse (camel ((cattle killerwhale)(SCEB pig))))))" pig.mouse.sing.maf pig.horse.sing.maf pig.dog.sing.maf pig.human.sing.maf pig.cattle.sing.maf pig.killerwhale.sing.maf pig.camel.sing.maf pig.SCEB.sing.maf all.maf

sh ROAST_run.sh
