#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/awk.out
#$ -pe smp 1
#$ -N awk

awk '{
    het_count=0;
    for(i=3; i<=NF; i++){
	genotype = $i;
	# Skip missing genotypes
	if (genotype == "." || genotype == "./." || genotype == ".|.") {
		continue;
	}
	# Split genotype into alleles based on "/"
	split(genotype, alleles, /[\/|]/);
	# Check if both alleles are present and different
	if (length(alleles) == 2 && alleles[1] != alleles [2]) {
		het_count++;
	}
    }
    print $1"\t"$2"\t"het_count;
}' WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.GT.txt > output/het_counts.txt
