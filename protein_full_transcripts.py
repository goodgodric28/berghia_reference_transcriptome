#!/usr/bin/env python3
#
# This file is a python script for pulling out full transcripts from assemblies using TransDecoder/CD-HIT fasta files as input
# Dependencies: Python 3, Biopython
#
# Python wrapper written by: Jessica A. Goodheart
# Last Modified: 16 May 2020

from Bio import SeqIO
import argparse

parser = argparse.ArgumentParser(description='This script pulls out full transcripts from assemblies using TransDecoder/CD-HIT fasta files as input')
parser.add_argument('full', help='provide path to full FASTA')
parser.add_argument('cds', help='provide path to cds FASTA')
args = parser.parse_args()
full = args.full
cds = args.cds


######### Begin subsetting FASTA ###########
# Parse cds (subset) FASTA file
sub = []
for record in SeqIO.parse(str(args.cds), "fasta"):
    sub.append(record.id.split(".")[0])
sub = list(dict.fromkeys(sub))

# Parse full FASTA file and copy transcripts to new output file
output = open("full_transcripts_subset.fasta","w+")
for record in SeqIO.parse(args.full, "fasta"):
    if record.id in sub:
        output.write(">" + str(record.id) + "\n" + str(record.seq) + "\n")
