#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/index.out
#$ -pe smp64 5
#$ -N bcftools_index

bcftools index \
        -t ../WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.rm_filter.vcf.gz \
        --threads 5
bcftools index \
	-t ../WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.rm_filter.ft.vcf.gz \
	--threads 5
