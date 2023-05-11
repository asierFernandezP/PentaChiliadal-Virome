#!/bin/bash
#SBATCH --job-name=CheckV_full_contigs
#SBATCH --output=CheckV_full_contigs.out
#SBATCH --mem=2gb
#SBATCH --time=00:19:00
#SBATCH --cpus-per-task=4
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=short

CheckV_dir=$1
database=$2
cd $CheckV_dir

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; module list
source activate /home2/p304845/Conda_envs/Seqtk_conda/; conda list

# Get the names of contigs that will be kept (completeness > 50%) or discarded.
awk 'NR>1' quality_summary.tsv | awk '$8 != "Low-quality" && $8 != "Not-determined"' | cut -f1 | sort > selected_CheckV_contigs.txt
awk 'NR>1' quality_summary.tsv | awk '$8 == "Low-quality" || $8 == "Not-determined"' | cut -f1 | sort > filtered_CheckV_contigs.txt

# Extract from the FASTA file of the DB the sequences with a completeness > 50% estimated by CheckV
seqtk subseq \
    -l 80 \
    $database \
    selected_CheckV_contigs.txt > CheckV_sequences.fna

# Set permissions
chmod 440 CheckV_sequences.fna
