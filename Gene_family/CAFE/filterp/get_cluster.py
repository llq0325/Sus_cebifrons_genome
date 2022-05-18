#!/usr/bin/env/ python3
"""
Author: Langqing Liu


"""

from sys import argv
import os.path
import re

def get_cluster(fams_file):
    for line in fams_file:
        if line.startswith("pig"):
            fams = line.strip().split("\t")[1].split(",")
            break
    Exp = []
    Con = []
    for i in fams:
        fams_id = i.split("[")[0]
        stat = i.split("[")[1].split("*")[0]
        if int(stat) > 0:
            Exp.append([fams_id,stat])
        else:
            Con.append([fams_id,stat])
    f = open("SSC.expansion.txt","w")
    for i in Exp:
        f.write("\t".join(i))
        f.write("\n")
    f.close()
    f = open("SSC.contraction.txt","w")
    for i in Con:
        f.write("\t".join(i))
        f.write("\n")
    f.close()
    



if __name__ == "__main__":
    fams_file = open(argv[1])
    #length = get_seq_len(seqfile)
    get_cluster(fams_file)
