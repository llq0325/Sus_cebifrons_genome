#!/bin/bash
#SBATCH --time=25-10:10:10
#SBATCH --mem-per-cpu=10000
#SBATCH --ntasks=20
#SBATCH --nodes=5
#SBATCH --output=outputBRAKER_HiC.txt
#SBATCH --error=error_outputBRAKER_HiC.txt
#SBATCH --job-name=short
#SBATCH --qos=std


export GENEMARK_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/test/gm_et_linux_64
export AUGUSTUS_CONFIG_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/config
export AUGUSTUS_BIN_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/bin
export AUGUSTUS_SCRIPTS_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/scripts:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/scripts:$AUGUSTUS_SCRIPTS_PATH
export PERL5LIB=/home/WUR/liu194/perl5/perlbrew/perls/perl-5.20.1/lib/perl5
export PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/scripts:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/gth-1.7.1-Linux_x86_64-64bit/bin:$PATH
#export ALIGNMENT_TOOL_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/gth-1.7.1-Linux_x86_64-64bit/bin
PARAFLY=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach/5.EVM/parafly-r2013-01-21/bin

module load bamtools
module load samtools
module load BLAST+/2.2.28
module load python/3.7.1
module load perl


/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/scripts/braker.pl --species=sus_cebifrons_hic_sceb --useexisting \
	--genome=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach/0.Repeat/SCEB.masked.fa  \
     --prot_aln=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach/4.BRAKER/gth.ALL.gff3 \
			--softmasking --cores=10 \
                   --gff3 \
        --prg=gth \
        --trainFromGth
			--gff3

#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/scripts/braker.pl --species=human --useexisting \
#	--genome=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/0.Repeat/SCEB_ragoo.fa.masked  \
#     --hints=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/4.BRAKER/gth_output/hints.fixstop.gff \
#			--softmasking --cores=30 \
#                   --gff3



