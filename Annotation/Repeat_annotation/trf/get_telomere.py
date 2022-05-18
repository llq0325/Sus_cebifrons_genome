#!/usr/bin/env/ python3
"""
Author: Langqing Liu


"""

from sys import argv
import os.path
import re


def get_telomere(trffile):
    for line in trffile:
        if line.startswith("Sequence:"):
            CHR=line.strip().split(" ")[1]
        if re.match("^[0-9]+", line):
            #print(line)
            #TTAGGG CCCTAA
            START=line.strip().split(" ")[0]
            END=line.strip().split(" ")[1]
            SEQ="".join(line.strip().split(" ")[13:])
            #no overlapping
            TEL_1=SEQ.count("TTAGGG")
            TEL_2=SEQ.count("CCCTAA")
            NUM_TEL = TEL_1 + TEL_2
            #overlaopping
            #len(re.findall('(?=TTAGGG)', SEQ))
            print("\t".join((CHR,START,END,str(NUM_TEL))))


if __name__ == "__main__":
    trffile = open(argv[1])
    #length = get_seq_len(seqfile)
    get_telomere(trffile)
