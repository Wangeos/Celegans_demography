#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/smartpca.out
#$ -pe smp 1
#$ -N smartpca
#$ -t 1-19

VAR1=$(seq 0.05 0.05 0.95 | sed -n ${SGE_TASK_ID}p)

smartpca -p ${VAR1}/smartpca.par
