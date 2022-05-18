#!/bin/bash
#SBATCH --time=30-10:10:10
#SBATCH --mem=150000
#SBATCH --ntasks=30
#SBATCH --nodes=5
#SBATCH --output=outputEVM.txt
#SBATCH --error=error_outputEVM.txt
#SBATCH --job-name=EVM
#SBATCH --qos=std


export GENEMARK_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/test/gm_et_linux_64
export AUGUSTUS_CONFIG_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/config
export AUGUSTUS_BIN_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/bin
export AUGUSTUS_SCRIPTS_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/scripts:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/scripts:$AUGUSTUS_SCRIPTS_PATH
export PERL5LIB=/home/WUR/liu194/perl5/perlbrew/perls/perl-5.20.1/lib/perl5
export PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Augustus/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/BRAKER/scripts:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/gth-1.7.1-Linux_x86_64-64bit/bin:/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/evidencemodeler-1.1.1:$PATH
export ALIGNMENT_TOOL_PATH=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/gth-1.7.1-Linux_x86_64-64bit/bin
PARAFLY=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_RaGOO/5.EVM/parafly-r2013-01-21/bin
EVM=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/Funannota/opt/evidencemodeler-1.1.1



module load bamtools
module load samtools
module load BLAST+/2.2.28
module load python
module load perl

genome=/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_SCEB13/0.Repeat/SCEB.fa.preSatMar211447412020.RMoutput/SCEB.fa.masked
geneprediction=gene_predictions.gff3
proteinalignment=homolog_alignment.gff3

$EVM/EvmUtils/partition_EVM_inputs.pl --genome $genome --gene_predictions $geneprediction --segmentSize 500000 --overlapSize 50000 --partition_listing partitions_list.out --protein_alignments $proteinalignment
echo "partition_EVM_inputs is finished!"

$EVM/EvmUtils/write_EVM_commands.pl --genome $genome --weights $PWD/weights.txt --gene_predictions $geneprediction --output_file_name evm.out  --partitions partitions_list.out >  commands.list
echo "write_EVM_commands is finished!"

$PARAFLY/bin/ParaFly -c commands.list -CPU 30 -shuffle -failed_cmds commands.list.failed
echo "execute_EVM_commands is finished!"

$EVM/EvmUtils/recombine_EVM_partial_outputs.pl --partitions partitions_list.out --output_file_name evm.out
echo "recombine_EVM_partial_outputs is finished!"

$EVM/EvmUtils/convert_EVM_outputs_to_GFF3.pl  --partitions partitions_list.out --output evm.out  --genome $genome
echo "convert_EVM_outputs_to_GFF3 is finished!"

find . -regex ".*evm.out.gff3" -exec cat {} \; > EVM.all.gff3
