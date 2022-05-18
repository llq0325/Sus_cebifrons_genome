#!/bin/bash
#SBATCH --job-name=functional_annotation
#SBATCH --time=5-0
#SBATCH --cpus-per-task=1
#SBATCH --mem=8000
#SBATCH --qos=std
#SBATCH --output=output_annie_%j.txt
#SBATCH --error=error_output_annie_%j.txt

#source ~/my_envs/p35_lumpy/bin/activate

#first perform homology blast and interproscan
#sbatch blast.sh
#sbatch iproscan.sh

#convert gff to get a gene line
#python gff_for_annie.py --infile final_annotation.gff --out final_annotation_withgeneline.gff


#parse blastp results with annie
python3 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/annie/annie.py -b translation_to_sprot.tsv -g final_annotation_withgeneline.gff -db /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/uniprot_db/uniprot_sprot.fasta -o annie_blasttable.tsv

#convert interpro file to tsv
tr ' ' \\t < interproscan.tsv > interpro_results.tsv

#parse interpro results with annie
python3 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/annie/annie.py -ipr interpro_results.tsv -o annie_interprotable.tsv

#merge results
cat annie_blasttable.tsv annie_interprotable.tsv > annie_allresults.tsv

#convert gff to GAGs liking
python2 gff_for_GAG.py --infile final_annotation_withgeneline.gff --out annotation_for_GAG.gff --annie annie_allresults.tsv

#use GAG to finish annotation and fix terminal Ns in the genome
python2 /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/GAG/gag.py -f /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Hybrid_Approach_SCEB13/0.Repeat/SCEB.masked.fa -g annotation_for_GAG.gff --fix_start_stop -o GAG_out

#then maker scripts to rename to NCBI suggested naming
/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/maker/bin/maker_map_ids --prefix SCEB_ --justify 8 GAG_out/genome.gff > GAG_out/genome.map

/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/maker/bin/map_gff_ids GAG_out/genome.map GAG_out/genome.gff

#some final postprocessing: remove empty names, give fasta a decent line size, copy to folder, get cds and proteins
mkdir final_assembly_annotation
/lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/bin/EMBOSS-6.6.0/emboss/seqret -sequence GAG_out/genome.fasta -outseq /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/EVM_SCEB13_20200225/final_assembly_annotation/sus_cebifrons.fa
awk '{ gsub("Name=;", "") ; print $0 }' GAG_out/genome.gff > /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/EVM_SCEB13_20200225/final_assembly_annotation/sus_cebifrons.gff
module load cufflinks
gffread /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/EVM_SCEB13_20200225/final_assembly_annotation/sus_cebifrons.gff \
 -g /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/EVM_SCEB13_20200225/final_assembly_annotation/sus_cebifrons.fa \
 -x /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/EVM_SCEB13_20200225/final_assembly_annotation/sus_cebifrons_cds.fa \
 -y /lustre/nobackup/WUR/ABGC/liu194/analysis/Visayan_Warty_pig_10X/annotation/Functional_Annotation/EVM_SCEB13_20200225/final_assembly_annotation/sus_cebifrons_protein.fa
