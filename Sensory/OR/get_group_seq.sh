sp=pig

#/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/cd-hit-v4.8.1-2019-0228/cd-hit -i ${sp}_all.fa -o ${sp}_group -c 0.6 -n 4

OR_list=`cat OR.list`

for OR in $OR_list;do

seq_list=`python get_group.py ${sp}_group.clstr OR$OR`

for seq in $seq_list;do

#echo $seq

python2 /lustre/nobackup/WUR/ABGC/liu194/analysis/Deepphylo/seqmagick/seqmagick.py convert --pattern-include "$seq" ${sp}_OR.fa tmp.fa

cat tmp.fa >> ./seq/${sp}_OR$OR.fa

done

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin/mafft --auto ./seq/${sp}_OR$OR.fa > ./seq/${sp}_OR$OR.fa.aln

python2 aa_diversity.py ${sp}_OR$OR.fa.aln

done
