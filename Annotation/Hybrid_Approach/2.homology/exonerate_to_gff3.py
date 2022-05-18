#!/usr/bin/env/ python3
"""
Author: Langqing Liu


"""

from sys import argv
import subprocess
import os.path

def exo_finder(EXO):
    nb = 0
    CDS = []
    nCDS = -1
    mRNA_START = 0
    mRNA_END = 0
    for line in EXO:
        if nb == 0:
            nb = nb + 1
            continue
        if line == "\n" and nb == 1:
            #print(CDS, len(CDS),mRNA_START,mRNA_END)
            NAME = NAME.split(" ")[0]
            print(("{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}".format(CHR,"exonerate","mRNA",START,END,INFO[0],INFO[1],INFO[2],NAME)))
            NAME = str(NAME).replace("ID=","Parent=")
            for i in range(0, len(CDS)):
                print(("{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}".format(CHR,"exonerate","CDS",CDS[i][2],CDS[i][3],INFO[0],INFO[1],INFO[2],NAME)))
            CDS = []
            mRNA_START = 0
            mRNA_END = 0
            nCDS = -1
            continue
        line=line.strip('\n')
        CHR = line.split("\t")[0]
        ELEMENT = line.split("\t")[2]
        START = line.split("\t")[3]
        END = line.split("\t")[4]
        INFO = line.split("\t")[5:8]
        NAME = line.split("\t")[8]
        TRANS = NAME.split(";")[0]
        CDS.append(list((CHR,ELEMENT,START,END,INFO,NAME)))
        nCDS = nCDS + 1
        if nCDS == 0:
            mRNA_START = CDS[nCDS][2]
            mRNA_END = CDS[nCDS][3]
        else:
            if mRNA_END < CDS[nCDS][2]:
                mRNA_END = CDS[nCDS][3]
            else:
                mRNA_START = CDS[nCDS][2]
        if ELEMENT == "start":
            START_LINE = list((CHR,ELEMENT,START,END,INFO,NAME))
        if ELEMENT == "stop":
            END_LINE = list((CHR,ELEMENT,START,END,INFO,NAME))
            if int(START_LINE[2]) < int(END_LINE[3]):
                mRNA_START = START_LINE[2]
                mRNA_END = END_LINE[3]
            else:
                mRNA_START = END_LINE[2]
                mRNA_END = START_LINE[3]
            print(("{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}".format(CHR,"gth2h","mRNA",mRNA_START,mRNA_END,INFO[0],INFO[1],INFO[2],NAME)))
        if ELEMENT == "CDSpart":
            print(("{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}".format(CHR,"gth2h","CDS",START,END,INFO[0],INFO[1],INFO[2],NAME)))
    return



if __name__ == "__main__":
    
    # parse input data
    exofile = argv[1]
    EXO = open(exofile)
    exo_finder(EXO)

