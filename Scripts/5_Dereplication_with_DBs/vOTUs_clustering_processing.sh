#!/bin/bash
#SBATCH --job-name=vOTU_clustering_processing
#SBATCH --output=vOTU_clustering_proc.out
#SBATCH --mem=4gb
#SBATCH --time=00:29:00
#SBATCH --cpus-per-task=4
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=regular

clusters=$1 #CheckV aniclust.py STEP5_combined_sequences_clusters.tsv output file
viral_genomes_file=$2 #file with all the viral genomes used as input for the dereplication

viral_genomes_file_path="$(dirname "${viral_genomes_file}")" #extract path
viral_genomes_file_name="$(basename "${viral_genomes_file}")" #extract filename
viral_genomes_file_name="${viral_genomes_file_name%.*}" #extract filename without the extension

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; module list
source activate /home2/p304845/Conda_envs/Seqtk_conda/; conda list

#Extract the names of the predicted viral sequences in the negative control sample
cat $viral_genomes_file | grep Neg_control | cut -c2- > neg_control_IDs.txt

#Execute the python script that outputs Final_viral_sequences_after_dereplication.txt file with only the sequences that do not cluster with negative control sequences
python vOTUs_clustering_processing.py $clusters neg_control_IDs.txt

#Extract from the FASTA file with the contigs those that are not clustered with negative control sequences (after dereplication)
seqtk subseq $viral_genomes_file Final_viral_sequences_after_dereplication.txt > Final_viral_sequences_after_dereplication.fa #full sequences

# Generate a txt and a FASTA file with the representative sequences of each vOTU after the exclusion of contigs from the negative control
cat $clusters | grep -v "$(cat $clusters | grep 'NEGCONTROL' | cut -f1)" | cut -f1 > rep_seqs_vOTUs.txt
seqtk subseq $viral_genomes_file rep_seqs_vOTUs.txt > rep_seqs_vOTUs.fa

# Set permissions and remove intermediate files
rm neg_control_IDs.txt
chmod 440 Final_viral_sequences_after_dereplication.txt Final_viral_sequences_after_dereplication.fa rep_seqs_vOTUs.txt rep_seqs_vOTUs.fa
