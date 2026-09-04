library(dplyr)
library(tidyverse)
library(RColorBrewer)
library(ggplot2)

setwd("output")

dir <- "../../"
bi1 <- list.files(paste0(dir, "bi1/output/"))
bi2 <- list.files(paste0(dir, "bi2/output/"))
bi4 <- list.files(paste0(dir, "bi4/output/"))
bi5 <- list.files(paste0(dir, "bi5/output/"))

# Combine windowed counts in each subpopulation
bi1_het <- read.table(paste0(dir, "bi1/output/", bi1[1], "/het_windowed_counts.txt"), header = T)
for(i in c(2:length(bi1))){
  bi1_het_sample <- read.table(paste0(dir, "bi1/output/", bi1[i], "/het_windowed_counts.txt"), header = T)
  bi1_het <- cbind(bi1_het, bi1_het_sample[,4])
  colnames(bi1_het)[i+3] <- bi1[i]
}

bi2_het <- read.table(paste0(dir, "bi2/output/", bi2[1], "/het_windowed_counts.txt"), header = T)
for(i in c(2:length(bi2))){
  bi2_het_sample <- read.table(paste0(dir, "bi2/output/", bi2[i], "/het_windowed_counts.txt"), header = T)
  bi2_het <- cbind(bi2_het, bi2_het_sample[,4])
  colnames(bi2_het)[i+3] <- bi2[i]
}

bi4_het <- read.table(paste0(dir, "bi4/output/", bi4[1], "/het_windowed_counts.txt"), header = T)
for(i in c(2:length(bi4))){
  bi4_het_sample <- read.table(paste0(dir, "bi4/output/", bi4[i], "/het_windowed_counts.txt"), header = T)
  bi4_het <- cbind(bi4_het, bi4_het_sample[,4])
  colnames(bi4_het)[i+3] <- bi4[i]
}

bi5_het <- read.table(paste0(dir, "bi5/output/", bi5[1], "/het_windowed_counts.txt"), header = T)
for(i in c(2:length(bi5))){
  bi5_het_sample <- read.table(paste0(dir, "bi5/output/", bi5[i], "/het_windowed_counts.txt"), header = T)
  bi5_het <- cbind(bi5_het, bi5_het_sample[,4])
  colnames(bi5_het)[i+3] <- bi5[i]
}

# Convert the data to long format
bi1_het_long <- pivot_longer(
  bi1_het, cols = 4:(length(bi1)+3), names_to = "sample", values_to = "counts"
)

bi2_het_long <- pivot_longer(
  bi2_het, cols = 4:(length(bi2)+3), names_to = "sample", values_to = "counts"
)

bi4_het_long <- pivot_longer(
  bi4_het, cols = 4:(length(bi4)+3), names_to = "sample", values_to = "counts"
)

bi5_het_long <- pivot_longer(
  bi5_het, cols = 4:(length(bi5)+3), names_to = "sample", values_to = "counts"
)

# Combine subpopulation data
het_dfs <- list(BI1 = bi1_het_long, BI2 = bi2_het_long, BI4 = bi4_het_long, BI5 = bi5_het_long)
het_windowed_counts <- bind_rows(het_dfs, .id = "location")
het_windowed_counts$seq <- factor(het_windowed_counts$seq,
                                  levels = c("I", "II", "III", "IV", "V", "X", "MtDNA"))
het_windowed_counts$sample <- factor(het_windowed_counts$sample,
                                  levels = unique(het_windowed_counts$sample))
write.table(het_windowed_counts, "het_windowed_count_summary.txt", sep = "\t", row.names = FALSE, quote = FALSE)

# Set the colour panel for sampeling locations
col_pal <- brewer.pal(n = 8, name = 'Set2')
loc_bg <- data.frame(location = c("BI1", "BI2", "BI3", "BI4", "BI5", "BI6", "BI7", "Maui3"),
                     col = col_pal)
sample_list <- unique(het_windowed_counts[,c("location", "sample")])
bg_df <- merge(sample_list, loc_bg, by = "location", sort=F)
bg_df <- bg_df[,c("sample", "location", "col")]

# Remove MtDNA data
het_windowed_counts_chr <- filter(het_windowed_counts, seq != "MtDNA")


# Output the tile plot with chromosomes presented horizontally
het_distribution_chr <- ggplot() +
  geom_tile(data=het_windowed_counts_chr, 
            mapping=aes(x = (start+end)/2000000, y = sample, fill = counts)) +  # or geom_point(shape = 21, size = 4) for dots
  facet_grid(rows = vars(location), cols = vars(seq), 
             scales = "free", space = "free")+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_discrete(limits = rev) +
  scale_fill_gradient(low = "yellow", high = "black") +
  coord_cartesian(xlim = c(0, NA)) +
  labs(x = "Chromosomal position (Mbp)", y = "Sample", fill = "Heterozygous genotype count") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.y = element_blank(),
        legend.position = "top")
het_distribution_chr
ggsave("plots/het_distribution_chr.pdf", height = 6, width = 15)
