#!/bin/bash
#SBATCH --nodes=1                      # Request 1 node (DON¡¯T change unless you are sure!)
#SBATCH --cpus-per-task=2
#SBATCH --job-name=vcftools_bed    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=4                    # Run on a single core
#SBATCH --array=1-5                    # Set array jobs; delete this line if it is not an array job
#SBATCH --output=vcftools_bed_%j.log   # Standard output and error log

SAMPLE=$(sed -n ${SLURM_ARRAY_TASK_ID}p sample_names.txt)
VCF_DIR="../../../02.mpileup/output"

mkdir -p output/${SAMPLE}

for i in I II III IV V X MtDNA
do
  vcftools --gzvcf ${VCF_DIR}/${SAMPLE}/${i}.vcf.gz \
  --bed output/${i}.mask.bed \
  --recode --recode-INFO-all --stdout | gzip -c > output/${SAMPLE}/${i}.masked.vcf.gz
done

