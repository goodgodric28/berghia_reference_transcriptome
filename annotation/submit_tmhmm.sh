#!/bin/sh                                           

#SBATCH --job-name=tmhmm
#SBATCH --nodes=1                             
#SBATCH --partition=shared
#SBATCH --cpus-per-task=8
#SBATCH --time=48:00:00        

tmhmm --short < Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens.fasta.transdecoder.pep > tmhmm.out
