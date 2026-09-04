#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/vcf2ped.out
#$ -pe smp 1
#$ -N vcf2ped
#$ -t 1-19

VAR1=$(seq 0.05 0.05 0.95 | sed -n ${SGE_TASK_ID}p)

mkdir output/${VAR1}
vcftools --gzvcf  \
	output/${VAR1}/WI.20231213.hard-filter.isotype.rename_chrs.missing_${VAR1}.vcf.gz \
	--plink --out \
	output/WI.20231213.hard-filter.isotype.rename_chrs.missing_${VAR1}
