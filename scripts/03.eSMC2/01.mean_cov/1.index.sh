#!/bin/bash
#SBATCH --job-name=index    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --array=1-20                    # Set array jobs
#SBATCH --output=index_%j.log   # Standard output and error log

VAR1=$(ls -F ~/raw_cae/Celegans/CaeNDR/20231213/bam/hawaii_g/ | grep "bam" | sed -n ${SLURM_ARRAY_TASK_ID}p)

samtools index ../${VAR1}
