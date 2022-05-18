#!/usr/bin/env/ python3
"""
Author: Langqing Liu

add stop codon "*" to fasta

"""

from sys import argv
import os.path
import re

def add_stopcodon(fasta):
    for line in fasta:
        if line.startswith(">"):
            print(line.strip())
        else:
            print(line.strip() + "X")


if __name__ == "__main__":
    fasta = open(argv[1])
    add_stopcodon(fasta)
