#!/bin/bash
#SBATCH --time=20-10:10:10
#SBATCH --mem=150000
#SBATCH --ntasks=10
#SBATCH --nodes=2
#SBATCH --output=outputBRAKER_ab.txt
#SBATCH --error=error_outputBRAKER_ab.txt
#SBATCH --job-name=BRAKER
#SBATCH --qos=std

export PATH=$PATH:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin
export GENEMARK_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/gm_et_linux_64/gmes_petap/
export AUGUSTUS_CONFIG_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/config
export AUGUSTUS_BIN_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/bin
export AUGUSTUS_SCRIPTS_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/scripts
export GENEMARK_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/gm_et_linux_64/gmes_petap
export PERL5LIB=/home/WUR/liu194/perl5/perlbrew/perls/perl-5.20.1/lib/perl5
#export ALIGNMENT_TOOL_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin

module load bamtools
module load samtools
module load BLAST+/2.2.28
module load python
#module load perl


/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/scripts/braker.pl \
	    --species=human --useexisting \
		--genome=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_SCEB13/0.Repeat/SCEB.masked.fa \
		--prot_seq=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_SCEB13/4.BRAKER/pep_db/ref.1.stop.fasta \
		--softmasking --cores=10 \
		--prg=gth \
		--ALIGNMENT_TOOL_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/gth-1.7.1-Linux_x86_64-64bit/bin --gff3 \
		--trainFromGth
