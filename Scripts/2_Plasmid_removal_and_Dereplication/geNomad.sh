#!/bin/bash
#SBATCH --job-name=geNomad
#SBATCH --output=geNomad.out
#SBATCH --mem=64gb
#SBATCH --time=69:00:00
#SBATCH --cpus-per-task=8
#SBATCH --open-mode=truncate
#SBATCH --partition=regular

contig_file=$1 #path to FASTA file with contigs
output_dir=$2 #path to output directory

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; module list
source activate /home/umcg-afernandez/.conda/envs/genomad; conda list 

# Run geNomad
genomad end-to-end \
        --min-score 0.7 \
        --cleanup \
        $contig_file \
        $output_dir \
        /home/umcg-afernandez/.conda/envs/genomad/genomad_db

conda deactivate
