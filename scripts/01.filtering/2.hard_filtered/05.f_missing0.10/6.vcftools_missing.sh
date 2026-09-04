#!/bin/bash
#SBATCH --job-name=missing    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --output=missing_%j.log   # Standard output and error log

vcftools --gzvcf ../04.missing_array/output/0.10/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.vcf.gz --missing-indv --out output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10