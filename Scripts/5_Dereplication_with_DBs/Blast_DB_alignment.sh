#!/bin/bash
#SBATCH --job-name=Blast_DB_alignment
#SBATCH --output=Blast_DB_alignment.out
#SBATCH --mem=200gb
#SBATCH --time=6-0
#SBATCH --cpus-per-task=24
#SBATCH --open-mode=truncate
#SBATCH --partition=himem

contig_file=$1 #path to FASTA file with predicted viral contigs
contig_file_name="$(basename "${contig_file}")" #extract filename
contig_file_name="${contig_file_name%.*}" #extract filename without the extension

# Load BLAST
module purge; ml BLAST+/2.13.0-gompi-2022a

#First, create a blast+ database:
makeblastdb \
	-in $contig_file \
	-dbtype nucl \
	-out ${contig_file_name}_db

#Next, use megablast from blast+ package to perform all-vs-all blastn of sequences:
blastn \
	-query $contig_file \
	-db ${contig_file_name}_db \
	-outfmt '6 std qlen slen' \
	-max_target_seqs 10000 \
	-out ${contig_file_name}_blast.tsv \
	-num_threads ${SLURM_CPUS_PER_TASK}
