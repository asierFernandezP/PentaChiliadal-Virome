#!/bin/bash
#SBATCH --job-name=CheckV_der_contigs
#SBATCH --output=CheckV_der_contigs.out
#SBATCH --mem=64gb
#SBATCH --time=2-0
#SBATCH --cpus-per-task=24
#SBATCH --open-mode=truncate
#SBATCH --partition=regular

contig_file=$1 #path to FASTA file with predicted viral contigs
contig_file_name="$(basename "${contig_file}")" #extract filename 
contig_file_name="${contig_file_name%.*}" #extract filename without the extension      

# Load BLAST
module purge; ml BLAST+/2.12.0-gompi-2021b

#First, create a blast+ database:
makeblastdb \
	-in $contig_file \
	-dbtype nucl \
	-out ${contig_file_name}_db.fa

#Next, use megablast from blast+ package to perform all-vs-all blastn of sequences:
blastn \
	-query $contig_file \
	-db ${contig_file_name}_db \
	-outfmt '6 std qlen slen' \
	-max_target_seqs 10000 \
	-out ${contig_file_name}_blast.tsv \
	-num_threads 24
