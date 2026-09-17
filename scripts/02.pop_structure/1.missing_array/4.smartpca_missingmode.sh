#!/bin/bash
#SBATCH --job-name=smartpca    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --output=smartpca_%j.log   # Standard output and error log


smartpca -p smartpca_missingmode.par
