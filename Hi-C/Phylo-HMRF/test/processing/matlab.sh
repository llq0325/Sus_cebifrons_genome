#!/bin/bash
#SBATCH --job-name=matlab
#SBATCH --time=25-10:10:10
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem=10000
#SBATCH --qos=std
#SBATCH --output=output.txt
#SBATCH --error=error_output.txt

module load matlab

cat load_state_test_mod.m | matlab -nodesktop -nosplash
