#!/bin/bash
#SBATCH --job-name=awk    # Job name
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=[email_address]  # Where to send mail
#SBATCH --ntasks=5                    # Run on a single CPU
#SBATCH --output=awk_%j.log   # Standard output and error log

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
}' WI.20231213.soft-filter.isotype.rename_chrs.chr_sample_sorted.no_pol.site_level1.GT.txt > output/het_homAlt_mis_counts.site_level1.txt
