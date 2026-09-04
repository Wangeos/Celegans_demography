#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/bwa.out
#$ -pe smp 1
#$ -N bwa
#$ -t 1-11

VAR1=$(ls -F ./ | grep "xa" | sed -n ${SGE_TASK_ID}p)

bwa aln -R 1000000 -O 3 -E 3 \
	~/raw_cae/Celegans/CaeNDR/20231213/reference/20231213_c_elegans_WS283.genome.fa \
	${VAR1} > output/${VAR1}.sai
bwa samse -f output/${VAR1}.sam \
	~/raw_cae/Celegans/CaeNDR/20231213/reference/20231213_c_elegans_WS283.genome.fa \
	 output/${VAR1}.sai ${VAR1}
