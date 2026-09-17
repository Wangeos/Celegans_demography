#!/bin/bash
#SBATCH --job-name=mpileup    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --array=1-20                    # Set array jobs
#SBATCH --output=mpileup_%j.log   # Standard output and error log

# `bamCaller.py` available at https://github.com/stschiff/msmc-tools/blob/master/bamCaller.py [Accessed 17-09-2026]
# `utils.py` available at https://github.com/stschiff/msmc-tools/blob/master/utils.py [Accessed 17-09-2026]

VAR1=$(ls -F ~/raw_cae/Celegans/CaeNDR/20231213/bam/hawaii_g/ | grep ".bai" | sed -n ${SLURM_ARRAY_TASK_ID}p)

mkdir -p output/${VAR1%.bam.bai}/
for i in $(echo -e I"\n"II"\n"III"\n"IV"\n"V"\n"X"\n"MtDNA)
do
	mean_cov=$(grep -w ${i} ../01.mean_cov/output/${VAR1%.bam.bai}_mean_cov.txt | awk '{print $2}')
	bcftools mpileup -q 20 -Q 20 -C 50 -O u -r ${i} \
	-f ~/raw_cae/Celegans/CaeNDR/20231213/reference/20231213_c_elegans_WS283.genome.fa \
	 ~/raw_cae/Celegans/CaeNDR/20231213/bam/hawaii_g/${VAR1%.bai} | bcftools call -c -V indels | \
	./bamCaller.py ${mean_cov} output/${VAR1%.bam.bai}/${i}_mask.bed.gz | bgzip -c > output/${VAR1%.bam.bai}/${i}.vcf.gz
done
