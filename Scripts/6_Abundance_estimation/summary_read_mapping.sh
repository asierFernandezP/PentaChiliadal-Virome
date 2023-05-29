#!/bin/bash
#SBATCH --job-name=summary_Read_mapping
#SBATCH --output=summary_Read_mapping.out
#SBATCH --mem=16gb
#SBATCH --time=01:59:00
#SBATCH --cpus-per-task=16
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=regular

viral_genomes=$1 # file with the names of representative viral genomes
samples=$2 # file with sample names
bed_coverage_output=$3 # path to BED coverage output files *.coverage.txt
reads_table=$4 # file with sample names and number of clean reads

# Clean environment, load modules
module purge; module load R; module list
# Execute the R script
Rscript summary_read_mapping.R $viral_genomes $samples $bed_coverage_output $reads_table
