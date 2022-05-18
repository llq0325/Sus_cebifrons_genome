#!/bin/bash
#SBATCH --time=16-10:10:10
#SBATCH --mem=150000
#SBATCH --ntasks=50
#SBATCH --nodes=5
#SBATCH --output=outputFUN_H.txt
#SBATCH --error=error_outputFUN_H.txt
#SBATCH --job-name=FUN_H
#SBATCH --qos=std

source ~/miniconda2/bin/activate /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota
export PERL5LIB=/home/WUR/liu194/perl5/perlbrew/perls/perl-5.20.1/lib/perl5:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/pasa-2.3.3/PerlLib
export FUNANNOTATE_DB=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota
export TRINITYHOME=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/trinityrnaseq
export BAMTOOLS_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin
export GENEMARK_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/gm_et_linux_64/gmes_petap
export PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/gm_et_linux_64/gmes_petap:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/pasa-2.3.3/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/scripts:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin:$PATH
export PASAHOME=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/pasa-2.3.3
export AUGUSTUS_CONFIG_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/config
module load R
module load samtools
module load bamtools
module load gcc

python /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/funannotate/bin/funannotate-p2g.py.2 -p prothint_stopcodon.fa -g /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/0.Repeat/SCEB_ragoo.fa.masked --maxintron 50000 --cpus 50 --out test1015 -t tblastn_out_new -f tblastn
