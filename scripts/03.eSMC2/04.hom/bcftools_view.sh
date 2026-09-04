#!/bin/bash
#SBATCH --job-name=bcftools_view    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --array=1                    # Set array jobs
#SBATCH --output=bcftools_view_%j.log   # Standard output and error log

VAR1=$(ls ../02.mpileup/output/ | grep '[0-9]' | sed -n ${SLURM_ARRAY_TASK_ID}p)

mkdir output/${VAR1}
for i in $(echo -e "I\nII\nIII\nIV\nV\nX\nMtDNA")
do
	bcftools view -o output/${VAR1}/${i}.hom.vcf.gz -O z -i ' GT="hom" ' \
	../02.mpileup/output/${VAR1}/${i}.vcf.gz
done
