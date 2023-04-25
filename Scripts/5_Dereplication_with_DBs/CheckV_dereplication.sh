#!/bin/bash
#SBATCH --job-name=CheckV_der_all_viruses
#SBATCH --output=CheckV_der_all_viruses.out
#SBATCH --mem=100gb
#SBATCH --time=1-0
#SBATCH --cpus-per-task=24
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=himem

contig_file=$1 #path to FASTA file all the viral sequences (own viral database + public DBs)
contig_file_name="$(basename "${contig_file}")" #extract filename
contig_file_name="${contig_file_name%.*}" #extract filename without the extension
blast_db=$2 #path to blast+ database generated from all viral sequences

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; module list
source activate /home2/p304845/Conda_envs/CheckV_conda_env; conda list

# Run dereplication for contigs with CheckV scripts

#Using the blast+ database as input, caalculate pairwise ANI by combining local alignments between sequence pairs:
python /home2/p304845/Conda_envs/CheckV_conda_env/anicalc.py -i $blast_db  -o ${contig_file_name}_ani.tsv

#Finally, perform UCLUST-like clustering using the MIUVIG recommended-parameters (95% ANI + 85% AF):
python /home2/p304845/Conda_envs/CheckV_conda_env/aniclust.py --fna $contig_file --ani ${contig_file_name}_ani.tsv --out ${contig_file_name}_clusters.tsv --min_ani 95 --min_tcov 85 --min_qcov 0

conda deactivate
