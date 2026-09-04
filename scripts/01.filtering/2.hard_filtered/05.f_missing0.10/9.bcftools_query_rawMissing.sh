#!/bin/bash
#SBATCH --job-name=bcftools_query    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=s2565306@ed.ac.uk  # Where to send mail
#SBATCH --ntasks=5                    # Run on a single CPU
#SBATCH --output=bcftools_query_%j.log   # Standard output and error log

bcftools query -f '%CHROM\t%POS\t[%GT:%HP\t]\n' \
	output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.hp_ab.vcf.gz > \
	output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.hp_ab.HP.txt
