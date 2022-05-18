# USAGE:
# python aa_diversity.py > GENE_aa_div.txt

# purpose is to calculate amino acid diversity at each position along a gene of interest.  Does not count stop codons 'X' or gaps '-'.  Diversity not caculated for postions with less than 5 species aligned.

import sys
import numpy as np
from Bio import SeqIO

g = sys.argv[1]

nseq = 0
SEQ = []
for seq_record in SeqIO.parse('/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/Olfactory_Receptor/aa_diversity/seq/%s' % (g), "fasta"):
    B = seq_record.seq
    seq = []
    for i in B:
        seq.append(i)
    SEQ.append(seq)
    nseq += 1

POS = []
for k in range(len(SEQ[0])):
    pos = []
    for j in range(len(SEQ)):
        pos.append(SEQ[j][k])
    POS.append(pos)


A = []
R = []
N = []
D = []
C = []
Q = []
E = []
G = []
H = []
I = []
L = []
K = []
M = []
F = []
P = []
S = []
T = []
W = []
Y = []
V = []

for m in range(len(POS)):
    aaA = 0
    aaR = 0
    aaN = 0
    aaD = 0
    aaC = 0
    aaQ = 0
    aaE = 0
    aaG = 0
    aaH = 0
    aaI = 0
    aaL = 0
    aaK = 0
    aaM = 0
    aaF = 0
    aaP = 0
    aaS = 0
    aaT = 0
    aaW = 0
    aaY = 0
    aaV = 0
    for l in range(len(POS[0])):
        if POS[m][l] == 'A':
            aaA = aaA + 1
        if POS[m][l] == 'R':
            aaR = aaR + 1
        if POS[m][l] == 'N':
            aaN = aaN + 1
        if POS[m][l] == 'D':
            aaD = aaD + 1
        if POS[m][l] == 'C':
            aaC = aaC + 1
        if POS[m][l] == 'Q':
            aaQ = aaQ + 1
        if POS[m][l] == 'E':
            aaE = aaE + 1
        if POS[m][l] == 'G':
            aaG = aaG + 1
        if POS[m][l] == 'H':
            aaH = aaH + 1
        if POS[m][l] == 'I':
            aaI = aaI + 1
        if POS[m][l] == 'L':
            aaL = aaL + 1
        if POS[m][l] == 'K':
            aaK = aaK + 1
        if POS[m][l] == 'M':
            aaM = aaM + 1
        if POS[m][l] == 'F':
            aaF = aaF + 1
        if POS[m][l] == 'P':
            aaP = aaP + 1
        if POS[m][l] == 'S':
            aaS = aaS + 1
        if POS[m][l] == 'T':
            aaT = aaT + 1
        if POS[m][l] == 'W':
            aaW = aaW + 1
        if POS[m][l] == 'Y':
            aaY = aaY + 1
        if POS[m][l] == 'V':
            aaV = aaV + 1
    A.append(aaA)
    R.append(aaR)
    N.append(aaN)
    D.append(aaD)
    C.append(aaC)
    Q.append(aaQ)
    E.append(aaE)
    G.append(aaG)
    H.append(aaH)
    I.append(aaI)
    L.append(aaL)
    K.append(aaK)
    M.append(aaM)
    F.append(aaF)
    P.append(aaP)
    S.append(aaS)
    T.append(aaT)
    W.append(aaW)
    Y.append(aaY)
    V.append(aaV)

# Make a matrix of amino acid counts:
a = np.vstack([A, R, N, D, C, Q, E, G, H, I, L, K, M, F, P, S, T, W, Y, V])

diversity = []
#print(nseq)
for j in range(len(POS)):
    # Make a list of counts for each AA at first postion:
    aaPos = []
    for i in range(20):
        aaPos.append(a[i][j])
    #print aaPos

    total = sum(aaPos)

    div = 0
    if total > nseq * 0.5:
        for k in range(len(aaPos)):
            div = div + (float(aaPos[k])/total)**2
        if div != 1:
            #print(j, div)
            pass
    diversity.append(div)

def Average(lst): 
    return sum(lst) / len(lst) 

print("\t".join([str(nseq),str(Average(diversity))]))






