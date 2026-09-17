#!/bin/bash
#SBATCH --nodes=1                      # Request 1 node (DON¡¯T change unless you are sure!)
#SBATCH --cpus-per-task=2
#SBATCH --job-name=bedtools_multiinter    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=4                    # Run on a single core
#SBATCH --array=1-7                    # Set array jobs; delete this line if it is not an array job
#SBATCH --output=bedtools_multiinter_bed_%j.log   # Standard output and error log

VAR1=$(echo -e "I\nII\nIII\nIV\nV\nX\nMtDNA" | sed -n ${SLURM_ARRAY_TASK_ID}p)
BED_DIR1="../../../02.mpileup/output"
BED_DIR2="../../../03.mappability_mask/output"

bedtools multiinter -i ${BED_DIR1}/ECA1202/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1206/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1208/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1212/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1216/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1223/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1225/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1228/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1247/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1281/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1283/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1293/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1969/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA1997/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA2073/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA2081/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA2251/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA2417/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA2443/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA2473/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA2482/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA2489/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA744/${VAR1}_mask.bed.gz \
  ${BED_DIR1}/ECA745/${VAR1}_mask.bed.gz \
  ${BED_DIR2}/${VAR1}.mask.bed.gz > output/${VAR1}.multiinter.bed
awk '$4 == 5 {print $1,$2,$3}' output/${VAR1}.multiinter.bed > output/${VAR1}.mask.bed
sed -i '1ichrom  chromStart  chromEnd' output/${VAR1}.mask.bed
