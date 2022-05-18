#!/bin/bash
#SBATCH --time=30-10:00:00
#SBATCH --ntasks=5
#SBATCH --output=output_%j.txt
#SBATCH --error=error_output_%j.txt
#SBATCH --array=1-1586%10
#SBATCH --mem-per-cpu=6000
#SBATCH --job-name=ORfinder
#SBATCH --qos=std

export PERL5LIB=/home/WUR/liu194/perl5/perlbrew/perls/perl-5.20.1/lib/perl5:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/pasa-2.3.3/PerlLib
export FUNANNOTATE_DB=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota
export TRINITYHOME=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/trinityrnaseq
export BAMTOOLS_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin
export GENEMARK_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/gm_et_linux_64/gmes_petap
export PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/gm_et_linux_64/gmes_petap:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/pasa-2.3.3/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/scripts:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/ncbi-blast-2.9.0+-src/c++/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/blast-2.2.26/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology/augustus/homolog/common_bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/5.EVM/parafly-r2013-01-21/bin/bin:$PATH
export PASAHOME=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/pasa-2.3.3
export AUGUSTUS_CONFIG_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/config
module load R
module load samtools
module load bamtools
module load gcc
module load BLAST+


#runs_list=`cat CHR.list`
runs_list=`seq 1 1585`
runs=${runs_list[${SLURM_ARRAY_TASK_ID}]}


perl /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology/augustus/homolog/protein_map_genome_mod.pl --verbose --cpu 5 --run qsub --node 1 --lines 3 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology/augustus/homolog/pfam_olf.fix.stop.fa /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology/TEST/MT_annotation_BGI/test_data/CHR_fix/SCEB${SLURM_ARRAY_TASK_ID}.masked --align_rate 0.5 --outdir SCEB$SLURM_ARRAY_TASK_ID 
