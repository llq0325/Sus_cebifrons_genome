CHRlist=`cat CHR.list`
module load gcc
for CHR in $CHRlist;do

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology/TEST/MT_annotation_BGI/blast/formatdb -i /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/2.homology/TEST/MT_annotation_BGI/test_data/CHR_fix/$CHR -p F -o T

done
