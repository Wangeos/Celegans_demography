#!/bin/bash
#SBATCH --nodes=1                      # Request 1 node (DON¡¯T change unless you are sure!)
#SBATCH --cpus-per-task=2
#SBATCH --job-name=bcftools_query    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=4                    # Run on a single core
#SBATCH --array=1-4                    # Set array jobs; delete this line if it is not an array job
#SBATCH --output=bcftools_query_%j.log   # Standard output and error log

cd [population_name]/
SAMPLE=$(sed -n ${SLURM_ARRAY_TASK_ID}p sample_names.txt)
VCF_DIR="../../../02.mpileup/output/"

mkdir -p output/${SAMPLE}

for i in I II III IV V X MtDNA
do
  bcftools query -f '%CHROM\t%POS\t[%GT\t]\n' \
	  ${VCF_DIR}/${SAMPLE}/${i}.vcf.gz > \
	  output/${SAMPLE}/${i}.GT.txt
done

cat output/${SAMPLE}/I.GT.txt output/${SAMPLE}/II.GT.txt output/${SAMPLE}/III.GT.txt output/${SAMPLE}/IV.GT.txt output/${SAMPLE}/V.GT.txt output/${SAMPLE}/X.GT.txt output/${SAMPLE}/MtDNA.GT.txt > output/${SAMPLE}/GT.txt