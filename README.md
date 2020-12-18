This repository contains the scripts and commands for the pipeline used to construct the *Berghia stephanieae* reference transcriptome (Masterson et al., in prep.; link will be added when available). The commands are included below, and the submission scripts in this repository include information on the requested resources for each job.

# Quality Control and Merging

To merge read files (perform for forward and reverse, R1 and R2):
```
cat Mix_S51_L003_R1_001_paired.fastq.gz Juvenile_S50_L003_R1_001_paired.fastq.gz Bb904dil_S17_R1_merged.fastq.gz OT1_CRRA200005335-1a_HV572DSXX_L1_1.fq.gz R4_CRRA200005366-1a_HV572DSXX_L1_1.fq.gz P1_CRRA200005351-1a_HV572DSXX_L1_1.fq.gz D1_CRRA200005347-1a_HV572DSXX_L1_1.fq.gz F4_CRRA200005358-1a_HV572DSXX_L1_1.fq.gz TL3_CRRA200005361-1a_HV572DSXX_L1_1.fq.gz > Berghia_alltissues_onerep_R1.fq 

cat Mix_S51_L003_R2_001_paired.fastq.gz	Juvenile_S50_L003_R2_001_paired.fastq.gz Bb904dil_S17_R2_merged.fastq.gz OT1_CRRA200005335-1a_HV572DSXX_L1_2.fq.gz R4_CRRA200005366-1a_HV572DSXX_L1_2.fq.gz P1_CRRA200005351-1a_HV572DSXX_L1_2.fq.gz D1_CRRA200005347-1a_HV572DSXX_L1_2.fq.gz F4_CRRA200005358-1a_HV572DSXX_L1_2.fq.gz TL3_CRRA200005361-1a_HV572DSXX_L1_2.fq.gz > Berghia_alltissues_onerep_R2.fq
```

