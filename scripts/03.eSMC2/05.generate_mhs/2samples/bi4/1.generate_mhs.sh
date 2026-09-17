#!/bin/bash
#SBATCH --job-name=generate_mhs    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --array=1-7                    # Set array jobs
#SBATCH --output=generate_mhs_%j.log   # Standard output and error log

# `generate_multihetsep.py` available at https://github.com/stschiff/msmc-tools/blob/master/generate_multihetsep.py [Accessed 17-09-2026]
# `utils.py` available at https://github.com/stschiff/msmc-tools/blob/master/utils.py [Accessed 17-09-2026]

VAR1=$(echo -e "I\nII\nIII\nIV\nV\nX\nMtDNA" | sed -n ${SLURM_ARRAY_TASK_ID}p)
BED_DIR1="../../../02.mpileup/output"
BED_DIR2="../../../03.mappability_mask/output"
VCF_DIR="../../../04.hom/output"

./generate_multihetsep.py \
        --mask=${BED_DIR1}/ECA1261/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1286/${VAR1}_mask.bed.gz \
       	--mask=${BED_DIR2}/${VAR1}.mask.bed.gz \
        ${VCF_DIR}/ECA1261/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1286/${VAR1}.hom.vcf.gz \
	> output/hawaii_g.bi4.2samples.${VAR1}.mhs
