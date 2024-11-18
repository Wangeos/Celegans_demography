#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/awk.out
#$ -pe smp 5
#$ -N awk

awk '{
    het_count=0;
    hom_alt_count=0;
    mis_count=0
    for(i=3; i<=NF; i++){
	genotype = $i;
	# Skip missing genotypes
	if (genotype == "." || genotype == "./." || genotype == ".|.") {
		mis_count++;
	}
	else{
		# Split genotype into alleles based on "/"
		split(genotype, alleles, /[\/|]/);
		# Check if both alleles are present and different
		if (length(alleles) == 2 && alleles[1] != alleles [2]) {
			het_count++;
		}
		# Check if both alleles are the same alternatives
        	if (length(alleles) == 2 && alleles[1] == alleles [2] && alleles[1] != "0") {
                	hom_alt_count++;
        	}
	}
    }
    print $1"\t"$2"\t"het_count"\t"hom_alt_count"\t"mis_count;
}' WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.GT.txt > output/het_homAlt_mis_counts.txt
