#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/gen_mask.out
#$ -pe smp 5
#$ -N gen_mask

seqbility-20091110/gen_mask \
	-l 35 -r 0.5 output/rawMask_35.fa > output/mask_35_50.fa
