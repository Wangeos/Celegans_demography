#!/bin/bash
#SBATCH --job-name=smartpca_array    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --array=1-4                    # Set array jobs; delete this line if it is not an array job
#SBATCH --output=smartpca_array_%j.log   # Standard output and error log

VAR1=$(echo -e "0.8\n0.6\n0.2\n0.1" | sed -n ${SLURM_ARRAY_TASK_ID}p)

smartpca -p ${VAR1}/smartpca.par
