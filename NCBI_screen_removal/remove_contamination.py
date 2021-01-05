#!/usr/bin/env python3
#
# This file is a python script to remove/trim vector/contamination sequences from NCBI TSA submission transcriptome assemblies
#
# Author: Jessica A. Goodheart, UC San Diego
# Last updated: 5 January 2021
#
# Usage: python3 remove_contamination.py <FILE>.fasta Contamination.txt

import sys
from Bio import SeqIO

# First argument fasta file, second is Contamination.txt file from NCBI
fa_file = sys.argv[1]
contamination_file = sys.argv[2]

count_rm = 0
count_cut = 0
seq_nums_rm = []
seq_nums_cut = []
seq_cut_start = []
seq_cut_end = []

# Identify sequences to be trimmed and removed
for i in open(contamination_file,'r'):
    if "TRINITY_DN" in i:
        if ".." in i:
            count_cut += 1
            seq_num = i.split('\t')[0]
            seq_cut_range = i.split('\t')[2]
            if "," in seq_cut_range:
                seq_cut_range2 = seq_cut_range.split(',')[0]
                seq_cut_start2 = int(seq_cut_range2.split('..')[0])
                seq_cut_end2 = int(seq_cut_range2.split('..')[1])
                seq_cut_range3 = seq_cut_range.split(',')[1]
                seq_cut_start3 = int(seq_cut_range3.split('..')[0])
                seq_cut_end3 = int(seq_cut_range3.split('..')[1])

                seq_nums_cut.append(seq_num)
                seq_cut_start.append(seq_cut_start2)
                seq_cut_end.append(seq_cut_end2)

                seq_nums_cut.append(seq_num)
                seq_cut_start.append(seq_cut_start3)
                seq_cut_end.append(seq_cut_end3)

                #print(str(seq_nums_cut) + " " + str(seq_cut_start2) + " " + str(seq_cut_end2) + " " + str(seq_cut_start3) + " " + str(seq_cut_end3))
            else:
                seq_cut_start1 = int(seq_cut_range.split('..')[0])
                seq_cut_end1 = int(seq_cut_range.split('..')[1])

                seq_nums_cut.append(seq_num)
                seq_cut_start.append(seq_cut_start1)
                seq_cut_end.append(seq_cut_end1)
                #print(str(seq_nums_cut) + " " + str(seq_cut_start) + " " + str(seq_cut_end))
        else:
            count_rm += 1
            seq_num = i.split('\t')[0]
            seq_nums_rm.append(seq_num)
            #print(seq_nums_rm)

# Parse and trim fasta file
fasta_sequences = SeqIO.parse(open(fa_file),'fasta')

with open("filtered_sequences.fasta", "w") as out_file:
    for fasta in fasta_sequences:
        name, sequence = fasta.id, str(fasta.seq)
        if name in seq_nums_rm:
            continue
        elif seq_nums_cut.count(name) > 1:
            # Get index numbers
            indices = [i for i, x in enumerate(seq_nums_cut) if x == name]

            #Remove ranges
            for i in indices[::-1]:
                start = seq_cut_start[i]-1
                end = seq_cut_end[i]-1

                if start == 0:
                    new_fasta = sequence[end + 1: :]
                    sequence = new_fasta
                else:
                    new_fasta = sequence[0 : start : ] + sequence[end + 1 : :]
                    sequence = new_fasta
            if len(sequence) < 200:
                print(name + " too short post-trimming.")
                continue
            else:
                out_file.write(">" + name + "\n" + sequence + "\n")
        elif seq_nums_cut.count(name) == 1:
            ind = seq_nums_cut.index(name)
            start = seq_cut_start[ind]-1
            end = seq_cut_end[ind]-1

            if start == 0:
                new_fasta = sequence[end + 1: :]
                sequence = new_fasta
                #print(name + "\n" + sequence + "\n" + str(start) + "\n" + str(end))
            else:
                new_fasta = sequence[0 : start : ] + sequence[end + 1 : :]
                sequence = new_fasta
                #print(name + "\n" + sequence + "\n" + str(start) + "\n" + str(end))

            if len(sequence) < 200:
                print(name + " too short post-trimming.")
                continue
            else:
                out_file.write(">" + name + "\n" + sequence + "\n")
        else:
            out_file.write(">" + name + "\n" + sequence + "\n")

print(str(count_rm) + " sequences removed.")
print(str(count_cut) + " sequences trimmed.")




'''
                    seq = line.split(':')[0]
                    print(seq)
                    com = 'sed -i -e \'s/' + line + '/>' + seq + '/g\' ' + file
                    subprocess.run(com, shell='TRUE')
    elif "Code(MIN_LENGTH)" in i:
        seq = i.split(',')[2].replace(' Sequence-id: ','')
        com = 'sed -i -e \'/' + seq + ':/{N;d;}\' ' + file
        #print(com)
        subprocess.run(com, shell='TRUE')
    elif "Code(VECTOR_MATCH)" in i:
        seq = i.split(',')[2].replace(' Sequence-id: ','')
        interval = i.split(',')[3].replace(' Interval: ','')
        start = int(interval.split('..')[0])
        end = int(interval.split('..')[1])
        #print(seq, interval, str(start), str(end))
        with open(file,'r+') as fasta:
            for l in fasta:
                if seq in l:
                    sequence = seq.join(islice(fasta, 1))
                    print(sequence)
                    if start-1 == 0:
                        sequence_mod = sequence[end-1+1::]
                    else:
                        sequence_mod = sequence[0:start-1:] + sequence[end::]
                    com = 'sed -i -e \'s/' + sequence + '/>' + sequence_mod + '/g\' ' + file
                    subprocess.run(com, shell='TRUE')
    else:
        print(i)
'''
