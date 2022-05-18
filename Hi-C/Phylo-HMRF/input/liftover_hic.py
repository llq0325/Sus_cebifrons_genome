#!/usr/bin/env/ python3
"""
Author: Langqing Liu
"""

from sys import argv
import os.path
import re
import sys
import subprocess

index=range(0,289960557,50000)

def liftover_hic(liftover, hic):
    liftovered = {}
    for line in liftover:
        CHR,POS,END,HIC_POS = line.strip().split("\t")
        dis = 10000000
        for i in index:
            if dis > abs(int(POS) - i):
                dis = abs(int(POS) - i)
                POS_liftovered = i
        if POS_liftovered:
            liftovered[HIC_POS] = [POS_liftovered, CHR]
    #print(liftovered)
    for line1 in hic:
        SCEB_chr,start,start_e,SCEB_chr_e,end,end_e,interaction = line1.strip().split("\t")
        try:
            start_liftovered = liftovered[start][0]
            end_liftovered = liftovered[end][0]
            CHR_liftovered = liftovered[start][1]
            #list1=[CHR_liftovered,start_liftovered,end_liftovered,interaction]
            #print(" ".join(list1))
            #print(CHR_liftovered,start_liftovered,end_liftovered,interaction)
            #print("\t".join([str(CHR_liftovered),str(start_liftovered),str(end_liftovered),str(interaction)]))
            print("{0}\t{1}\t{2}\t{3}".format(CHR_liftovered,start_liftovered,end_liftovered,interaction))
        except:
            pass



if __name__ == "__main__":
    hic = open(argv[1])
    liftover = open(argv[2])
    liftover_hic(liftover, hic)
