#!/bin/bash
#SBATCH --time=15-10:10:10
#SBATCH --mem=50000
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --output=output.txt
#SBATCH --error=error_output.txt
#SBATCH --job-name=HiC
#SBATCH --qos=std

module load samtools
module load bedtools
module load picard


~/miniconda2/bin/hicBuildMatrix --samFiles aln.end1.SCEB.bam aln.end2.SCEB.bam --binSize 10000 --restrictionSequence GATC --outBam SCEB_ref.bam --outFileName SCEB_10kb.h5 --QCfolder SCEB_QC --threads 8 --inputBufferSize 300000

~/miniconda2/bin/hicMergeMatrixBins \
	--matrix SCEB_10kb.h5 --numBins 100 \
	--outFileName SCEB.100bins.h5

~/miniconda2/bin/hicPlotMatrix \
	--matrix SCEB.100bins.h5 \
	--log1p \
	--dpi 300 \
	--clearMaskedBins \
	--chromosomeOrder SCEB1 \
	--colorMap jet \
	--title "Hi-C matrix for test" \
	--outFileName plot_1Mb_matrix.png

