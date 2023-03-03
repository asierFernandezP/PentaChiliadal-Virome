#!/bin/bash
#SBATCH --job-name=CheckV_DB
#SBATCH --output=CheckV__%A_%a.out
#SBATCH --mem=32gb
#SBATCH --time=7-0
#SBATCH --cpus-per-task=8
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=regular

database=$1 #path to FASTA file of the database to run through CheckV (e.g. GPD)
db_name="$(basename "${database}")" #extract filename
output=$2 #path to output directory (no need to create it in advance)

echo '-------------------- WORKING WITH '${db_name}' DATABASE --------------------'

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; module list
source activate /data/umcg-llnext/python_venvs/CheckV_conda; conda list 
#Add prodigal-gv to path:
export PATH="/data/umcg-llnext/python_venvs/CheckV_conda/prodigal-gv:$PATH"

# Run CheckV
checkv \
			 end_to_end \
			 $database \
			 $output \
			 -t ${SLURM_CPUS_PER_TASK} \
			 -d /data/umcg-llnext/python_venvs/CheckV_conda/checkv-db-v1.5

conda deactivate
