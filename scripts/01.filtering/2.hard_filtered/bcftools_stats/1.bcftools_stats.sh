#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/bcftools_stats.out
#$ -pe smp 1
#$ -N bcftools_stats
#$ -t 1-29

VAR1=$(seq 0.05 0.05 0.95 | sed -n ${SGE_TASK_ID}p)

mkdir output/${VAR1}
bcftools stats ../03.missing_array/output/${VAR1}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_${VAR1}.vcf.gz > \
	output/${VAR1}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_${VAR1}.stats
