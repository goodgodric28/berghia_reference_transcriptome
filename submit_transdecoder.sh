#!/bin/sh                                           

#SBATCH --job-name=transdecoder
#SBATCH --nodes=1         
#SBATCH --partition=shared                    
#SBATCH --cpus-per-task=10
#SBATCH --time=48:00:00                                                                    


TransDecoder.LongOrfs -t Berghia_alltissues_onerep_trinity291.fasta
TransDecoder.Predict -t Berghia_alltissues_onerep_trinity291.fasta
