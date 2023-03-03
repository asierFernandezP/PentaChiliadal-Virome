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

# Merge the selected sequences from the proviruses.fna and viruses.fna files
grep -Fwf selected_CheckV_contigs.txt -A 1 viruses.fna > CheckV_sequences.fna
sed 's/.*/&_/' selected_CheckV_contigs.txt | grep -A 1 -Ff - proviruses.fna >> CheckV_sequences.fna #adds an underscore at the end of each line. The option - tells grep to read the patterns to search from standard input

# Set permissions
chmod 440 CheckV_sequences.fna 
