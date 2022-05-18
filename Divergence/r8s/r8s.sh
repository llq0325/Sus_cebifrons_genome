#r8s (version 1.71)
export PATH=$PATH:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/r8s1.81/src
###This step estimate the divergence time of OUT group species(include Human Dog Killerwhale) and part of ruminat species(each family has at least one species);Input file is the nex file,all parameters are set in this file, and the tree with branch length is also put in this file;Output file is the result of r8s calculate result;
r8s -b -f evo_rate.nex

###This step estimate the divergence time of all ruminant species in this project;Input file is the nex file,all parameters are set in this file, and the tree with branch length is also put in this file;Output file is the result of r8s calculate result;
#r8s -b -f Inside.nex
