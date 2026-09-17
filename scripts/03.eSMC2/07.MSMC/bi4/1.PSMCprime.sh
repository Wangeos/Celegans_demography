#!/bin/bash
#SBATCH --job-name=PSMCprime    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=10                    # Run on a single CPU
#SBATCH --output=PSMCprime_%j.log   # Standard output and error log

MHS_DIR="../../05.generate_mhs/2samples/bi4/output"

msmc -t 10 -r 0.264874596 -p 20*2 -o output/hawaii_g.bi4.2samples.hap.msmc ${MHS_DIR}/hawaii_g.bi4.2samples.I.hap.mhs \
  ${MHS_DIR}/hawaii_g.bi4.2samples.II.hap.mhs \
  ${MHS_DIR}/hawaii_g.bi4.2samples.III.hap.mhs \
  ${MHS_DIR}/hawaii_g.bi4.2samples.IV.hap.mhs \
  ${MHS_DIR}/hawaii_g.bi4.2samples.V.hap.mhs