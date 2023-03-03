#!/bin/bash
#SBATCH --job-name=CheckV_Viral_RefSeq
#SBATCH --output=CheckV_Viral_RefSeq.out
#SBATCH --mem=32gb
#SBATCH --time=3-0
#SBATCH --cpus-per-task=8
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=regular

database=$1 #path to FASTA file of the database to run through CheckV (Viral_RefSeq)
database_tax=$2 #path to database taxonomy file
output=$3 #path to output directory

# Clean environment and load seqtk module
module purge; ml seqtk; ml list

# Create a file excluding the names of RNA viruses (Riboviria realm) from Viral RefSeq DB
 #########update awk command, merge column 1 and 2 by space
awk 'NR>1' $database_tax | grep -v Riboviria | cut -f1,2 | tr "\t" " " | sed 's/.$//'> non_RNA_viral_refseq.txt

#Extract from the FASTA file of the DB the sequences that are NOT assigned to RNA viruses 
seqtk subseq \
	-l 80 \
	$database \
	non_RNA_viral_refseq.txt > non_RNA_viral_refseq.fna 

# Set permissions
chmod 440 non_RNA_viral_refseq.fna non_RNA_viral_refseq.txt

# Clean environment and activate conda environment
module purge; ml Anaconda3; module list
source activate /data/umcg-llnext/python_venvs/CheckV_conda; conda list 
#Add prodigal-gv to path:
export PATH="/data/umcg-llnext/python_venvs/CheckV_conda/prodigal-gv:$PATH"

# Run CheckV
checkv \
	end_to_end \
	non_RNA_viral_refseq.fna \
	$output \
	-t ${SLURM_CPUS_PER_TASK} \
	-d /data/umcg-llnext/python_venvs/CheckV_conda/checkv-db-v1.5

conda deactivate
