#!/bin/bash

for FILE in $@; do
  file_name="$(basename "${FILE}")" #extract filename
	sbatch \
		--output ./out/${file_name}_CheckV.out \
		--job-name ${file_name}_CheckV \
		CheckV_contamination_completeness.sh ${FILE} /scratch/umcg-afernandez/${file_name}_CheckV_result
done
