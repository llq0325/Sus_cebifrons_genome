import argparse
parser = argparse.ArgumentParser(description='gff modification for GAG annotator')
parser.add_argument("--infile", help="infile",type=str)
parser.add_argument("--out", help="outfile",type=str)
parser.add_argument("--annie", help="annie tsv file",type=str)
args = parser.parse_args()

infile = args.infile
outfile = args.out

annie_results = {}
#parse annie results
with open(args.annie) as f:
    for line in f:
	#print line
        gene, type, value = line.strip().split('\t')
        if gene not in annie_results:
            annie_results[gene] = {}
        if type not in annie_results[gene]:
            annie_results[gene][type] = value
        elif type in annie_results[gene]:
            if type == 'Dbxref':
                if 'mobidb' not in value:
                    annie_results[gene][type] += ','+value

#store in new gff
with open(infile) as f:
    with open(outfile, 'w') as f2:
        cdsnumber = 0
        currentparent = ''
        for line in f:
            if 'gene' in line:
                geneid = line.strip().split('=')[-1]
                try:
                    annotations = annie_results[geneid]
                    genename = annotations['name']
                    newline = line.strip()+';Name='+genename+'\n'
                except KeyError:
                    newline = line
                f2.write(newline)
            elif 'mRNA' in line:
                tag = line.strip().split()[-1]
                idtag = tag.split(';')[0]
                rnaid = idtag.split('=')[-1]
                try:
                    annotations = annie_results[rnaid]
                    newline = line.strip()
                    for elem in annotations:
                        newline += ';'+elem+'='+annotations[elem]
                    newline += '\n'
                except KeyError:
                    newline = line
                f2.write(newline)
            elif 'CDS' in line:
                parent = line.strip().split('=')[-1]
                if parent == currentparent:
                    cdsnumber += 1
                else:
                    cdsnumber = 0
                    currentparent = parent
                addtoline = 'ID='+parent+':cds:'+str(cdsnumber)
                newline = line.strip()+';'+addtoline+'\n'
                f2.write(newline)
                f2.write(newline.replace('CDS','exon').replace('cds','exon'))
            elif 'exon' in line:
                pass
            else:
                f2.write(line)