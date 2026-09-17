#!/bin/bash
#SBATCH --job-name=awk    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --array=1-7                    # Set array jobs
#SBATCH --output=awk_%j.log   # Standard output and error log

VAR1=$(echo -e I"\n"II"\n"III"\n"IV"\n"V"\n"X"\n"MtDNA | sed -n ${SLURM_ARRAY_TASK_ID}p)

awk 'BEGIN { OFS = "\t" } {
    haplotype = "";
    for (i = 1; i <= length($4); i += 2) {
        haplotype = haplotype substr($4, i, 1); 
    }
    print $1, $2, $3, haplotype;
}'   output/hawaii_g.bi1.${VAR1}.mhs > output/hawaii_g.bi1.${VAR1}.hap.mhs

