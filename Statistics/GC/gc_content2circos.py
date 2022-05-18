#!/usr/bin/python

'''
This program is used to determine gc content in fasta files at intervals
specified in an input gff file. Output is in circos plot format.
'''


#-----------------------------------------------------
# Step 1
# Import variables & load input files
#-----------------------------------------------------

import sys
import argparse
import numpy as np
import gffutils
from gffutils.iterators import DataIterator

ap = argparse.ArgumentParser()
ap.add_argument('--genome',required=True,type=str,help='The genome assembly')
ap.add_argument('--gff',required=True,type=str,help='A gff file containing intervals within which gc content can be determined.')

conf = ap.parse_args()

#-----------------------------------------------------
# Step 2
# Identify the gc content of features in the gff file
#-----------------------------------------------------

genome_file = conf.genome
gff_file = conf.gff

print ("chr,start,end,value1")

for feature in DataIterator(gff_file):
    contig_id = str(feature.seqid)
    feat_start = str(feature.start)
    feat_stop = str(feature.stop)
    sequence = feature.sequence(genome_file)

    g_count = sequence.count('G')
    c_count = sequence.count('C')
    n_count = sequence.count('N')
    gc_count = float(g_count + c_count)
    seq_len = int(len(sequence) - n_count)
    gc_frac = np.divide(gc_count, seq_len)

    gc_perc = int(np.round_(np.multiply(gc_frac, 100), decimals=0,out=None))
    outline = [contig_id, feat_start, feat_stop, str(gc_perc)]
    print (",".join(outline))
