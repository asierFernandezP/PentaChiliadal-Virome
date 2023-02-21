#!/bin/bash
#SBATCH --job-name=Contig_clustering_plasmid_processing
#SBATCH --output=Clustering_plasmid_proc.out
#SBATCH --mem=4gb
#SBATCH --time=00:29:00
#SBATCH --cpus-per-task=4
#SBATCH --open-mode=truncate
#SBATCH --partition=short

clusters=$1 #CheckV aniclust.py all_predicted_viral_contigs_clusters.tsv output file
plasmids=$2 #geNomad all_predicted_viral_contigs_plasmid_summary.tsv output file
contig_file=$3 #File withh all the predicted viral contigs from STEP1

contig_file_path="$(dirname "${contig_file}")" #extract path
contig_file_name="$(basename "${contig_file}")" #extract filename
contig_file_name="${contig_file_name%.*}" #extract filename without the extension

#Load Python module
ml Python/3.9.6-GCCcore-11.2.0 seqtk; ml list

#Process geNomad output file to get a file with the names of identified plasmid sequences (1 per row)
awk 'NR>1' $plasmids | cut -f1 | sort > Plasmid_sequences.txt
#Execute the python script that outputs viral_sequences.txt file with only the viral contigs
python Contig_clustering_processing.py $clusters Plasmid_sequences.txt

#Extract from the FASTA file with the contigs those that are predicted to be viral (after dereplication)
seqtk subseq $contig_file Viral_sequences_no_plasmids.txt > all_predicted_viral_sequences_no_plasmids.fa

#Extract from the FASTA file with the contigs those that are predicted to be plasmids (according to geNomad results)
seqtk subseq $contig_file Plasmid_sequences.txt > all_predicted_plasmids.fa
