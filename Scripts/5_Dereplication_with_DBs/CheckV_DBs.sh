#!/bin/bash
#SBATCH --job-name=CheckV_DB
#SBATCH --output=CheckV_%j.out
#SBATCH --mem=32gb
#SBATCH --time=4-0
#SBATCH --cpus-per-task=16
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=himem

database=$1 #path to FASTA file of the database to run through CheckV (e.g. GPD)
db_name="$(basename "${database}")" #extract filename
output=$2 #path to output directory (no need to create it in advance)

echo '-------------------- WORKING WITH '${db_name}' DATABASE --------------------'

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; module list
source activate /home2/p304845/Conda_envs/CheckV_conda_env; conda list

# Run CheckV
checkv \
	end_to_end \
	$database \
	$output \
	-t ${SLURM_CPUS_PER_TASK} \
	-d /home2/p304845/Conda_envs/CheckV_conda_env/checkv-db-v1.5

conda deactivate
