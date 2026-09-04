#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/bcftools_setGT.out
#$ -pe smp 1
#$ -N bcftools_setGT

bcftools +setGT \
	../03.sort_by_sample/output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.vcf.gz \
	-- -t q -n c:'0/1' -i ' (HP="AA" | HP="BB") ' | bgzip -c > \
	output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.vcf.gz
