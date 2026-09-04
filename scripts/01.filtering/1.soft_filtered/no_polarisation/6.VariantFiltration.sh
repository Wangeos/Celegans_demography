#!/bin/bash
#SBATCH --job-name=gatk_variantfiltration    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=5                    # Run on a single CPU
#SBATCH --output=gatk_variantfiltration_%j.log   # Standard output and error log

gatk VariantFiltration \
	-V output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.rm_filter.vcf.gz \
	--filter-expression "QD <= 20.0 || FS >= 100.0 || SOR >= 5.0 || QUAL <= 30.0" \
	--filter-name "site-level_filter" \
	-O output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.rm_filter.site_level_filtration.vcf.gz
