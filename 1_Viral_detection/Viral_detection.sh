#!/bin/bash
#SBATCH --job-name=PENTA_LLNEXT
#SBATCH --output=PENTA_LLNEXT_%A_%a.out
#SBATCH --mem=16gb
#SBATCH --time=09:59:00
#SBATCH --cpus-per-task=8
#SBATCH --export=NONE
#SBATCH --get-user-env=L

sample_dir=$1 #directory with the metaspades contigs
sample_list=${sample_dir}$2 #file with the list of all metaspades_contigs samples in the directory
SAMPLE_ID=$(sed "${SLURM_ARRAY_TASK_ID}q;d" ${sample_list} | cut -d "_" -f1)

echo '-------------------- WORKING WITH '${SAMPLE_ID}' SAMPLE --------------------'

echo '---- RUNNING VirSorter2 WITH '${SAMPLE_ID}' SAMPLE ----'

mkdir -p ${sample_dir}${SAMPLE_ID}/virome_discovery

# Clean environment, load modules and activate conda environment
module purge; ml Anaconda3; module list; conda activate /home2/umcg-llnext/vs2; conda list

# Run VirSorter2
virsorter run \
	-w ${sample_dir}${SAMPLE_ID}/virome_discovery/VirSorter2 \
	-i ${sample_dir}${SAMPLE_ID}_metaspades_contigs.fa \
	--min-length 10000 \
        --keep-original-seq \
	--include-groups "dsDNAphage,NCLDV,RNA,ssDNA,lavidaviridae" \
        -j ${SLURM_CPUS_PER_TASK} \
        --use-conda-off \
	all 

rm -r ${sample_dir}${SAMPLE_ID}/virome_discovery/VirSorter2/iter-0
rm -r ${sample_dir}${SAMPLE_ID}/virome_discovery/VirSorter2/log
rm ${sample_dir}${SAMPLE_ID}/virome_discovery/VirSorter2/config.yaml

conda deactivate

echo '---- RUNNING DeepVirFinder WITH '${SAMPLE_ID}' SAMPLE ----'

mkdir -p ${sample_dir}${SAMPLE_ID}/virome_discovery

# Clean environment, load modules and activate python environment
module purge; ml Python/3.6.4-foss-2018a; module list; source /data/umcg-llnext/python_venvs/DVF_venv/bin/activate; pip freeze 
# export BLAS for Theano
export THEANO_FLAGS=blas.ldflags="-L/data/umcg-llnext/python_venvs/DVF_venv/lib64/python3.6/site-packages/numpy.libs/ -lblas"

# Run DeepVirFinder
python3 /data/umcg-llnext/python_venvs/DVF_venv/DeepVirFinder/dvf.py \
	-i ${sample_dir}${SAMPLE_ID}_metaspades_contigs.fa \
	-o ${sample_dir}${SAMPLE_ID}/virome_discovery/DeepVirFinder \
	-l 10000 

deactivate 
