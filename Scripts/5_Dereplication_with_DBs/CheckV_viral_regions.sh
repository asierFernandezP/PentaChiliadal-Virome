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

#Load modules
module load seqtk; ml list

# Get the names of contigs whose viral regions will be selected (completeness > 50% or not-determined) or discarded.
awk 'NR>1' quality_summary.tsv | awk '$8 != "Low-quality"' | cut -f1 | sort > selected_CheckV_contigs.txt
awk 'NR>1' quality_summary.tsv | awk '$8 == "Low-quality"' | cut -f1 | sort > filtered_CheckV_contigs.txt

# Remove spaces from the proviruses.fna headers and get the IDs of the proviral sequences that will be selected.
sed 's, ,_,g' proviruses.fna > proviruses_mod.fna 
sed 's/.*/&_/' selected_CheckV_contigs.txt | grep -Ff - proviruses_mod.fna | cut -c2- > selected_CheckV_proviruses.txt #add underscore with sed to avoid capturing uncorrect sequences that match the pattern

# Extract from the viruses.fna and proviruses.fna files the sequences with a completeness > 50% estimated by CheckV
seqtk subseq \
    -l 80 \
    viruses.fna \
    selected_CheckV_contigs.txt > CheckV_sequences.fna
    
seqtk subseq \
    -l 80 \
    proviruses_mod.fna \
    selected_CheckV_proviruses.txt >> CheckV_sequences.fna    
    
# Set permissions
chmod 440 CheckV_sequences.fna 
