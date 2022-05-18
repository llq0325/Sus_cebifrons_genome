#!/bin/bash
#SBATCH --time=2-10:10:10
#SBATCH --mem=10000
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --output=outputRELAX.txt
#SBATCH --error=error_outRELAX.txt
#SBATCH --job-name=RELAX
#SBATCH --qos=std

module load RAxML/gcc/64/8.2.9

seqlist=`cat seq.list`

for seq in $seqlist;do

java -jar /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/macse_v2.03.jar -prog alignSequences -seq Seq/${seq}.aln.noG -out_NT Seq/${seq}.aln 
#sed -i 's/\!/\-/g' Seq/${seq}.aln

#trim stop codon
(echo 8; echo 10; echo 1; echo Seq/${seq}.aln; echo 5; echo Seq/${seq}.clean;) | ../../../bin/miniconda3/bin/hyphy

python make_inputtree_SCEB.py  tree/${seq}.tre > input_tree_SCEB/${seq}.tre
python make_inputtree_pig.py  tree/${seq}.tre > input_tree_pig/${seq}.tre


#run hyphy RELAX

(echo 1; echo 7; echo Seq/${seq}.clean; echo input_tree_SCEB/${seq}.tre; echo 2;) | ~/miniconda3/bin/hyphy > ${seq}.SCEB.output
(echo 1; echo 7; echo Seq/${seq}.clean; echo input_tree_pig/${seq}.tre; echo 2;) | ~/miniconda3/bin/hyphy > ${seq}.pig.output

done

