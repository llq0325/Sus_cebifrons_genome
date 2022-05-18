#!/usr/bin/env/ python3
from __future__ import division
"""
Author: Langqing Liu

python extract_fasta.py Olfactory pig_OR.fasta > pig_OR.filter.fasta

"""

from sys import argv
import os.path
import re


def extract_region(paf):
    for line in paf:
        CHR = line.split("\t")[5]
        START = line.split("\t")[7]
        END = line.split("\t")[8]
        MATCH = line.split("\t")[9]
        LEN = line.split("\t")[10]
        SCORE = line.split("\t")[11]
        if int(MATCH)/int(LEN) > -0.1 and int(SCORE) > 0:
            print("\t".join([CHR,START,END]))


if __name__ == "__main__":
    paf = open(argv[1])
    extract_region(paf)
