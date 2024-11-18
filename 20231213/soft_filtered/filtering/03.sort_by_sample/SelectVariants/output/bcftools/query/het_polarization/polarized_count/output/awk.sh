#!/bin/bash
#$ -V
#$ -cwd
#$ -o output/awk.out
#$ -pe smp 1
#$ -N awk

awk '{
    chrom=$1;
    pos=$2;
    # Initialize counters
    AA=0; AB=0; BB=0;
    # Iterate over the HP fields
    for(i=3;i<=NF;i++) {
        if($i == "AA") AA++;
        else if($i == "AB") AB++;
        else if($i == "BB") BB++;
    }
    print chrom, pos, AA, AB, BB;
}' OFS='\t' hp_values.txt > output/hp_counts_per_site.tsv
