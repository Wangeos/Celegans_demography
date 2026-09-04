#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/vcf2ped.out
#$ -pe smp64 5
#$ -N vcf2ped

vcftools --gzvcf  \
	output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.complete.vcf.gz \
	--plink --out \
	output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.complete
