#!/bin/sh

#SBATCH --job-name=blast
#SBATCH --nodes=1
#SBATCH --cpus=2
#SBATCH --partition=shared
#SBATCH --time=48:00:00

blastn -task blastn -reward 1 -penalty -5 \
    -gapopen 3 -gapextend 3 -dust yes -soft_masking true \
    -evalue 700 -searchsp 1750000000000 -outfmt 6 \
    -db UniVec_Core \
    -query Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta  \
    -num_threads 2 -out Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta.fmt6.out


/home/sluglife/programs/trinity_community_codebase/trim_adapters.pl \
   -infile Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta  \
   -outfile Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts_novectors.fasta \
   -scanfile Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta.fmt6.out \
   -adapters "NGB00593:30 NGB00149:45 NGB00871:32 NGB00847:64 NGB00853:64 NGB00568:30 NGB00855:64 NGB00858:64 NGB00568:30 NGB00596:52 NGB00864:66 NGB00761:65" \
   -minlen 200 \
   -relaxed
