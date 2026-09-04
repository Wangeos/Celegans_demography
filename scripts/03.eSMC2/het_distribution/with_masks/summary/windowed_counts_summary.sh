#!/bin/bash
#SBATCH --nodes=1                      # Request 1 node (DON¡¯T change unless you are sure!)
#SBATCH --cpus-per-task=2
#SBATCH --job-name=windowed_counts_summary    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=4                    # Run on a single core
#SBATCH --output=windowed_counts_summary_%j.log   # Standard output and error log

Rscript windowed_counts_summary.R