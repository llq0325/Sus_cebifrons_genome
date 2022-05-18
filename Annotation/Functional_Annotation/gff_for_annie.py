import argparse
parser = argparse.ArgumentParser(description='gff modification for annie annotator')
parser.add_argument("--infile", help="infile",type=str)
parser.add_argument("--out", help="outfile",type=str)
args = parser.parse_args()

infile = args.infile
outfile = args.out

import re
with open(infile) as f:
    with open(outfile, 'w') as f2:
        for line in f:
            if 'mRNA' in line:
                subline0 = line.replace('mRNA', 'gene')
                subline1 = re.sub('.t\d','', subline0)
                subline2 = subline1.split(';geneID')[0]+'\n'
                subline3 = line.replace('geneID=','Parent=')
                f2.write(subline2)
                f2.write(subline3)
            else:
                f2.write(line)