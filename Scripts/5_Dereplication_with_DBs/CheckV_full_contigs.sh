#!/bin/bash
#SBATCH --job-name=CheckV_full_contigs
#SBATCH --output=CheckV_full_contigs.out
#SBATCH --mem=8gb
#SBATCH --time=00:19:00
#SBATCH --cpus-per-task=4
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=short

CheckV_dir=$1
cd $CheckV_dir

# Select the full contigs with a completeness > 50% estimated by CheckV 
cat proviruses.fna | grep ">"| cut -f2 -d ">"


grep -Fwf selected_CheckV_contigs.txt -A 1 viruses.fna > CheckV_sequences.fna
sed 's/.*/&_/' selected_CheckV_contigs.txt | grep -A 1 -Ff - proviruses.fna >> CheckV_sequences.fna #adds an underscore at the end of each line. The option - tells grep to read the patterns to search from standard input

# Set permissions
chmod 440 CheckV_sequences.fna 
