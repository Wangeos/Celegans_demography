#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/index.out
#$ -pe smp64 5
#$ -N bcftools_index

bcftools index \
	-t output/WI.20231213.soft-filter.isotype.rename_chrs.vcf.gz \
	--threads 5