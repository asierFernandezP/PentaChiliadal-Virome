#!/bin/bash

for FILE in $@; do
  file_name="$(basename "${FILE}")" #extract filename
	sbatch \
		--output ${file_name}_CheckV.out \
		--job-name ${file_name}_CheckV \
		Read_mapping_BED.sh ${FILE} Bowtie2_index rep_seqs_vOTUs.fa
done
