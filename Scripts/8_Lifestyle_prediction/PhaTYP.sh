#!/bin/bash
#SBATCH --job-name=PhaTYP_present_vOTUs
#SBATCH --output=PhaTYP_present_vOTUs.out
#SBATCH --mem=16gb
#SBATCH --time=00:05:59
#SBATCH --cpus-per-task=24
#SBATCH --open-mode=truncate
#SBATCH --partition=regular

vOTU_seqs=$1 #FASTA file of representative sequences of vOTUs
vOTU_seqs_name="${vOTU_seqs%.*}" #extract filename without the extension

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; module list
source activate /home2/p304845/Conda_envs/PhaTYP_conda_env; conda list
# Add prodigal-gv to path
export PATH="/home2/p304845/Conda_envs/Prodigal_gv_conda/bin/:$PATH"

# Run PhaTYP
python /home2/p304845/Conda_envs/PhaTYP_conda_env/PhaTYP/preprocessing.py --contigs $vOTU_seqs --prodigal prodigal-gv
python /home2/p304845/Conda_envs/PhaTYP_conda_env/PhaTYP/PhaTYP.py --out ${vOTU_seqs_name}_PhaTyP_prediction.csv

conda deactivate
