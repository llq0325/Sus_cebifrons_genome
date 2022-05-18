#!/bin/bash
#SBATCH --time=30-10:10:10
#SBATCH --mem=150000
#SBATCH --ntasks=30
#SBATCH --nodes=5
#SBATCH --output=outputFUN_p.txt
#SBATCH --error=error_outputFUN_p.txt
#SBATCH --job-name=homology_qs
#SBATCH --qos=std

#source ~/miniconda2/bin/activate /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota
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


#perl ./homology2.2.pl -g=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/0.Repeat/SCEB_ragoo.fa.masked -p=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology/REF_PEP -t=30

#perl protein_map_genome_mod.pl --step 2 --cpu 30 --run qsub --node 5 --lines 3 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology/REF_PEP/ref_pep.30_5000.fa /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/0.Repeat/SCEB_ragoo.fa.masked


#perl protein_map_genome_mod.pl --cpu 30 --run qsub --node 5 --lines 3 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology/REF_PEP/pfam_olf.fa /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/0.Repeat/SCEB_ragoo.fa.masked


perl protein_map_genome_mod.pl --verbose --cpu 2 --run qsub --node 1 --lines 3 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology/augustus/homolog/pfam_olf.star.fa SCEB20.masked --align_rate 0.5
