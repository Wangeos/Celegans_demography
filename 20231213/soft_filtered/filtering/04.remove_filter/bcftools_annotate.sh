#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/remove_filter.out
#$ -pe smp64 5
#$ -N remove_filter
bcftools annotate -x FILTER,FORMAT/FT -Oz -o \
	output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.rm_filter.vcf.gz \
	~/analyses_cae/Celegans/CaeNDR/20231213/soft_filtered/filtering/03.sort_by_sample/SelectVariants/output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.vcf.gz
