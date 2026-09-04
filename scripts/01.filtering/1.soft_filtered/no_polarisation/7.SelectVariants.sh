#!/bin/bash
#SBATCH --job-name=gatk_selectvariants    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=5                    # Run on a single CPU
#SBATCH --output=gatk_selectvariants_%j.log   # Standard output and error log

gatk SelectVariants \
	-V output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.rm_filter.site_level_filtration.vcf.gz \
	--exclude-filtered true \
	-O output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.site_level1.vcf.gz

