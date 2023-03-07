#!/bin/bash
#SBATCH --job-name=CheckV_viral_regions_merging
#SBATCH --output=CheckV_reg_merge.out
#SBATCH --mem=8gb
#SBATCH --time=00:19:00
#SBATCH --cpus-per-task=4
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=short

CheckV_dir=$1
cd $CheckV_dir

# Get the names of contigs whose viral regions will be kept (completeness > 50%) or discarded.
awk 'NR>1' quality_summary.tsv | awk '$8 != "Low-quality" && $8 != "Not-determined"' | cut -f1 | sort > selected_CheckV_contigs.txt
awk 'NR>1' quality_summary.tsv | awk '$8 == "Low-quality" || $8 == "Not-determined"' | cut -f1 | sort > filtered_CheckV_contigs.txt

# Extract from the viruses.fna and proviruses.fna files the sequences with a completeness > 50% estimated by CheckV
seqtk subseq \
    -l 80 \
    viruses.fna \
    selected_CheckV_contigs.txt > CheckV_sequences.fna
seqtk subseq \
    -l 80 \
    proviruses.fna \
    selected_CheckV_contigs.txt >> CheckV_sequences.fna    
    
# Set permissions
chmod 440 CheckV_sequences.fna 
