#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/bcftools_stats.out
#$ -pe smp 1
#$ -N bcftools_stats
#$ -t 1-3

VAR1=$(echo -e 0.05"\n"0.10"\n"0.95 | sed -n ${SGE_TASK_ID}p)

mkdir output/${VAR1}
bcftools stats ~/analyses_cae/Celegans/CaeNDR/20231213/hard_filtered/filtering/missing_array/f_missing/output/${VAR1}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_${VAR1}.vcf.gz > \
	output/${VAR1}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_${VAR1}.stats
