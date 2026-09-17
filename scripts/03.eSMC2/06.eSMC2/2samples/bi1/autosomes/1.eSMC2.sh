#!/bin/bash
#SBATCH --job-name=eSMC2    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=5                    # Run on a single CPU
#SBATCH --output=eSMC2_%j.log   # Standard output and error log

Rscript eSMC2.R
