#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/index.out
#$ -pe smp64 5
#$ -N bcftools_index

bcftools index \
	-t ../WI.20231213.soft-filter.isotype.rename_chrs.chr_sorted.vcf.gz \
	--threads 5
