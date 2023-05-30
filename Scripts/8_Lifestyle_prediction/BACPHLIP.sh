#!/bin/bash
#SBATCH --job-name=BACPHLIP_present_vOTUs
#SBATCH --output=BACPHLIP_present_vOTUs.out
#SBATCH --mem=100gb
#SBATCH --time=4-0
#SBATCH --cpus-per-task=24
#SBATCH --open-mode=truncate
#SBATCH --partition=himem

vOTU_seqs=$1 #FASTA file of representative sequences of vOTUs present in the samples

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3 HMMER/3.3.2-gompi-2022a; module list
source activate /home2/p304845/Conda_envs/BACPHLIP_conda; conda list

# Run BACPHLIP
bacphlip -i $vOTU_seqs --multi_fasta

conda deactivate
