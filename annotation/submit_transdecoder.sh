#!/bin/sh                                           

#SBATCH --job-name=transdecoder
#SBATCH --nodes=1         
#SBATCH --partition=shared                    
#SBATCH --cpus-per-task=10
#SBATCH --time=48:00:00                                                                    


TransDecoder.LongOrfs -t Berghia_alltisses_onerep_trinity291_transdecoder_cdhit95_noaliens.fasta
TransDecoder.Predict -t Berghia_alltisses_onerep_trinity291_transdecoder_cdhit95_noaliens.fasta
