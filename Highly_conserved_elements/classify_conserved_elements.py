# -*- coding: utf-8 -*-
"""
Created on Thu Aug  1 09:18:48 2019

@author: kruis015
"""

gff = '10.gff3'
elements = '10.bed'
output = 'CNE_categories.tsv'
contiglist = 'contigs.txt'

exonic = {}
genic = {}
promotor_region = {}

with open(contiglist) as f: #make empty sets for each scaffold
    for line in f:
        currentscaf = line.strip()
        exonic[currentscaf] = set()
        genic[currentscaf] = set()
        promotor_region[currentscaf] = set()

with open(gff) as f: #store genic regions in these sets
    for line in f:
        if line[0] != '#':
            scaf, source, type1, start, end, dot1, strand, dot2, tag = line.strip().split('\t')
            if type1 == 'gene':
                genic[scaf].update(range(int(start), int(end)))
                if strand == '+':
                    promotor_region[scaf].update(range(int(start)-2000, int(start)))
                elif strand == '-':
                    promotor_region[scaf].update(range(int(end), int(end)+2000))
            elif type1 == 'exon':
                exonic[scaf].update(range(int(start), int(end)))

counter_exonic = 0
counter_intronic = 0
counter_promotor = 0
counter_intergenic = 0    
            
with open(elements) as f:
    with open(output, 'w') as f2:
        for line in f:
            scaf, start, end, name, x, y = line.strip().split()
            currentrange = set(range(int(start), int(end)))
            if len(exonic[scaf] & currentrange) > 0:
                f2.write(name+'\texonic\n')
                counter_exonic += 1
            elif len(genic[scaf] & currentrange) > 0:
                f2.write(name+'\tintronic\n')
                counter_intronic += 1
            elif len(promotor_region[scaf] & currentrange) > 0:
                f2.write(name+'\tpromotor_region\n')
                counter_promotor += 1
            else:
                f2.write(name+'\tintergenic\n')
                counter_intergenic += 1

print(counter_exonic, counter_intronic, counter_promotor, counter_intergenic)
