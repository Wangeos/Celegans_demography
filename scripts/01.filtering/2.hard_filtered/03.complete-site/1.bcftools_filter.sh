#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/bcftools_filter.out
#$ -pe smp64 5
#$ -N bcftools_filter

bcftools filter -i '(N_MISSING=0)' \
	--threads 5 -Oz -o output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.complete.vcf.gz \
	../02.sort_by_sample/SelectVariants/output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.vcf.gz
