#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/gzip.out
#$ -pe smp 1
#$ -N gzip

cat output/*.sam | gzip -k > output/xa.sam.gz
