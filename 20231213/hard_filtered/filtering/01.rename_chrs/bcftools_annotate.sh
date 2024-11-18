#!/bin/bash
#$ -V
#$ -cwd
#$ -o ~/results_cae/Celegans/CaeNDR/20231213/bcftools/annotate/rename_chrs/rename_chrs.out
#$ -pe smp64 5
#$ -N rename_chrs
bcftools annotate --rename-chrs chr_rename.txt -Oz -o \
	~/results_cae/Celegans/CaeNDR/20231213/bcftools/annotate/rename_chrs/WI.20231213.hard-filter.isotype.rename_chrs.vcf.gz \
	~/raw_cae/Celegans/CaeNDR/20231213/WI.20231213.hard-filter.isotype.vcf.gz 
