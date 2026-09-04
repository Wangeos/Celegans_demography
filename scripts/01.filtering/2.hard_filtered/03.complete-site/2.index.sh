#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/index.out
#$ -pe smp64 5
#$ -N bcftools_index

bcftools index \
	-t output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.complete.vcf.gz \
	--threads 5
