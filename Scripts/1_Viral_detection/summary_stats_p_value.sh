#!/bin/bash
#SBATCH --job-name=PENTA_results_summary
#SBATCH --output=PENTA_results_summary.out
#SBATCH --mem=1gb
#SBATCH --time=00:20:00
#SBATCH --cpus-per-task=1
#SBATCH --open-mode=truncate
#SBATCH --partition=short

job_id=$1
batch=$2

ls PENTA*${job_id}*.out > list_samples_${batch}.txt
while read f
do
	sample=$(cat $f |grep -a '^-------------------- WORKING WITH' | sed -E 's/^\-+ WORKING WITH //' | sed -E 's/ SAMPLE \-+$//')
	path=/scratch/umcg-llnext/PENTA_CHILIADAL_VIROME
	echo ${sample} | tr '\n' '\t'
	if grep -a -q -F "Step 3 - classify finished" ${f}; then
		echo  "yes" | tr '\n' '\t'
    	else
      		echo "no" | tr '\n' '\t'
    	fi

	if [ -f "${path}/${batch}/${sample}/virome_discovery/VirSorter2/final-viral-combined.fa" ]; then
		echo "yes" | tr '\n' '\t'
		awk 'NR>1 {print $1}' ${path}/${batch}/${sample}/virome_discovery/VirSorter2/final-viral-score.tsv | sed -E 's/\|\|[a-z0-9_]+$//' | sort | uniq | wc -l | tr '\n' '\t'
	else
		echo -e 'no\t-' | tr '\n' '\t'
	fi

	if grep -a -q -F "Done. Thank you for using DeepVirFinder." ${f}; then
      		echo "yes" | tr '\n' '\t'
    	else
      		echo "no" | tr '\n' '\t'
    	fi

	if [[ -f "${path}/${batch}/${sample}/virome_discovery/DeepVirFinder/${sample}_metaspades_contigs.fa_gt10000bp_dvfpred.txt" ]]; then
		echo "yes" | tr '\n' '\t'
		echo $(cat ${path}/${batch}/${sample}/virome_discovery/DeepVirFinder/${sample}_metaspades_contigs.fa_gt10000bp_dvfpred.txt | tail -n +2 | awk '$3 >= 0.95 && $4 < 0.01'| wc -l) | tr '\n' '\t'
    	else
      		echo -e 'no\t-' | tr '\n' '\t'
    	fi
	
	error_lines_number=$(grep -a -i "error" ${f} | grep -v "other system errors; your job may hang, crash, or produce silent" | grep -v "WARNING (theano.gof.compilelock)" | wc -l)
	if [ "${error_lines_number}" -gt 0 ]; then 
		echo "yes" | tr '\n' '\t'
	else
		echo "no" | tr '\n' '\t'
	fi
	echo

done < list_samples_${batch}.txt > ${batch}/${batch}_results_summary.txt

rm list_samples_${batch}.txt
cat ${batch}/${batch}_results_summary.txt | awk '$2 == "yes" && $3 == "yes" && $5 == "yes" && $6 == "yes" && $8 == "no"' | cut -f1 > ${batch}/${batch}_completed_samples.txt
grep -Fxvf  ${batch}/${batch}_completed_samples.txt <(cat ${batch}/${batch}_results_summary.txt | cut -f1) > ${batch}/${batch}_failed_samples.txt

sed -i $'1 i\\\nSample\tVS2_finish\tVS2_file\tVS2_contigs\tDVF_finish\tDVF_file\tDVF_Contigs p<0.01 & score>=0.95 \tErrors' ${batch}/${batch}_results_summary.txt

