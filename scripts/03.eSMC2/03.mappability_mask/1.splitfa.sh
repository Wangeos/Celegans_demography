#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/splitfa.out
#$ -pe smp 1
#$ -N splitfa

seqbility-20091110/splitfa ~/raw_cae/Celegans/CaeNDR/20231213/reference/20231213_c_elegans_WS283.genome.fa 35 | split -l 20000000
