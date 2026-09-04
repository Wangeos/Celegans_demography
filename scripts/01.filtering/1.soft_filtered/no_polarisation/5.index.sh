#!/bin/bash
#SBATCH --job-name=bcftools_index    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=5                    # Run on a single CPU
#SBATCH --output=bcftools_index_%j.log   # Standard output and error log

bcftools index \
        -t output/WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.rm_filter.vcf.gz \
        --threads 5
