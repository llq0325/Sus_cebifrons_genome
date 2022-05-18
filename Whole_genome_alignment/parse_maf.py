#!/usr/bin/env/ python3
"""
Author: Langqing Liu


"""

from sys import argv
import subprocess
import os.path


def record_finder(maffile):
    curr=[]
    for line in maffile:
        if not line.strip():
            continue
        if line.startswith("a"):
            if curr:
                yield curr
            curr=[]
            curr.append(line.strip())
        else:
            curr.append(line.strip())
    if curr:
        yield curr

def parse_record(rec_lines):
    print("##maf version=1 scoring=last")
    for line in rec_lines:
        #print(line)
        #continue
        if len(line) < 3:
            continue
        if len(line[2].split(" ")) > 6 and abs(int(line[2].split(" ")[2])) < int(line[2].split(" ")[5]):
            #print(int(line[2].split(" ")[2]))
            #print(int(line[2].split(" ")[5]))
            #continue
            if line[2].split(" ")[2].startswith("-"):
                l = line[2].split(" ")[0:2]
                l.append(line[2].split(" ")[2].replace("-", ""))
                l1 = line[2].split("\n")[0].split(" ")[3:]
                print(line[0])
                print(line[1])
                print(*l, *l1,sep=" ")
                print("")
            else:
                print(*line, sep="\n")
                print("")


def maf_parser(maffile):
    maflist=[]
    for maf in maffile:
        if maf.startswith("s"):
            if not maf.split(" ")[1].startswith("pig"):
                if maf.split(" ")[2].startswith("-"):
                    l = maf.split(" ")[0:2]
                    l.append(maf.split(" ")[2].replace("-", ""))
                    l1 = maf.split("\n")[0].split(" ")[3:]
                    print(*l, *l1,sep=" ")
                else:
                    print(maf.split("\n")[0])
            else:
                print(maf.split("\n")[0])
        else:
            print(maf.split("\n")[0])


if __name__ == "__main__":
    maffile = open(argv[1])
    rec = record_finder(maffile)
    parse_record(rec)

