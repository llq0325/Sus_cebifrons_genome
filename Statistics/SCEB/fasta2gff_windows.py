#!/usr/bin/python

'''
This program builds 100Kb gff features of windows accross the genome
'''


#-----------------------------------------------------
# Step 1
# Import variables & load input files
#-----------------------------------------------------

import sys
import argparse
import re
import numpy
from sets import Set
from Bio import SeqIO

ap = argparse.ArgumentParser()
ap.add_argument('--genome',required=True,type=str,help='Assembly file')
ap.add_argument('--size',required=False,default=100,type=int,help='Size of windows in Kb')
conf = ap.parse_args()


#-----------------------------------------------------
# Step 2
# Identify the length and gene density of FoL chromosomes
#-----------------------------------------------------

size_kb = str(conf.size)
interval_sz = (conf.size * 1000)
genome_file = open(conf.genome, 'r')
for cur_record in SeqIO.parse(genome_file,"fasta"):
    seq_id = cur_record.id
    seq_len = len(cur_record.seq)
    i = 1
    interval_start = 1
    interval_stop = interval_sz
    while interval_stop <= seq_len:
        outline = "\t".join([str(seq_id), "window", size_kb + "Kb_window", str(interval_start), str(interval_stop), ".", "+", ".", "ID=" + str(seq_id) + "_" + str(i) + ";"])
        print(outline)
        i += 1
        interval_start += interval_sz
        interval_stop += interval_sz
    outline = "\t".join([str(seq_id), "window", size_kb + "Kb_window", str(interval_start), str(seq_len), ".", "+", ".", "ID=" + str(seq_id) + "_" + str(i) + ";"])
    print(outline)
