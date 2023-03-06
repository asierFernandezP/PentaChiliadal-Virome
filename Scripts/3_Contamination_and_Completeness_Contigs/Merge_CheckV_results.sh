#!/bin/bash
#SBATCH --job-name=merge_CheckV_results
#SBATCH --output=merge_CheckV.out
#SBATCH --mem=4gb
#SBATCH --time=00:19:59
#SBATCH --cpus-per-task=4
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=short

# Move all result folders from the 20 partitions to the same directory
# Concatenate viruses.fna files
find . -type f -name "viruses.fna" -exec cat {} + >> viruses.fna
# Concatenate proviruses.fna files
find . -type f -name "proviruses.fna" -exec cat {} + >> proviruses.fna
# Concatenate quality_summary.tsv files
find . -type f -name "quality_summary.tsv" -exec cat {} + >> quality_summary.tsv
