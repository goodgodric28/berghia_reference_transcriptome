#!/bin/sh                                                  

#SBATCH --job-name=busco
#SBATCH --nodes=1                             
#SBATCH --cpus=8
#SBATCH --partition=shared
#SBATCH --time=48:00:00         

busco -m transcriptome -i Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta -l mollusca_odb10 -o Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts_mollusca.v4.0.5 -f -c 8
