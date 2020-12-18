#!/bin/sh                                           

#SBATCH --job-name=trinity_norm
#SBATCH --nodes=1                             
#SBATCH --cpus-per-task=32
#SBATCH --mem=500GB
#SBATCH --partition=large-shared
#SBATCH --time=48:00:00     


insilico_read_normalization.pl --seqType fq --JM 500G --left Berghia_alltissues_onerep_R1_trimmed.fq.gz --right Berghia_alltissues_onerep_R2_trimmed.fq.gz --max_cov 100 --CPU 32 --PARALLEL_STATS --pairs_together
