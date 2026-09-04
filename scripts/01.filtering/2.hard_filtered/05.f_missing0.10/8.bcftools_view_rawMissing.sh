#!/bin/bash
#SBATCH --job-name=bcftools_view    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --output=bcftools_view_%j.log   # Standard output and error log

bcftools view ../04.missing_array/output/0.10/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.vcf.gz -i 'HP="AB"' | bgzip -c > \
	output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.hp_ab.vcf.gz