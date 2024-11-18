#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/bcftools_filter_array.out
#$ -pe smp 1
#$ -N bcftools_filter_array
#$ -t 1-3

VAR1=$(echo -e 0.05"\n"0.10"\n"0.95 | sed -n ${SGE_TASK_ID}p)

FILT="F_MISSING < $VAR1"
bcftools filter -i "$FILT" \
	--threads 5 -Oz -o output/${VAR1}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_${VAR1}.vcf.gz \
	~/analyses_cae/Celegans/CaeNDR/20231213/hard_filtered/filtering/02.sort_by_sample/SelectVariants/output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.vcf.gz
