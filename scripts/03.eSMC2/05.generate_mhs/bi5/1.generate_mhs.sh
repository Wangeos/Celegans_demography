#!/bin/bash
#SBATCH --job-name=generate_mhs    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --mem=1gb                     # Job memory request
#SBATCH --array=1-7                    # Set array jobs
#SBATCH --output=generate_mhs_%j.log   # Standard output and error log

# `generate_multihetsep.py` available at https://github.com/stschiff/msmc-tools/blob/master/generate_multihetsep.py [Accessed 17-09-2026]
# `utils.py` available at https://github.com/stschiff/msmc-tools/blob/master/utils.py [Accessed 17-09-2026]

VAR1=$(echo -e "I\nII\nIII\nIV\nV\nX\nMtDNA" | sed -n ${SLURM_ARRAY_TASK_ID}p)
BED_DIR1="../../02.mpileup/output"
BED_DIR2="../../03.mappability_mask/output"
VCF_DIR="../../04.hom/output"

./generate_multihetsep.py \
        --mask=${BED_DIR1}/ECA1202/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1206/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1208/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1212/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1216/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1223/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1225/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1228/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1247/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1281/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1283/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1293/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1969/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA1997/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA2073/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA2081/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA2251/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA2417/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA2443/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA2473/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA2482/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA2489/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA744/${VAR1}_mask.bed.gz \
        --mask=${BED_DIR1}/ECA745/${VAR1}_mask.bed.gz \
       	--mask=${BED_DIR2}/${VAR1}.mask.bed.gz \
        ${VCF_DIR}/ECA1202/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1206/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1208/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1212/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1216/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1223/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1225/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1228/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1247/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1281/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1283/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1293/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1969/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA1997/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA2073/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA2081/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA2251/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA2417/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA2443/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA2473/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA2482/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA2489/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA744/${VAR1}.hom.vcf.gz \
        ${VCF_DIR}/ECA745/${VAR1}.hom.vcf.gz \
        	> output/hawaii_g.bi5.${VAR1}.mhs
