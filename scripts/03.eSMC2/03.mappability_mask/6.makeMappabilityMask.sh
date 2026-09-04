#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/makeMappabilityMask.out
#$ -pe smp 5
#$ -N makeMappabilityMask

python makeMappabilityMask.py
