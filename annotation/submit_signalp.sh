#!/bin/sh                                           

#SBATCH --job-name=signalp
#SBATCH --nodes=1                             
#SBATCH --partition=shared
#SBATCH --cpus-per-task=8
#SBATCH --time=48:00:00        


signalp -format short -gff3 -fasta Berghia_alltisses_onerep_trinity291_transdecoder_cdhit95_noaliens.fasta.transdecoder.pep
