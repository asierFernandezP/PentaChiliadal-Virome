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

# Merge the selected sequences from the proviruses.fna and viruses.fna files
grep -Fwf selected_CheckV_contigs.txt -A 1 viruses.fna > CheckV_sequences.fna
sed 's/.*/&_/' selected_CheckV_contigs.txt | grep -A 1 -Ff - proviruses.fna >> CheckV_sequences.fna #adds an underscore at the end of each line #The option - tells grep to read the patterns to search from standard input
n_final_sequences=$(cat CheckV_sequences.fna| grep ">" | wc -l)
echo "The final number of viral sequences with completeness >50% is: $n_final_sequences"
echo -e "The final sequences are available in CheckV_sequences.fna file\n"

# Set permissions
chmod 440 CheckV_sequences.fna 
