#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/bcftools_sort.out
#$ -pe smp64 5
#$ -N bcftools_sort

bcftools sort \
	-Oz -o output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sorted.vcf.gz \
	~/analyses_cae/Celegans/CaeNDR/20231213/soft_filtered/filtering/01.rename_chrs/output/WI.20231213.soft-filter.isotype.rename_chrs.vcf.gz
