#!/bin/bash
#SBATCH --job-name=split_contig_file
#SBATCH --output=split_contig.out
#SBATCH --mem=4gb
#SBATCH --time=00:09:59
#SBATCH --cpus-per-task=4
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=short

contig_file=$1
mkdir split_contigs

#Load BBMap and split the contig file in 20 files
ml BBMap
partition.sh \
	in=$contig_file \
	out=split_contigs/Viral_sequences_%.fa
	ways=20
