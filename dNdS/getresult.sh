#!/bin/bash
#SBATCH --time=10-10:10:10
#SBATCH --mem=10000
#SBATCH --ntasks=4
#SBATCH --nodes=1
#SBATCH --output=outputPAML.txt
#SBATCH --error=error_outPAML.txt
#SBATCH --job-name=dNdS
#SBATCH --qos=std

#grep lnL H0/*.BSH0mlc > H0_lnL_result.txt
#sed 's/):.*-/: -/g' H0_lnL_result.txt > H0_lnL_result.fix.txt
#grep lnL H1/*.BSH1mlc > H1_lnL_result.txt
#sed 's/):.*-/: -/g' H1_lnL_result.txt > H1_lnL_result.fix.txt
#grep lnL H0_REG/*.BSH0mlc > H0_REG_lnL_result.txt
#sed 's/):.*-/: -/g' H0_REG_lnL_result.txt > H0_REG_lnL_result.fix.txt


grep lnL oneratio/*.oneratio > oneratio_REG_lnL_result.txt
grep lnL tworatio_SCEB/*.tworatio_SCEB > tworatio_SCEB_REG_lnL_result.txt
grep lnL tworatio_pig/*.tworatio_pig > tworatio_pig_REG_lnL_result.txt
grep lnL tworatio_SUS/*.tworatio_SUS > tworatio_SUS_REG_lnL_result.txt

#grep lnL BS_H0_SCEB/*.BS_H0_SCEB > BS_H0_SCEB_lnL_result.txt
#grep lnL BS_H1_SCEB/*.BS_H1_SCEB > BS_H1_SCEB_lnL_result.txt
#grep lnL BS_H0_pig/*.BS_H0_pig > BS_H0_pig_lnL_result.txt
#grep lnL BS_H1_pig/*.BS_H1_pig > BS_H1_pig_lnL_result.txt
#grep lnL BS_H0_DOM/*.BS_H0_DOM > BS_H0_DOM_lnL_result.txt
#grep lnL BS_H1_DOM/*.BS_H1_DOM > BS_H1_DOM_lnL_result.txt
#grep lnL BS_H1_SUS/*.BS_H1_SUS > BS_H1_SUS_lnL_result.txt
#grep lnL BS_H0_SUS/*.BS_H0_SUS > BS_H0_SUS_lnL_result.txt

