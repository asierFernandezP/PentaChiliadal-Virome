#!/bin/bash
#SBATCH --job-name=CheckV_der_contigs
#SBATCH --output=CheckV_der_contigs.out
#SBATCH --mem=64gb
#SBATCH --time=10-0
#SBATCH --cpus-per-task=16
#SBATCH --open-mode=truncate
#SBATCH --partition=regular

contig_file=$1 #path to FASTA file with predicted viral contigs
contig_file_name="$(basename "${contig_file}")" #extract filename 
contig_file_name="${contig_file_name%.*}" #extract filename without the extension      

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; module list
source activate /data/umcg-llnext/python_venvs/CheckV_conda; conda list 
# Load BLAST
ml BLAST+/2.12.0-gompi-2021b
#Add prodigal-gv to path:
export PATH="/data/umcg-llnext/python_venvs/CheckV_conda/prodigal-gv:$PATH"

# Run dereplication for contigs with CheckV scripts

#First, create a blast+ database:
makeblastdb -in $contig_file -dbtype nucl -out ${contig_file_name}_db.fa

#Next, use megablast from blast+ package to perform all-vs-all blastn of sequences:
blastn -query $contig_file -db ${contig_file_name}_db.fa -outfmt '6 std qlen slen' -max_target_seqs 10000 -out ${contig_file_name}_blast.tsv -num_threads 16

#Next, calculate pairwise ANI by combining local alignments between sequence pairs:
/data/umcg-llnext/python_venvs/CheckV_conda/anicalc.py -i ${contig_file_name}_blast.tsv  -o ${contig_file_name}_ani.tsv

#Finally, perform UCLUST-like clustering using the MIUVIG recommended-parameters (95% ANI + 85% AF):
/data/umcg-llnext/python_venvs/CheckV_conda/aniclust.py --fna $contig_file --ani ${contig_file_name}_ani.tsv --out ${contig_file_name}_clusters.tsv --min_ani 95 --min_tcov 85 --min_qcov 0

conda deactivate
