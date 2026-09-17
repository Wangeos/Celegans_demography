#!/bin/bash
#SBATCH --job-name=eSMC2_chr    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --array=1-6	# Set array jobs
#SBATCH --output=eSMC2_%j.log   # Standard output and error log

VAR1=$(echo -e "I\nII\nIII\nIV\nV\nX" | sed -n ${SLURM_ARRAY_TASK_ID}p)
RC_RATE=$(grep -w $VAR1 /data/recombination_rate.txt | awk '{print $2}')

mkdir -p output/${VAR1}/plots
Rscript eSMC2.R $VAR1 $RC_RATE
