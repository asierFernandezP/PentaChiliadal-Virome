#!/bin/bash
#SBATCH --job-name=PENTA_viral_sorting
#SBATCH --output=PENTA_viral_sorting.out
#SBATCH --mem=8gb
#SBATCH --time=89:59:00
#SBATCH --cpus-per-task=8
#SBATCH --open-mode=truncate
#SBATCH --partition=regular

module load sektq
completed_samples_dir=$1
MSP_contigs_dir=$2

ls $completed_samples_dir > list_samples_completed.txt

# For each completed sample, filter VS2 and DVF selected contigs and create a combined file
while read i
do
	sample=$i
	results_path=virome_discovery/processed_results
	mkdir $completed_samples_dir/$sample/$results_path; awk 'NR>1 {print $0}' $completed_samples_dir/$sample/virome_discovery/DeepVirFinder/${sample}_metaspades_contigs.fa_gt10000bp_dvfpred.txt | awk '$3 >= 0.95 && $4 < 0.01' | cut -f1 | sed "s/^/${sample}_/" > $completed_samples_dir/$sample/$results_path/${sample}_DVF_contigs.txt
	awk 'NR>1 {print $1}' $completed_samples_dir/$sample/virome_discovery/VirSorter2/final-viral-score.tsv | sed -E 's/\|\|[a-z0-9_]+$//'| sort | uniq | sed "s/^/${sample}_/" > $completed_samples_dir/$sample/$results_path/${sample}_VS2_contigs.txt
	cat $completed_samples_dir/$sample/$results_path/${sample}_VS2_contigs.txt $completed_samples_dir/$sample/$results_path/${sample}_DVF_contigs.txt | sort | uniq > $completed_samples_dir/$sample/$results_path/${sample}_combined_contigs.txt
  
# To generate the FASTA file with the selected contigs, linearize them, get the sequence, and return to normal FASTA format with sample name added to contig name
seqtk subseq $MSP_contigs_dir/${sample}_metaspades_contigs.fa $completed_samples_dir/$sample/$results_path/${sample}_combined_contigs.txt > $completed_samples_dir/$sample/$results_path/${sample}_predicted_viral_contigs.fa

done	< list_samples_completed.txt

cat $(find $completed_samples_dir -type f -name "*_predicted_viral_contigs.fa") > all_predicted_viral_contigs.fa
cat $(find $completed_samples_dir -type f -name "*_VS2_contigs.txt") > all_VS2_viral_contigs.txt
cat $(find $completed_samples_dir -type f -name "*_DVF_contigs.txt") > all_DVF_viral_contigs.txt
cat $(find $completed_samples_dir -type f -name "*_combined_contigs.txt") > all_predicted_viral_contigs.txt
rm $(find $completed_samples_dir -type f -name "*_linear_metaspades_contigs.fa")
rm list_samples_completed.txt

#Generate the metadata file for each contig
touch metadata_predicted_viral_contigs.txt
while read c
do
	sample=$(echo $c | sed 's/_.*//')
	contig_name=$(echo $c | sed 's/^[^_]*_//')
	full_contig_name=$c

	echo $full_contig_name | tr '\n' '\t' #contig_name
	# Get which tool identified the contig (meeting the score / p-value requirements)
	# Get remaining metadata information from VS2 and VDF outputs
	if  grep -aqF "$full_contig_name" all_VS2_viral_contigs.txt  &&  grep -aqF "$full_contig_name" all_DVF_viral_contigs.txt; then
		echo "both" | tr '\n' '\t'
		cat $completed_samples_dir/$sample/virome_discovery/VirSorter2/final-viral-boundary.tsv | grep -aF $contig_name | cut -f4,5,14,19,26-28 | tr '\n' '\t'
		cat $completed_samples_dir/$sample/virome_discovery/VirSorter2/final-viral-score.tsv | grep -aF $contig_name | cut -f11,12 | tr '\n' '\t'
		cat $completed_samples_dir/$sample/virome_discovery/DeepVirFinder/${sample}_metaspades_contigs.fa_gt10000bp_dvfpred.txt | grep -aF $contig_name | cut -f2-4  

	elif ! grep -aqF "$full_contig_name" all_VS2_viral_contigs.txt; then
		echo "DVF" | tr '\n' '\t'
		seq 9 | sed "c -" | tr '\n' '\t'
		cat $completed_samples_dir/$sample/virome_discovery/DeepVirFinder/${sample}_metaspades_contigs.fa_gt10000bp_dvfpred.txt | grep -aF $contig_name | cut -f2-4 
	
#This condition is met when a specific contig has been identified also by DVF, but it does not meet our score or p-value threshold
	elif grep -aqF "$full_contig_name" all_VS2_viral_contigs.txt && grep -aqF "$contig_name" $completed_samples_dir/$sample/virome_discovery/DeepVirFinder/${sample}_metaspades_contigs.fa_gt10000bp_dvfpred.txt; then
		echo "VS2" | tr '\n' '\t'
		cat $completed_samples_dir/$sample/virome_discovery/VirSorter2/final-viral-boundary.tsv | grep -aF $contig_name | cut -f4,5,14,19,26-28 | tr '\n' '\t'
		cat $completed_samples_dir/$sample/virome_discovery/VirSorter2/final-viral-score.tsv | grep -aF $contig_name | cut -f11,12 | tr '\n' '\t'
		cat $completed_samples_dir/$sample/virome_discovery/DeepVirFinder/${sample}_metaspades_contigs.fa_gt10000bp_dvfpred.txt | grep -aF $contig_name | cut -f2-4 
	
	else
		echo "VS2" | tr '\n' '\t'
		cat $completed_samples_dir/$sample/virome_discovery/VirSorter2/final-viral-boundary.tsv | grep -aF $contig_name | cut -f4,5,14,19,26-28 | tr '\n' '\t'
		cat $completed_samples_dir/$sample/virome_discovery/VirSorter2/final-viral-score.tsv | grep -aF $contig_name | cut -f11,12 | tr '\n' '\t'
		seq 3 | sed "c -" 
	fi
done	< all_predicted_viral_contigs.txt >> metadata_viral_contigs.txt

# Reorder columns and add header
cat metadata_viral_contigs.txt | awk -v OFS="\t" '{print $1,$12,$2,$8,$9,$13,$14,$6,$7,$5,$3,$4,$10,$11}'> metadata_predicted_viral_contigs.txt
sed -i $'1 i\\\ncontig\tlenght\ttool\tviral_group\tshape\tdvf_score\tdvf_pvalue\tvs2_score\thallmark_cnt\tpartial\ttrim_bp_start\ttrim_bp_end\tviral\tcelullar' metadata_predicted_viral_contigs.txt 
rm metadata_viral_contigs.txt

# Keep in a file the names of viral contigs classified as RNA viruses
cat metadata_predicted_viral_contigs.txt |  grep -F RNA | cut -f1 > predicted_RNA_viruses.txt
