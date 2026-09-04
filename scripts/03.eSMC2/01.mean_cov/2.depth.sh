#!/bin/bash
#SBATCH --job-name=depth    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --array=1-20			# Set array jobs
#SBATCH --output=depth_%j.log   # Standard output and error log

VAR1=$(ls -F ~/raw_cae/Celegans/CaeNDR/20231213/bam/hawaii_g/ | grep ".bai" | sed -n ${SLURM_ARRAY_TASK_ID}p)

for i in $(echo -e I"\n"II"\n"III"\n"IV"\n"V"\n"X"\n"MtDNA)
do
	samtools depth -r ${i} ~/raw_cae/Celegans/CaeNDR/20231213/bam/hawaii_g/${VAR1%.bai} | awk '{sum += $3} END {print $1, sum / NR}' >> output/${VAR1%.bam.bai}_mean_cov.txt
done
