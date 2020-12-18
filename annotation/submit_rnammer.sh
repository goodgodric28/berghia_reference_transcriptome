#!/bin/sh                                           

#SBATCH --job-name=rnammer
#SBATCH --nodes=1                             
#SBATCH --partition=shared
#SBATCH --cpus-per-task=8
#SBATCH --time=48:00:00        


Trinotate-Trinotate-v3.2.1/util/rnammer_support/RnammerTranscriptome.pl --transcriptome Berghia_alltisses_onerep_trinity291_transdecoder_cdhit95_noaliens.fasta --path_to_rnammer rnammer
