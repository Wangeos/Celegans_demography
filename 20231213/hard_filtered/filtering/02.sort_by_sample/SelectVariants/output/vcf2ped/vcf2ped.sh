#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/vcf2ped.out
#$ -pe smp64 5
#$ -N vcf2ped

vcftools --gzvcf  \
	~/analyses_cae/Celegans/CaeNDR/20231213/hard_filtered/filtering/02.sort_by_sample/SelectVariants/output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.vcf.gz \
	--plink --out \
	output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted
