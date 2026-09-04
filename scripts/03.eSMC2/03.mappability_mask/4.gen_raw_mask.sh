#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/gen_raw_mask.out
#$ -pe smp 5
#$ -N gen_raw_mask

gzip -dc output/xa.sam.gz | \
	seqbility-20091110/gen_raw_mask.pl > \
	output/rawMask_35.fa
