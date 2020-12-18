#!/bin/sh                                           

#SBATCH --job-name=blastp
#SBATCH --nodes=1                             
#SBATCH --partition=shared
#SBATCH --cpus-per-task=8
#SBATCH --time=48:00:00        

blastp -query Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens.fasta.transdecoder.pep -db /home/sluglife/programs/Trinotate-Trinotate-v3.2.1/admin/uniprot_sprot.pep -num_threads 8 -max_target_seqs 1 -outfmt 6 -evalue 1e-3 > blastp.outfmt6
