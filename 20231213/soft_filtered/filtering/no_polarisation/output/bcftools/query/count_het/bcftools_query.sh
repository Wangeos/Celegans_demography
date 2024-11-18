#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/bcftools_query.out
#$ -pe smp 1
#$ -N bcftools_query

bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' \
	../../WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.vcf.gz > \
	output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.GT.txt
