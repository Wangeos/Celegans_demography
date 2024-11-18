#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/variantfiltration.out
#$ -pe smp64 5
#$ -N variantfiltration

gatk VariantFiltration \
	-V ~/analyses_cae/Celegans/CaeNDR/20231213/soft_filtered/filtering/04.remove_filter/output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.rm_filter.vcf.gz \
	--filter-expression "QD <= 20.0 || FS >= 100.0 || SOR >= 5.0 || QUAL <= 30.0" \
	--filter-name "site-level_filter" \
	-O output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.rm_filter.site_level_filtration.vcf.gz
