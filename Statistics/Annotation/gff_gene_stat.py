"""
gff_gene_stat.py

author: Drew Schield

Script that parses .gff3 input to output various gene, exon, and intron statistics.
Relates exons to their respective transcripts to calculate number of exons per gene (transcript), number of introns per gene (# exons - 1), and lengths of exons and introns per gene.

NOTE: Does not currently distinguish between annotations on the (+/-) strands (i.e., intron lengths per gene will not be any different in either direction).

usage: python gff_gene_stat.py <input.gff> <gene_out.txt> <exon_out.txt> 
"""

import sys

#Keep running total of number of genes in GFF
gene_count = 0
transcript_count = 0
exon_count = 0

transcript_match = 0
#Keep list of gene IDs in GFF
# genes = [] #may not need this, mRNA ID list may be better since exons correspond to these.

transcripts = [] #keep list of mRNA transcripts that exons will correspond to
exons = []

#Open output files
gene_table=open(sys.argv[2], 'w')
gene_table.write('Gene.Id'+'\t'+'Gene.Length'+'\n')
exon_table=open(sys.argv[3], 'w')
exon_table.write('Gene.Id'+'\t'+'Exon.Length'+'\n')
intron_table=open(sys.argv[4], 'w')
intron_table.write('Intron.Id'+'\t'+'Intron.Length'+'\n')
pergene=open(sys.argv[5], 'w')
pergene.write('Transcript.Id'+'\t'+'Number.Exons'+'\t'+'Number.Introns'+'\n')

#Read in GFF file and process
for line in open(sys.argv[1], 'r'):
	#quantify gene entries and log gene IDs in list
	if line.split('\t')[2]=='gene':  #may need to add 'ncRNA_gene' to this line for Ensembl annotations (these have same format in ID field as 'genes'): or line.split('\t')[2]=='ncRNA_gene:'
		gstart = line.split()[3]
		gend = line.split()[4]
		glength = int(gend) - int(gstart)
		
		if 'GeneID' in line.split('\t')[8]:
			gid = line.split('\t')[8]
			gid = gid.split('GeneID:')[1]
			gid = gid.split(';')[0]
		else:
			gid = line.split('\t')[8]
			gid = gid.split('gene_id=')[1]
			gid = gid.split(';')[0]
		
		gene_table.write(gid+'\t'+str(glength)+'\n')
# 		genes.append(gid)
		gene_count = gene_count+1

#ADD mRNA section to parse and make list of mRNA IDs, as these correspond to exon parent transcript IDs!! Will need to add lnc_RNA list as well, since ncRNA_gene exons correspond to these.

#Thamnophis 'mRNA' entry format:
#NW_013657680.1	Gnomon	mRNA	49591	69103	.	-	.	ID=rna0;Parent=gene0;Dbxref=GeneID:106542050,Genbank:XM_014058045.1;Name=XM_014058045.1;gbkey=mRNA;gene=THBS1;product=thrombospondin 1;transcript_id=XM_014058045.1

#Ensembl 'mRNA' entry format:
#1	ensembl	mRNA	77380	183510	.	-	.	ID=transcript:ENSACAT00000009589;Parent=gene:ENSACAG00000009394;Name=JAG2-201;biotype=protein_coding;transcript_id=ENSACAT00000009589;version=3

	if line.split('\t')[2]=='mRNA':
		tstart = line.split()[3]
		tend = line.split()[4]
		if 'GeneID' in line.split('\t')[8]:
			tid = line.split('\t')[8]
			tid = tid.split('transcript_id=')[1]
			tid = tid.split('\n')[0]
		else:
			tid = line.split('\t')[8]
			tid = tid.split('transcript_id=')[1]
			tid = tid.split(';')[0]
		
		transcript = tid+';'+tstart+';'+tend
		
		transcript_count = transcript_count+1
		transcripts.append(transcript)
		
#Thamnophis 'exon' entry format:
#NW_013657680.1	Gnomon	exon	49591	51782	.	-	.	ID=id22;Parent=rna0;Dbxref=GeneID:106542050,Genbank:XM_014058045.1;gbkey=mRNA;gene=THBS1;product=thrombospondin 1;transcript_id=XM_014058045.1

#Ensembl (Anolis) 'exon' entry format:
#1	ensembl	exon	44897	45263	.	-	.	Parent=transcript:ENSACAT00000031797;Name=ENSACAEE00000242762;constitutive=1;ensembl_end_phase=-1;ensembl_phase=-1;exon_id=ENSACAEE00000242762;rank=2;version=1

	if line.split('\t')[2]=='exon':
		estart = line.split()[3]
		eend = line.split()[4]
		elength = int(eend) - int(estart)
		
		if 'GeneID' in line.split('\t')[8]:
			eid = line.split('\t')[8]
			if 'transcript_id=' in eid:
				eid = eid.split('transcript_id=')[1]
# 				if '\n' in eid:
				eid = eid.split('\n')[0]
# 				else:
# 					eid = eid
# 				if ';' in eid:	#some exon entries in Thamnophis are separated by ';' instead of ','
# 					eid = eid.split(';')[0]
			else:
				eid = eid.split('ID=')[1]
				eid = eid.split(';')[0] 
		else:
			eid = line.split('\t')[8]
			eid = eid.split('Parent=transcript:')[1]
			eid = eid.split(';')[0]
		
		exon = eid+';'+estart+';'+eend
		exons.append(exon)
		
		exon_table.write(eid+'\t'+str(elength)+'\n')
		exon_count = exon_count+1


#Report totals to terminal	
print 'number of transcripts=',transcript_count
# print 'number of exons matching transcripts=',transcript_match
print 'Number of genes in GFF =',gene_count
print 'Number of exons in GFF =',exon_count

#Get per gene(transcript) numbers of exons & introns, and output intron length distribution
for transcript in transcripts:
	exon_count = 0
	intron_count = 0
	
	for exon in exons:
		if exon.split(';')[0]==transcript.split(';')[0]:
			exon_count = exon_count+1
			intron_count = exon_count-1

			if exon_count > 1:
				intlen = int(exon.split(';')[1]) - prevend
				intron = str(transcript.split(';')[0])+'_intron_'+str(intron_count)
				intron_table.write(intron+'\t'+str(intlen)+'\n')
# 	print transcript,'\t','exons=',exon_count,'\t','introns=',intron_count
				
			prevend = int(exon.split(';')[2])
			
	pergene.write(transcript.split(';')[0]+'\t'+str(exon_count)+'\t'+str(intron_count)+'\n')























































