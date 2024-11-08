#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/index.out
#$ -pe smp64 5
#$ -N bcftools_index

bcftools index \
	-t ~/analyses_cae/Celegans/CaeNDR/20231213/soft_filtered/bcftools/annotate/rename_chrs/output/WI.20231213.soft-filter.isotype.rename_chrs.vcf.gz \
	--threads 5
