#!/bin/bash
#SBATCH --nodes=1                      # Request 1 node (DON¡¯T change unless you are sure!)
#SBATCH --cpus-per-task=2
#SBATCH --job-name=windowed_counts    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=4                    # Run on a single core
#SBATCH --array=1-4                    # Set array jobs; delete this line if it is not an array job
#SBATCH --output=windowed_counts_%j.log   # Standard output and error log



SAMPLE=$(sed -n ${SLURM_ARRAY_TASK_ID}p sample_names.txt)

mkdir -p output/${SAMPLE}/plots
Rscript windowed_counts.R $SAMPLE