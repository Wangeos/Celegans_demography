#!/bin/bash
#SBATCH --job-name=generate_mhs    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --array=1-7                    # Set array jobs
#SBATCH --output=generate_mhs_%j.log   # Standard output and error log

VAR1=$(echo -e "I\nII\nIII\nIV\nV\nX\nMtDNA" | sed -n ${SLURM_ARRAY_TASK_ID}p)
BED_DIR1="../02.mpileup/output"
BED_DIR2="../03.mappability_mask/output"
VCF_DIR="../04.hom/output"

./generate_multihetsep.py \
        --mask=${BED_DIR1}/[sample1_name]/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/[sample2_name]/${VAR1}_mask.bed.gz \
        # Add bed files of all samples from the population
       	--mask=${BED_DIR2}/${VAR1}.mask.bed.gz \
        ${VCF_DIR}/[sample1_name]/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/[sample2_name]/${VAR1}.hom.vcf.gz \
        # Add vcf files of all samples from the population
        	> output/hawaii_g.[population_name].${VAR1}.mhs
