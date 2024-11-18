#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/variantstotable.out
#$ -pe smp64 5
#$ -N variantstotable

gatk VariantsToTable \
	-V ../../02.sort_by_sample/SelectVariants/output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.vcf.gz \
	-F ID -F CHROM -F POS -F QD -F QUAL -F SOR -F FS -F MQ \
	-F MQRankSum -F ReadPosRankSum -F BaseQRankSum -F ExcessHet -F InbreedingCoeff -F DP \
	-O output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.variants.table
