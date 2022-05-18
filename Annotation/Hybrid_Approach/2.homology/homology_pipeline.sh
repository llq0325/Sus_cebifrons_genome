#!/bin/bash
#SBATCH --time=6-10:10:10
#SBATCH --mem=100000
#SBATCH --ntasks=20
#SBATCH --nodes=1
#SBATCH --output=outputFUN_p.txt
#SBATCH --error=error_outputFUN_p.txt
#SBATCH --job-name=FUN_P
#SBATCH --qos=std

#source ~/miniconda2/bin/activate /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota
export PERL5LIB=/home/WUR/liu194/perl5/perlbrew/perls/perl-5.20.1/lib/perl5:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/pasa-2.3.3/PerlLib
export FUNANNOTATE_DB=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota
export TRINITYHOME=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/trinityrnaseq
export BAMTOOLS_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin
export GENEMARK_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/gm_et_linux_64/gmes_petap
export PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/gm_et_linux_64/gmes_petap:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/pasa-2.3.3/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/scripts:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/ncbi-blast-2.9.0+-src/c++/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology:$PATH
export PASAHOME=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/pasa-2.3.3
export AUGUSTUS_CONFIG_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/config
module load R
module load samtools
module load bamtools
module load gcc
module load BLAST+

#python /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/funannotate/bin/funannotate-p2g.py -p prothint.fa -g /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/0.Repeat/SCEB_ragoo.fa.masked --maxintron 500000 --cpus 20 --out test

#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/blast-2.2.26/bin/blastall -F F -m 8 -p tblastn -e 1e-05 -d genome.fa -i ref_pep.fa -o blastall.out

#perl solar.pl -a prot2genome2 -z -f m8 blastall.out > blast.solar

#./genewise -trev -sum -genesf -gff ref.gene.pep genome.gene.fasta > 1.blast.solar.genewise

#perl gw2gff.pl 1.blast.solar.genewise pep.len > 1.blast.solar.genewise.gff


perl ./homology2.2.pl -g=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/0.Repeat/SCEB_ragoo.fa.masked -p=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology/REF_PEP/ -t=20
