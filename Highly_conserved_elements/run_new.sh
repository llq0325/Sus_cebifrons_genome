#!/bin/bash
#SBATCH --time=16-10:10:10
#SBATCH --mem=10001
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --output=outputCNE.txt
#SBATCH --error=error_outputCNE.txt
#SBATCH --job-name=CNE
#SBATCH --qos=std

#./bin/msa_view all.sort.maf --refseq /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Genome_Compare/Genome_ensembl/human.fa --in-format MAF --4d --features human.ID.chr1.gff3> 4d.SCEB.7seq

#./bin/msa_view 4d.SCEB.7seq \
#--in-format SS --out-format SS --tuple-size 1 > 4d.SCEB.7seq.ss

#./bin/phyloFit --tree "(((dog,horse),((pig,SCEB),cattle)),(human,mouse));" -i SS 4d.SCEB.7seq.ss --out-root 4d.nonconserved

#./bin/msa_view all.sort.maf --in-format MAF --condons --features human.ID.chr1.CDS.gff3> 4d.SCEB.7seq.con

#./bin/msa_view 4d.SCEB.7seq.con --in-format SS --out-format SS --tuple-size 1 > 4d.SCEB.7seq.con.ss

#./bin/phyloFit --tree "(((dog,horse),((pig,SCEB),cattle)),(human,mouse));" -i SS 4d.SCEB.7seq.con.ss --out-root 4d.conserved

#./bin/phyloBoot --read-mods 4d.conserved.0.mod,4d.conserved.1.mod,4d.conserved.2.mod --output-average 4d.conserved.mod

#./bin/phastCons --estimate-rho 4d.SCEB.7seq.con.ss --no-post-probs 4d.SCEB.7seq.con.ss 4d.nonconserved.mod



filename="human.fa.tsizes"
while read -r line
do
	name=$(echo $line | cut -f1 -d' ')
	length=$(echo $line | cut -f2 -d' ')
	/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/last-980/bin/maf-cut human.${name}:1-${length} all.sort.maf > ${name}.maf
	./bin/phastCons \
	--target-coverage 0.9 --expected-length 15 \
	--rho 0.9 \
	--msa-format MAF --most-conserved ${name}.bed ${name}.maf 4d.SCEB.7seq.con.ss.cons.mod,4d.SCEB.7seq.con.ss.noncons.mod > ${name}.wig
	cat ${name}.bed >> all.bed
	cat ${name}.wig >> all.wig
	rm ${name}.bed
	rm ${name}.wig
	rm ${name}.maf
done < "$filename"


