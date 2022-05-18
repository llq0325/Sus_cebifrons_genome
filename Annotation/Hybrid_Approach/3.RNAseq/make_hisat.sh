LIST=`cat list.txt`
for i in $LIST;do
	echo $i
	FW=`ls /lustre/nobackup/WUR/ABGC/shared/Pig/Scebi_RNAseq/${i}/*1.fq.gz`
    BW=`ls /lustre/nobackup/WUR/ABGC/shared/Pig/Scebi_RNAseq/${i}/*2.fq.gz`	
	echo "#!/bin/bash
#SBATCH --time=4-10:10:10
#SBATCH --mem=20000
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --output=output${i}.txt
#SBATCH --error=error_output${i}.txt
#SBATCH --job-name=${i}
#SBATCH --partition=ABGC_Std

module load samtools

#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/hisat2-2.1.0/hisat2-build /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/assembly/DTG_501_10X_1400M.pseudohap2.2.fasta.rehead SCEB_index

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/hisat2-2.1.0/hisat2 -x SCEB_index -p 8 -1 $FW -2 $BW  | samtools view -S - -b > ${i}.bam

samtools sort -o ${i}_sorted.bam ${i}.bam

samtools index ${i}_sorted.bam" > ${i}.sh

sbatch ${i}.sh

done


