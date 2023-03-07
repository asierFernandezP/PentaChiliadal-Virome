#!/bin/bash
#SBATCH --job-name=merge_CheckV_results
#SBATCH --output=merge_CheckV.out
#SBATCH --mem=4gb
#SBATCH --time=00:09:59
#SBATCH --cpus-per-task=4
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=short

CheckV_output=$1 # CheckV output folder
mkdir CheckV_merged_results # directory to store results

# Concatenate viruses.fna files
# Important to use 'NR>1' to avoid concatenating headers
find $CheckV_output -type f -name "viruses.fna" -exec awk 'NR>1' {} + >> CheckV_merged_results/viruses.fna
# Concatenate proviruses.fna files
find $CheckV_output -type f -name "proviruses.fna" -exec awk 'NR>1' {} + >> CheckV_merged_results/proviruses.fna
# Concatenate quality_summary.tsv, contamination.tsv, completeness.tsv and complete_genomes.tsv
find $CheckV_output -type f -name "quality_summary.tsv" -exec awk 'NR>1' {} + >> CheckV_merged_results/quality_summary.tsv
find $CheckV_output -type f -name "contamination.tsv" -exec awk 'NR>1' {} + >> CheckV_merged_results/contamination.tsv
find $CheckV_output -type f -name "completeness.tsv" -exec awk 'NR>1' {} + >> CheckV_merged_results/completeness.tsv
find $CheckV_output -type f -name "complete_genomes.tsv" -exec awk 'NR>1' {} + >> CheckV_merged_results/complete_genomes.tsv
