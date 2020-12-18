#!/bin/sh                                           

#SBATCH --job-name=trinity
#SBATCH --nodes=1                             
#SBATCH --cpus-per-task=24
#SBATCH --partition=large-shared
#SBATCH --mem=200GB
#SBATCH --time=48:00:00        

module load bowtie2
module load gnu/7.2.0

Trinity --seqType fq --max_memory 200G --left Berghia_alltissues_onerep_R1_trimmed.fq.gz.normalized_K25_maxC100_minC0_maxCV10000.fq --right Berghia_alltissues_onerep_R2_trimmed.fq.gz.normalized_K25_maxC100_minC0_maxCV10000.fq --CPU 24 --bflyHeapSpaceMax 10G --trimmomatic --output trinity_out_dir_291 --full_cleanup --no_normalize_reads --verbose --FORCE
