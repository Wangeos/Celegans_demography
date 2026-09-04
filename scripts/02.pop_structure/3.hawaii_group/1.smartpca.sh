#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/smartpca.out
#$ -pe smp 5
#$ -N smartpca

smartpca -p smartpca.par
