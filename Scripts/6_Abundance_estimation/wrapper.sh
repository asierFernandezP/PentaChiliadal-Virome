#!/bin/bash

BATCH="$1"  # Get the Batch 

for FILE in "${@:2}"; do
  file_name="$(basename "${FILE}")" # extract filename
  sbatch \
    --output ${file_name}_CheckV.out \
    --job-name ${file_name}_CheckV \
    Read_mapping_BED.sh ${FILE} ${BATCH} Bowtie2_index rep_seqs_vOTUs.fa 
done
