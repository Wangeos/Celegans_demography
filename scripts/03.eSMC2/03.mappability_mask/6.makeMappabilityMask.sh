#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/makeMappabilityMask.out
#$ -pe smp 5
#$ -N makeMappabilityMask

# `utils.py` available at https://github.com/stschiff/msmc-tools/blob/master/utils.py [Accessed 17-09-2026]

python makeMappabilityMask.py
