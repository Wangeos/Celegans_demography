#!/bin/bash
#SBATCH --job-name=bcftools_query    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=5                    # Run on a single CPU
#SBATCH --output=bcftools_query_%j.log   # Standard output and error log

bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' \
	output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.site_level1.vcf.gz > \
	output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.site_level1.GT.txt
