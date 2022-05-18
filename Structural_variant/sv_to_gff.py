#!/usr/bin/env/ python3
"""
Author: Langqing Liu

useage: python sv_to_gff.py sv.txt pig.gff3 INV 100
sv_type : CNV-R nCNV-R CNV-Q nCNV-Q INV
"""

from sys import argv
import os.path
import re
import sys
import subprocess

def sv_to_gff(svfile,gfffile,sv_type,sv_length):
    if sv_type == "CNV-R":
        sv_type_list = ["CNV-R","CNV-NR"]
    if sv_type == "CNV-Q":
        sv_type_list = ["CNV-Q","CNV-NQ"]
    if sv_type == "nCNV-R":
        sv_type_list = ["nCNV-R","nCNV-NR"]
    if sv_type == "nCNV-Q":
        sv_type_list = ["nCNV-Q","nCNV-NQ"]
    if sv_type == "INV":
        sv_type_list = ["INV"]
    f = open(sv_type + ".bed","w")
    for line in svfile:
        record_type = line.strip().split("\t")[3]
        record_length = line.strip().split("\t")[8]
        if (record_type in sv_type_list) and (int(record_length) >= int(sv_length)):
            #print(line)
            CHR = line.strip().split("\t")[0]
            START = line.strip().split("\t")[1]
            END = line.strip().split("\t")[2]
            #print("\t".join([CHR,START,END]))
            f.write("\t".join([CHR,START,END]))
            f.write("\n")
    f.close()
    cmd = "bedtools intersect -a pig.gff3 -b " + sv_type + ".bed | grep -P \"\\tgene\\t\" > " + sv_type + ".gff3"
    print(cmd)
    run_cmd = subprocess.check_output(cmd, shell=True)
    cmd2 = "cut -f2 -d\":\" " + sv_type + ".gff3 | cut -f1 -d\";\" | sort -u > " + sv_type + ".gene.txt"
    print(cmd2)
    run_cmd2 = subprocess.check_output(cmd2, shell=True)
            
if __name__ == "__main__":
    svfile = open(argv[1])
    gfffile = open(argv[2])
    sv_type = argv[3]
    sv_length = argv[4]
    sv_to_gff(svfile,gfffile,sv_type,sv_length)
