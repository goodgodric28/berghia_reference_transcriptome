#!/bin/sh                                           

#SBATCH --job-name=blastx
#SBATCH --nodes=1                             
#SBATCH --partition=shared
#SBATCH --cpus-per-task=10
#SBATCH --time=48:00:00 


blastx -query Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95.fasta -db ai_w_symbionts.fa -outfmt 6 -max_target_seqs 1000 -seg yes -evalue 0.001 -out Berghia_alltisses_onerep_trinity291_transdecoder_cdhit95_aiplussymbionts.blastx -num_threads 10
