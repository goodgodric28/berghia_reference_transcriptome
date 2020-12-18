#!/bin/sh                                           

#SBATCH --job-name=hmmer
#SBATCH --nodes=1                             
#SBATCH --partition=shared
#SBATCH --cpus-per-task=12
#SBATCH --time=48:00:00       

hmmscan --cpu 12 --domtblout TrinotatePFAM.out Pfam-A.hmm Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens.fasta.transdecoder.pep > pfam.log
