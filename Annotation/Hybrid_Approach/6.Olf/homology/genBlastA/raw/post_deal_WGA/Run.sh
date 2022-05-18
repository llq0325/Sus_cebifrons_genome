#!/bash/sh

if [ $# -lt 6 ];then
	echo "sh $0 <Synteny.gff> <genewise.gff> <genomics.fa> <support.list> <.nr.net2tab> <Synteny.out>"
	exit
fi

Bin="/nas/GAG_02/liushiping/GACP/GACP-8.0/01.gene_finding/protein-map-genome/bin/post_deal_WGA"

ln -s $6 Synteny.out
ln -s $1 Synteny.out.attr.gff
ln -s $2 genewise.gff

perl $Bin/getAttribute.pl Synteny.out > Synteny.out.attr 
perl $Bin/layOpenLow.pl Synteny.out.attr > Synteny.out.attr.LO
perl /home/liushiping/ifs1/bin/clustergff.pl.new.pl Synteny.out.attr.gff multi 100 5
perl /home/liushiping/ifs1/bin/filter_gff_percent-lenght.pl Synteny.out.attr.gff.nr.gff 50 > Synteny.out.attr.gff.nr.gff.tmp
mv Synteny.out.attr.gff.nr.gff.tmp Synteny.out.attr.gff.nr.gff
perl /home/liushiping/ifs1/bin/fishInWinter.pl -bf gff -ff gff -except Synteny.out.attr.gff genewise.gff >unSynteny.out.attr.gff
less unSynteny.out.attr.gff|grep mRNA|awk '$6 >= 70'|perl -ne 'if(/ID=([^;\s]+)/){print "$1\n"}' > unSynteny.out.attr.over70.list
perl /home/liushiping/ifs1/bin/fishInWinter.pl -ff gff unSynteny.out.attr.over70.list unSynteny.out.attr.gff > unSynteny.out.attr.over70.gff
perl $Bin/FindOverlapWithEvidences.pl --length 100 --glean Synteny.out.attr.gff.nr.gff --homolog unSynteny.out.attr.over70.gff
perl /home/liushiping/ifs1/bin/fishInWinter.pl -bc 2 -ff gff -except Synteny.out.attr.gff.nr.gff_len100.list unSynteny.out.attr.over70.gff > unSynteny.out.attr.over70.pure.gff
perl /home/liushiping/ifs1/bin/clustergff.pl.new.pl unSynteny.out.attr.over70.pure.gff multi 100 3
perl /home/liushiping/ifs1/bin/fastaDeal.pl -attr id:len $3 >PENlavD.scafSeq.fa.len
perl $Bin/find_ends.pl Synteny.out.attr.LO Synteny.out.attr.gff PENlavD.scafSeq.fa.len > Synteny.out.attr.gff.end
perl $Bin/build_gs.pl $4 Synteny.out.attr.gff.end > Synteny.out.attr.gff.end.gs
perl $Bin/fish_gs.pl Synteny.out.attr.gff.end.gs ./genewise.gff > Synteny.out.attr.gff.end.gs.gff
cat unSynteny.out.attr.over70.pure.gff.nr.gff Synteny.out.attr.gff.nr.gff > Synteny.unSynteny.nr.gff
perl /home/liushiping/ifs1/bin/getGene.pl Synteny.unSynteny.nr.gff $3 > Synteny.unSynteny.nr.cds
perl $Bin/xls.pl PENlavD.scafSeq.fa.len $5 Synteny.unSynteny.nr.gff Synteny.out.attr.gff.end.gs Synteny.unSynteny.nr.cds ./genewise.gff Synteny.out.attr.LO > xls.70.out
cat Synteny.out.attr.gff unSynteny.out.attr.over70.gff >all.gff
perl $Bin/pseudo4.pl all.gff xls.70.out 2 1 > NonWGA.single.pseudo
perl $Bin/pseudo4.pl all.gff xls.70.out 3 0 > NonWGA.multi.pseudo
perl $Bin/pseudo3.pl all.gff xls.70.out 2 1 > WGA.single.pseudo
perl $Bin/pseudo3.pl all.gff xls.70.out 8 0 > WGA.multi.pseudo
cat *pseudo > All.pseudo
