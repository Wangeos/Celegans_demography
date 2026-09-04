args <- commandArgs(trailingOnly = TRUE)

library(dplyr)
library(tidyverse)
library(ggplot2)

setwd(paste0("output/", args))

#`data.table::fread` helps to read the file in a faster way than `read.table()`
geno <- data.table::fread(paste0("./", args, "/GT.txt"))
sample_name <- args[1]
geno <- geno[,1:(ncol(geno)-1)]
colnames(geno)[1:2] <- c("seq","pos")
colnames(geno)[3:ncol(geno)] <- unlist(sample_name)

# Read the windows
windows <- read.table("../windows_100k_10k.bed")
colnames(windows) <- c("seq", "start", "end")

# Create an empty data frame with each column representing a sample and each row representing a window
sample_columns <- data.frame(matrix(0, ncol = length(sample_name), nrow = nrow(windows)))
colnames(sample_columns) <- unlist(sample_name)
windowed_counts <- cbind(windows, sample_columns)
mis_windowed_counts <- windowed_counts
homref_windowed_counts <- windowed_counts
homalt_windowed_counts <- windowed_counts
het_windowed_counts <- windowed_counts

#Convert genotypes into labels
for(i in c(1:nrow(windows))) {
  window <- windows[i,]
  geno_windowed <- filter(geno, seq == window$seq & pos > window$start & pos <= window$end)
  if(nrow(geno_windowed) != 0){
    for(j in c(3:ncol(geno_windowed))){
      for(k in c(1:nrow(geno_windowed))){
        gt <- geno_windowed[k,][[j]]
        if (gt %in% c("./.", ".|.")) {
          mis_windowed_counts[i,j+1] = mis_windowed_counts[i,j+1]+1
        }
        # Split the genotype by "/" or "|"
        else{
          alleles <- unlist(strsplit(gt, "/|\\|"))
          # Check for homozygous reference (all alleles are "0")
          if (all(alleles == "0")) {
            homref_windowed_counts[i,j+1] = homref_windowed_counts[i,j+1]+1
          }
          # Check for homozygous alternate (all alleles are the same, not "0")
          if (length(unique(alleles)) == 1 && alleles[1] != "0") {
            homalt_windowed_counts[i,j+1] = homalt_windowed_counts[i,j+1]+1
          }
          # Check for heterozygous (contains one "0" and one non-zero)
          if (length(unique(alleles)) == 2) {
            het_windowed_counts[i,j+1] = het_windowed_counts[i,j+1]+1
          }
        }
      }
    }
  }
  print(i)
}

write.table(mis_windowed_counts, "mis_windowed_counts.txt", sep = "\t", row.names = FALSE, quote = FALSE)
write.table(homref_windowed_counts, "homref_windowed_counts.txt", sep = "\t", row.names = FALSE, quote = FALSE)
write.table(homalt_windowed_counts, "homalt_windowed_counts.txt", sep = "\t", row.names = FALSE, quote = FALSE)
write.table(het_windowed_counts, "het_windowed_counts.txt", sep = "\t", row.names = FALSE, quote = FALSE)

# Convert the data to long format
het_windowed_counts_long <- pivot_longer(
  het_windowed_counts, !seq & !start & !end, names_to = "sample", values_to = "geno"
)
het_windowed_counts_long$seq <- factor(het_windowed_counts_long$seq,
                                       levels = c("I", "II", "III", "IV", "V", "X", "MtDNA"))
homalt_windowed_counts_long <- pivot_longer(
  homalt_windowed_counts, !seq & !start & !end, names_to = "sample", values_to = "geno"
)
homalt_windowed_counts_long$seq <- factor(homalt_windowed_counts_long$seq,
                                       levels = c("I", "II", "III", "IV", "V", "X", "MtDNA"))

# Plot the heterozygous genotype distribution using ggplot2
het_distribution <- ggplot() +
  geom_tile(data=het_windowed_counts_long, 
            mapping=aes(x = (start+end)/2000000, y = sample, fill = geno),
            height = 10) +  # or geom_point(shape = 21, size = 4) for dots
  facet_wrap(~seq, ncol=1)+
  scale_x_continuous(expand = c(0, 0)) +
  scale_fill_gradient(low = "white", high = "black") +
  coord_cartesian(xlim = c(0, NA)) +
  labs(x = "Chromosomal position (Mbp)", y = "Sample", fill = "Heterozygous genotype count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text.y = element_blank(),
        legend.position = "top"
        )
het_distribution
ggsave("plots/het_distribution.pdf", height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)

