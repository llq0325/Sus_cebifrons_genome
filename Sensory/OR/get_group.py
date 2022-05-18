#!/usr/bin/env/ python3
"""
Author: Langqing Liu

python get_group.py pig_group.clstr OR51 > pig_OR.filter.fasta

"""

from sys import argv
import os.path
import re

def get_group(cluster,OR):
    OR_group = []
    tmp_group = []
    OR_in_tmp = 0
    for line in cluster:
        if line.startswith(">"):
            if len(tmp_group)!=0 and OR_in_tmp==1:
                for i in tmp_group:
                    OR_group.append(i)
                tmp_group = []
                OR_in_tmp = 0
                continue
            else:
                tmp_group = []
                OR_in_tmp = 0
                continue
        seq = line.split(">")[1].split("...")[0]
        if re.match(OR+"[A-Z]", seq):
            #print(seq)
            OR_in_tmp = 1
            continue
        tmp_group.append(seq)
    if tmp_group and OR_in_tmp==1:
        for i in tmp_group:
            OR_group.append(i)
    for i in OR_group:
        print(i)
            
                

if __name__ == "__main__":
    cluster = open(argv[1])
    OR = argv[2]
    get_group(cluster,OR)
