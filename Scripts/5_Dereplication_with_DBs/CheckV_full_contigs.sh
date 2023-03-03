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
database=$2
cd $CheckV_dir

# Extract from the FASTA file of the DB the sequences with a completeness > 50% estimated by CheckV
seqtk subseq \
    -l 80 \
    $database \
    selected_CheckV_contigs.txt > CheckV_sequences.fna

# Set permissions
chmod 440 CheckV_sequences.fna 