Performed with [FASTP](https://github.com/OpenGene/fastp) version 0.20.0:
```
fastp --in1 Berghia_alltissues_onerep_R1.fq --out1 Berghia_alltissues_onerep_R1_trimmed.fq --in2 Berghia_alltissues_onerep_R2.fq --out2 Berghia_alltissues_onerep_R2_trimmed.fq
```

# Trimming and Assembly

## Normalization

Performed read normalization in advance of assembly due to computational constraints (with [Trinity](https://github.com/trinityrnaseq/trinityrnaseq/wiki) 2.9.1):
```
insilico_read_normalization.pl --seqType fq --JM 500G --left Berghia_alltissues_onerep_R1_trimmed.fq.gz --right Berghia_alltissues_onerep_R2_trimmed.fq.gz --max_cov 100 --CPU 32 --PARALLEL_STATS --pairs_together
```

## Assembly 

Performed with Trinity 2.9.1:
```
Trinity --seqType fq --max_memory 200G --left Berghia_alltissues_onerep_R1_trimmed.fq.gz.normalized_K25_maxC100_minC0_maxCV10000.fq --right Berghia_alltissues_onerep_R2_trimmed.fq.gz.normalized_K25_maxC100_minC0_maxCV10000.fq --CPU 24 --bflyHeapSpaceMax 10G --trimmomatic --output trinity_out_dir_291 --full_cleanup --no_normalize_reads --verbose --FORCE
```

# Transcript Filtering and Clustering

## ORF Detection

Performed with [Transdecoder](https://github.com/TransDecoder/TransDecoder/wiki) version 5.5.0:
```
TransDecoder.LongOrfs -t Berghia_alltissues_onerep_trinity291.fasta
TransDecoder.Predict -t Berghia_alltissues_onerep_trinity291.fasta
```

## Trascript Clustering

Performed with [CD-HIT](http://weizhongli-lab.org/cd-hit/) (version 4.8.1):
```
cd-hit-est -i Berghia_alltissues_onerep_trinity291.fasta.transdecoder.cds -o Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95.fasta -c 0.95 -n 11 -M 96000 -T 24
```

## Contamination Filtering

Blast against AI and Symbiont database with [alien_index](https://github.com/josephryan/alien_index):
```
blastx -query Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95.fasta -db ai_w_symbionts.fa -outfmt 6 -max_target_seqs 1000 -seg yes -evalue 0.001 -out Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_aiplussymbionts.blastx -num_threads 10
```

Identify sequences with alien_index:
```
alien_index --blast=Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_aiplussymbionts.blastx --alien_pattern=ALIEN_ > Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_aiplussymbionts.alien_index
```

Subset to only those seqs with AI > 45:
```
head -1856 Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_aiplussymbionts.alien_index > Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_aiplussymbionts_subset.alien_index
```

Remove aliens with alien_index:
```
remove_aliens Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_aiplussymbionts_subset.alien_index Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95.fasta > Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens.fasta
```

# Final Transcriptome

Transcripts of final sequences pulled from original transcriptome with custom script protein_full_transripts.py (creates output file - full_transcripts_subset.fasta):
```
protein_full_transcripts.py Berghia_alltissues_onerep_trinity291.fasta  Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens.fasta
```

# Transcriptome Quality Assessments

## BUSCO

Performed with [BUSCO](https://busco.ezlab.org/) v.4:
```
busco -m transcriptome -i Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta -l mollusca_odb10 -o Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts_mollusca.v4.0.5 -f -c 8

busco -m transcriptome -i Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta -l metazoa_odb10 -o Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts_metazoa.v4.0.5 -f -c 8
```

## Completeness Statistics

Performed with script from Goodheart & Waegele 2020 ([repository](https://github.com/goodgodric28/phylliroe_phylogenomics)), calculate_basic_denovo_transcriptome_assembly_statistics.pl:
```
calculate_basic_denovo_transcriptome_assembly_statistics.pl Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta
```

## Read mapping

Performed with [Bowtie 2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml) (version 2.3.4.3):
```
bowtie2-build Berghia_alltisses_onerep_trinity291.fasta.transdecoder_cdhit95_noaliens.fasta Berghia_alltisses_onerep_trinity291.fasta.transdecoder_cdhit95_noaliens

bowtie2 -x Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta -1 Berghia_alltissues_onerep_R1_trimmed.fq.gz -2 Berghia_alltissues_onerep_R2_trimmed.fq.gz -S Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts_bowtie2.sam -p 8
```

# Transcriptome Annotation

First generated gene_to_trans_map with modified get_Trinity_gene_to_trans_map.pl script:
```
get_Trinity_gene_to_trans_map.pl Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta > Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta.gene_trans_map
```

Used the [Trinotate Annotation pipeline](https://github.com/Trinotate/Trinotate.github.io/wiki/Software-installation-and-data-required) (BLAST+ 2.2.31, SignalP version 5.0b, tmhmm-2.0c, rnammer 1.2, TransDecoder v.5.5.0, HMMER 3.1b2), instructions found [here](https://github.com/Trinotate/Trinotate.github.io/wiki/Software-installation-and-data-required):
```
TransDecoder.LongOrfs -t Berghia_alltisses_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta
TransDecoder.Predict -t Berghia_alltisses_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta

blastp -query Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta.transdecoder.pep -db /home/sluglife/programs/Trinotate-Trinotate-v3.2.1/admin/uniprot_sprot.pep -num_threads 8 -max_target_seqs 1 -outfmt 6 -evalue 1e-3 > blastp.outfmt6

blastx -query Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta -db /home/sluglife/programs/Trinotate-Trinotate-v3.2.1/admin/uniprot_sprot.pep -num_threads 8 -max_target_seqs 1 -outfmt 6 -evalue 1e-3 > blastx.outfmt6

hmmscan --cpu 12 --domtblout TrinotatePFAM.out Pfam-A.hmm Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta.transdecoder.pep > pfam.log

signalp -format short -gff3 -fasta Berghia_alltisses_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta.transdecoder.pep

tmhmm --short < Berghia_alltissues_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta.transdecoder.pep > tmhmm.out

Trinotate-Trinotate-v3.2.1/util/rnammer_support/RnammerTranscriptome.pl --transcriptome Berghia_alltisses_onerep_trinity291_transdecoder_cdhit95_noaliens_fulltranscripts.fasta --path_to_rnammer rnammer
```

Then loaded the results files into the appropriate SQLite DB using [Trinotate](https://github.com/Trinotate/Trinotate.github.io/wiki/Loading-generated-results-into-a-Trinotate-SQLite-Database-and-Looking-the-Output-Annotation-Report).

# Citations

Masterson P, Johnston H, Taraporevala N, Goodheart JA, Batzel G, Whitesel C, Barone V and Lyons DC. In Preparation. Scalable Spiralian: Establishing the Nudibranch *Berghia stephanieae* (Valdes, 2005) as a new model for unwinding molluscan development.

Goodheart JA and Waegele H. 2020. Phylogenomic analysis and morphological data suggest left-right swimming behavior evolved prior to the origin of the pelagic Phylliroidae (Gastropoda: Nudibranchia). Organisms, Diversity, and Evolution. doi: 10.1007/s13127-020-00458-9.
