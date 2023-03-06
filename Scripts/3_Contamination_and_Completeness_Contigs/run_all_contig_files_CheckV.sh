#!/bin/bash

mkdir /scratch/umcg-afernandez/split_CheckV

for FILE in $@; do
  file_name="$(basename "${FILE}")" #extract filename
	sbatch \
		--output ./out/${file_name}_CheckV.out \
		--job-name ${file_name}_CheckV \
		CheckV_contamination_completeness.sh ${FILE} /scratch/umcg-afernandez/split_CheckV/${file_name}_CheckV
done
