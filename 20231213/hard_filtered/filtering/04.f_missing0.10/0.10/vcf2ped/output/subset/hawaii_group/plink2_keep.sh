#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/plink2_keep.out
#$ -pe smp 5
#$ -N plink2_keep

plink2 --pedmap ../../WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10 \
	 --keep hawaii_group_list.txt \
	--export ped -out output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.hawaii_g
