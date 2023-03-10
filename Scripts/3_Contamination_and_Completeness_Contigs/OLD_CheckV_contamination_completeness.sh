#!/bin/bash
#SBATCH --job-name=CheckV_contigs
#SBATCH --output=CheckV_contigs_%j.out
#SBATCH --mem=20gb
#SBATCH --time=03:59:00
#SBATCH --cpus-per-task=24
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=regular

contig_file=$1 #path to FASTA file with the predicted viral contigs
contig_file_name="$(basename "${contig_file}")" #extract filename
output=$2 #path to output directory

echo '-------------------- WORKING WITH '${contig_file_name}' FILE --------------------'

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; module list
source activate /data/umcg-llnext/python_venvs/CheckV_conda; conda list 
#Add prodigal-gv to path:
export PATH="/data/umcg-llnext/python_venvs/CheckV_conda/prodigal-gv:$PATH"

# Run CheckV
checkv \
	end_to_end \
	$contig_file \
	$output \
	-t ${SLURM_CPUS_PER_TASK} \
	-d /data/umcg-llnext/python_venvs/CheckV_conda/checkv-db-v1.5

conda deactivate
