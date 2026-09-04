#!/bin/bash
#SBATCH --job-name=ld_array    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --array=1-4                    # Set array jobs; delete this line if it is not an array job
#SBATCH --output=ld_array_%j.log   # Standard output and error log

VAR1=$(echo -e "0.1\n0.2\n0.6\n0.8" | sed -n ${SLURM_ARRAY_TASK_ID}p)

mkdir output/${VAR1}
plink2 --pedmap output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10 \
	--indep-pairwise 50 10 ${VAR1} \
        --export ped -out output/${VAR1}/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.${VAR1}

