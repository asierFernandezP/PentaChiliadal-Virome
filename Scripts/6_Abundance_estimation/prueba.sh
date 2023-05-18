#!/bin/bash
#SBATCH --mem=80gb
#SBATCH --time=00:59:00
#SBATCH --cpus-per-task=16
#SBATCH --export=NONE
#SBATCH --get-user-env=L
#SBATCH --partition=regular

SAMPLE_ID="$(basename "$1")"
BATCH=$2
Bowtie_DB=$3 # Path to Bowtie index generated from the representative sequences
viral_rep_seqs=$4 # FASTA file with all the vOTUs representative viral sequences

# Create directories if they don't exist
if [[ ! -d ${BATCH}/Alignment_results ]]; then
    mkdir ${BATCH}/Alignment_results
fi

if [[ ! -d ${BATCH}/Breadth_coverage_results ]]; then
    mkdir ${BATCH}/Breadth_coverage_results
fi

echo '-------------------- WORKING WITH '${SAMPLE_ID}' SAMPLE --------------------'

# Clean environment, load modules
module purge; module load Python/3.9.6-GCCcore-11.2.0 Bowtie2 SAMtools BEDTools; module list

# Map the reads
bowtie2 \
	--very-sensitive \
	-x $Bowtie_DB/Viral_rep_seqs_DB \
	-1 ${BATCH}/${SAMPLE_ID}*_kneaddata_cleaned_pair_1.fastq.gz \
	-2 ${BATCH}/${SAMPLE_ID}*_kneaddata_cleaned_pair_2.fastq.gz \
	--no-unal \
	--threads ${SLURM_CPUS_PER_TASK} \
	-S ${BATCH}/${SAMPLE_ID}_all_vir_alignments.sam
	


samtools view \
	-S ${BATCH}/${SAMPLE_ID}_all_vir_alignments.sam \
	-b \
	-o ${BATCH}/${SAMPLE_ID}_all_vir_alignments.bam

samtools sort \
	${BATCH}/${SAMPLE_ID}_all_vir_alignments.bam \
	-o ${BATCH}/Alignment_results/${SAMPLE_ID}.sorted.bam \
	-@ $((${SLURM_CPUS_PER_TASK}-1))

samtools index \
	-@ $((${SLURM_CPUS_PER_TASK}-1)) \
	${BATCH}/Alignment_results/${SAMPLE_ID}.sorted.bam

# Get coverage final tables 
bedtools coverage \
	-a $Bowtie_DB/Viral_rep_seqs_DB.bed \
	-b ${BATCH}/Alignment_results/${SAMPLE_ID}.sorted.bam \
	> ${BATCH}/Breadth_coverage_results/${SAMPLE_ID}.coverage.txt

# Remove intermediate files
rm ${BATCH}/${SAMPLE_ID}_all_vir_alignments.sam ${BATCH}/${SAMPLE_ID}_all_vir_alignments.bam
