#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/bcftools_query.out
#$ -pe smp 1
#$ -N bcftools_query

bcftools query -f '%CHROM\t%POS\t[%HP\t]\n' \
	~/analyses_cae/Celegans/CaeNDR/20231213/soft_filtered/filtering/03.sort_by_sample/SelectVariants/output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.vcf.gz > \
	output/hp_values.txt
