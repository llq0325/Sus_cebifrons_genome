#!/bin/bash

if [ $# -lt 4 ];then
	echo "Usage: sh XX.sh genome.fa genewise genome.len out.id.list"
	exit
fi

genome=$1
genewise=$2
len=$3
list=$4
genewise_name=`basename $2`

perl /nas/GAG_02/liushiping/GACP/GACP-8.0/01.gene_finding/protein-map-genome/bin/gw2gffWithShift.pl $genewise $len > $genewise_name.gff3
perl /nas/GAG_02/liushiping/GACP/GACP-8.0/01.gene_finding/protein-map-genome/bin/filterShiftN.pl $genewise_name.gff3 $genome > $genewise_name.gff3.noShift
perl /nas/GAG_02/liushiping/GACP/GACP-8.0/01.gene_finding/protein-map-genome/bin/extendEnds.pl $genewise_name.gff3 $list $genome > $genewise_name.gff3.extend.gff 2> $genewise_name.gff3.log
