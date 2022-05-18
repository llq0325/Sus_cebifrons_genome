#!/usr/bin/env/ python3
"""
Author: Langqing Liu

python fix_gff.py sus_cebifrons.gff > sus_cebifrons.gff.fix
cut-off region: 31031725-49835600
move -18803875

"""

from sys import argv
import os.path
import re
import subprocess

move_index = 18803875
start_pos = 31031725
end_pos = 49835600

def fix_gff(gff):
    for line in gff:
        if line.startswith("SCEB13\t"):
            if int(line.split("\t")[3]) <= start_pos:
                print(line.strip())
                continue
            if int(line.split("\t")[3]) > start_pos and int(line.split("\t")[4]) < end_pos:
                continue
            if int(line.split("\t")[3]) >= end_pos:
                new_start_pos = int(line.split("\t")[3]) - move_index
                new_end_pos = int(line.split("\t")[4]) - move_index
                new_line = []
                #new_line.append(line.split("\t")[0:2].append(str(new_start_pos)).append(str(new_end_pos)).append(line.split("\t")[5:]))
                new_line = "\t".join(line.split("\t")[0:3]) + "\t" + str(new_start_pos) + "\t" + str(new_end_pos) + "\t" + "\t".join(line.strip().split("\t")[5:])
                print(new_line)
                continue
        else:
            print(line.strip())


if __name__ == "__main__":
    gff = open(argv[1])
    fix_gff(gff)
