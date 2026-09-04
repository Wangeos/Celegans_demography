#!/bin/bash
#SBATCH --job-name=extract_array    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --array=1-4                    # Set array jobs; delete this line if it is not an array job
#SBATCH --output=extract_array_%j.log   # Standard output and error log

VAR1=$(echo -e "0.1\n0.2\n0.6\n0.8" | sed -n ${SLURM_ARRAY_TASK_ID}p)

plink2 --pedmap output/${VAR1}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.${VAR1} \
	--extract output/${VAR1}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.${VAR1}.prune.in \
        --export ped -out output/${VAR1}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.${VAR1}_ld_pruned

