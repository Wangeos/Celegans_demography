#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/rename_chrs.out
#$ -pe smp64 5
#$ -N rename_chrs
bcftools annotate --rename-chrs chr_rename.txt -Oz -o \
	output/WI.20231213.soft-filter.isotype.rename_chrs.vcf.gz \
	~/raw_cae/Celegans/CaeNDR/20231213/soft_filtered/WI.20231213.soft-filter.isotype.vcf.gz