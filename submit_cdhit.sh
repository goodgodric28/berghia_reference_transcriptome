#!/bin/sh                                           

#SBATCH --job-name=cd-hit
#SBATCH --nodes=1                             
#SBATCH --cpus-per-task=24
#SBATCH --mem=96GB
#SBATCH -A ddp370
#SBATCH --time=48:00:00                                                                    

source /home/sluglife/.bash_profile

cd-hit-est -i Trinity-GG_alltissues.fasta.transdecoder.cds -o Berghia_TrinityGG_transdecoderall_cdhit95 -c 0.95 -n 11 -M 96000 -T 24
