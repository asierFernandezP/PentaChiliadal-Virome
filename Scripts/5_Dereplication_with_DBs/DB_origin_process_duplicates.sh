#!/bin/bash
#SBATCH --job-name=DB_origin_process_duplicates
#SBATCH --output=DB_process_duplicates.out
#SBATCH --mem=4gb
#SBATCH --time=00:19:00
#SBATCH --cpus-per-task=4
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=regular

viral_fasta_dir=$1 # directory with all the FASTA files to be used as input for dereplication

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; ml R; module list
source activate /home2/p304845/Conda_envs/Seqtk_conda/; conda list

# Concatenate all the viral sequences to be used for dereplication
cat $viral_fasta_dir/*fna > STEP5_input_sequences.fa
cat $viral_fasta_dir/*fa  >> STEP5_input_sequences.fa
cat $viral_fasta_dir/*fasta >> STEP5_input_sequences.fa

# Extract the IDs of all the viral sequences to be used for dereplication
seqtk seq -n STEP5_input_sequences.fa > STEP5_input_sequences.txt

# Execute the R script 
Rscript DB_origin_check_duplicated_sequences.R STEP5_input_sequences.txt

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3
source activate /home2/p304845/Conda_envs/Seqkit_conda_env/; conda list

# Remove duplicated sequences
seqkit rmdup -n < STEP5_input_sequences.fa > STEP5_combined_sequences_nodup.fa
