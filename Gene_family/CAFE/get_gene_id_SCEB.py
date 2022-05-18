#!/usr/bin/env/ python3
"""
Author: Langqing Liu

python get_gene_id.py SCEB.expansion.txt SCEB.anno.txt FAM_ID_Orthofinder_mcl_output.tsv >  expansion_gene_id.txt
"""

from sys import argv
import os.path
import re

def parse_input(cofefile,annofile,mclfile):
    cofe_FamId = []
    for line in cofefile:
        cofe_FamId.append(line.strip().split("\t")[0])
    anno_SCEB_GeneId = []
    for line in annofile:
        anno_SCEB_GeneId.append(line.strip().split("\t"))
    mcl_FamId_SCEB = []
    for line in mclfile:
        record=[]
        FamId = line.strip().split("\t")[0]
        record.append(FamId)
        for i in line.strip().split("\t"):
            if i.startswith("SCEB"): #change to get different species
                SCEB_id = i.split("|")[1]
                record.append(SCEB_id)
        mcl_FamId_SCEB.append(record)
    #print(anno_SCEB_GeneId)
    return cofe_FamId,anno_SCEB_GeneId,mcl_FamId_SCEB

def get_gene_id(cofe_FamId,anno_SCEB_GeneId,mcl_FamId_SCEB):
    for i in cofe_FamId:
        fam_id = i
        for j in mcl_FamId_SCEB:
            if i == j[0]:
                Fam_detail = j
                for SCEB_id in Fam_detail[1:]:
                    for anno in anno_SCEB_GeneId:
                        #print(anno)
                        #continue
                        if SCEB_id in anno:
                            try:
                                gene_id = anno[1]
                                print("\t".join([SCEB_id,gene_id,fam_id]))
                                #print(SCEB_id,gene_id,fam_id)
                            except:
                                pass






if __name__ == "__main__":
    cofefile = open(argv[1])
    annofile = open(argv[2])
    mclfile = open(argv[3])
    #length = get_seq_len(seqfile)
    cofe_FamId,anno_SCEB_GeneId,mcl_FamId_SCEB = parse_input(cofefile,annofile,mclfile)
    get_gene_id(cofe_FamId,anno_SCEB_GeneId,mcl_FamId_SCEB)
