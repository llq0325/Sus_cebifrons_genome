



SPECIES_list=`cat SPECIES_list.txt`

for SPECIES in $SPECIES_list;do

echo "#!/bin/bash
#SBATCH --time=20-10:10:10
#SBATCH --mem=150000
#SBATCH --ntasks=20
#SBATCH --nodes=1
#SBATCH --output=outputWGA.txt
#SBATCH --error=error_outputWGA.txt
#SBATCH --job-name=mu
#SBATCH --qos=std

export PATH=\$PATH:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/last-980/bin
module load gcc
module load python
module load perl

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/mummer-4.0.0beta2/nucmer -t 20 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Genome_Compare/Genome_ensembl/ENSEMBL_sm/human.sm.fa /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Genome_Compare/Genome_ensembl/ENSEMBL_sm/${SPECIES}.sm.id.fa -p ${SPECIES}

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/mummer-4.0.0beta2/delta-filter -1 ${SPECIES}.delta > ${SPECIES}.filter

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/MUMmer3.20/src/tigr/delta2maf ${SPECIES}.filter > ${SPECIES}.maf

#./delta2maf ${SPECIES}.filter > ${SPECIES}.maf

perl rename.pl ${SPECIES}.maf ${SPECIES} > ${SPECIES}.n.maf

"> ${SPECIES}.sh

sbatch ${SPECIES}.sh


done
