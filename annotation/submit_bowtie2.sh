#!/bin/sh                                           

#SBATCH --job-name=bowtie2
#SBATCH --nodes=1                             
#SBATCH --partition=large-shared
#SBATCH --cpus-per-task=20
#SBATCH --mem=240GB
#SBATCH --time=48:00:00                                                                 

module load bowtie2

bowtie2-build Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts

bowtie2 -x Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts -1 Berghia_alltissues_onerep_R1_trimmed.fq.gz -2 Berghia_alltissues_onerep_R2_trimmed.fq.gz -S Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts_bowtie2.sam -p 20
