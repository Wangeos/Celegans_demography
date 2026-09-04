#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/selectvariants.out
#$ -pe smp64 5
#$ -N selectvariants

gatk SelectVariants \
	-V output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.rm_filter.site_level_filtration.vcf.gz \
	--exclude-filtered true \
	-O output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.site_level1.vcf.gz

