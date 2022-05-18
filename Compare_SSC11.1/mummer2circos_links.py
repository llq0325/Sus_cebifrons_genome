#!/usr/bin/env/ python3
"""
Author: Langqing Liu


"""
from sys import argv
import subprocess
import os.path



def record_finder(lines):
    """Return list of records separated by each read
    lines: open file or list of lines
    """
    record = []
    for line in lines:
        if not line.strip():
            continue
        if line.startswith(">"):
            CHR1 = line.split(" ")[0][1:]
            CHR2 = line.split(" ")[1]
            continue
        if len(line.split(" ")) == 7:
            START1 = line.split(" ")[0]
            END1 = line.split(" ")[1]
            START2 = line.split(" ")[2]
            END2 = line.split(" ")[3]
            record.append((CHR1,START1,END1,CHR2,START2,END2))
            continue
        else:
            pass
    return record

if __name__ == "__main__":
    # open the file
    mummer= open(argv[1])
    record = record_finder(mummer)
    #for i in record: print("{0} {1} {2} {3} {4} {5}".format(i[0],i[1],i[2],i[3],i[4],i[5]))
    for i in record: print("SSC{0} {1} {2} SCE{3} {4} {5}".format(i[0],i[1],i[2],i[3],i[4],i[5]))








    
