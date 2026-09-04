#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/PCA.out
#$ -pe smp64 5
#$ -N PCA

for i in $(seq 0.05 0.05 0.95)
do
    mkdir -p ../${i}/R/output/plots
    Rscript PCA.R ${i}
done
