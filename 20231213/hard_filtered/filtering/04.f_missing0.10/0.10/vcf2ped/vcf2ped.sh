#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/vcf2ped.out
#$ -pe smp 5
#$ -N vcf2ped

vcftools --gzvcf  \
	../WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.vcf.gz \
	--plink --out \
	output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10
