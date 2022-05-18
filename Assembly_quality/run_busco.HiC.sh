#!/bin/bash
#SBATCH --time=15-10:10:10
#SBATCH --mem=100000
#SBATCH --ntasks=30
#SBATCH --nodes=1
#SBATCH --output=outputBUSCO2.txt
#SBATCH --error=error_outputBUSCO2.txt
#SBATCH --job-name=BUSCO2
#SBATCH --partition=ABGC_Std


module load python

export PERL5LIB=/home/WUR/liu194/perl5/perlbrew/perls/perl-5.20.1/lib/perl5:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/pasa-2.3.3/PerlLib
export BUSCO_CONFIG_FILE="/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/busco/config/config.ini"
export PATH="/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/bin:$PATH"
export PATH="/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/scripts/:$PATH"
export AUGUSTUS_CONFIG_PATH="/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/config/"

python /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/busco/scripts/run_BUSCO.py -c 30 -i /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly/Hi-C/Sus_cebifrons.fasta -o HiC-long -l /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/busco/mammalia_odb9 -m geno -t ./tmp_DTG_501_10X_1400M.pseudohap2.2.fasta -sp human --long
