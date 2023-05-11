#!/bin/bash
#SBATCH --job-name=Viral_RefSeq_proc
#SBATCH --output=Viral_RefSeq_proc.out
#SBATCH --mem=1gb
#SBATCH --time=00:05:00
#SBATCH --cpus-per-task=8
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=regular

database=$1 #path to FASTA file of the database to run through CheckV (Viral_RefSeq)
database_tax=$2 #path to database taxonomy file

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; module list
source activate /home2/p304845/Conda_envs/Seqtk_conda/; conda list

# Create a file excluding the names of RNA viruses (Riboviria realm) from Viral RefSeq DB
awk 'NR>1' $database_tax | grep -v Riboviria | cut -f1,2 | tr "\t" " " | sed 's/.$//'> non_RNA_viral_refseq.txt

#Extract from the FASTA file of the DB the sequences that are NOT assigned to RNA viruses 
seqtk subseq \
	-l 80 \
	$database \
	non_RNA_viral_refseq.txt > non_RNA_viral_refseq.fna 

#Exclude from the FASTA file of the DB the sequences <10kb
seqtk seq \
	-L 10000 \
	non_RNA_viral_refseq.fna  > non_RNA_10kb_viral_refseq.fna 

# Set permissions
chmod 440 non_RNA_viral_refseq.fna non_RNA_10kb_viral_refseq.fna non_RNA_viral_refseq.txt 
