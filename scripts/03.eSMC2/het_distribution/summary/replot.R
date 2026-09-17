library(dplyr)
library(ggplot2)
library(patchwork)

setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))

het_windowed_counts <- read.table("../../no_mask/summary/output/het_windowed_count_summary.txt",
                                  header = T)
het_windowed_counts_masked <- read.table("../../with_masks/summary/output/het_windowed_count_summary.txt",
                                  header = T)

# Remove MtDNA data
het_windowed_counts_chr <- filter(het_windowed_counts, seq != "MtDNA")
het_windowed_counts_masked_chr <- filter(het_windowed_counts_masked, seq != "MtDNA")

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

het_distribution_masked_chr <- ggplot() +
  geom_tile(data=het_windowed_counts_masked_chr, 
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
het_distribution_masked_chr

het_dist_summary <- het_distribution_chr + het_distribution_masked_chr +
  plot_layout(ncol = 1)
het_dist_summary
ggsave("plots/het_distribution_chr_summary.pdf", height = 15, width = 10)

het_dist_summary_labeled <- het_dist_summary+
  plot_annotation(tag_levels = "a")
het_dist_summary_labeled
ggsave("plots/het_distribution_chr_summary_labeled.pdf", height = 15, width = 10)

# Swap with more informative population names
name_list_new <- c("BI1" = "Kalopa\n(BI1)",
                   "BI2" = "Kipukapuaulu 1\n(BI2)",
                   "BI4" = "Manuka\n(BI4)",
                   "BI5" = "Kaloko\n(BI5)")

het_distribution_chr_renamed <- ggplot() +
  geom_tile(data=het_windowed_counts_chr, 
            mapping=aes(x = (start+end)/2000000, y = sample, fill = counts)) +  # or geom_point(shape = 21, size = 4) for dots
  facet_grid(rows = vars(location), cols = vars(seq),
             labeller = labeller(location = name_list_new),
             scales = "free", space = "free")+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_discrete(limits = rev) +
  scale_fill_gradient(low = "yellow", high = "black") +
  coord_cartesian(xlim = c(0, NA)) +
  labs(x = "Chromosomal position (Mbp)", y = "Sample", fill = "Heterozygous genotype count") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.y = element_blank(),
        legend.position = "top",
        strip.text.y = element_text(size = 6))
het_distribution_chr_renamed

het_distribution_masked_chr_renamed <- ggplot() +
  geom_tile(data=het_windowed_counts_masked_chr, 
            mapping=aes(x = (start+end)/2000000, y = sample, fill = counts)) +  # or geom_point(shape = 21, size = 4) for dots
  facet_grid(rows = vars(location), cols = vars(seq),
             labeller = labeller(location = name_list_new),
             scales = "free", space = "free")+
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_discrete(limits = rev) +
  scale_fill_gradient(low = "yellow", high = "black") +
  coord_cartesian(xlim = c(0, NA)) +
  labs(x = "Chromosomal position (Mbp)", y = "Sample", fill = "Heterozygous genotype count") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title.y = element_blank(),
        legend.position = "top",
        strip.text.y = element_text(size = 6))
het_distribution_masked_chr_renamed

het_dist_summary_renamed <- het_distribution_chr_renamed + het_distribution_masked_chr_renamed +
  plot_layout(ncol = 1)
het_dist_summary_renamed
ggsave("plots/het_distribution_chr_summary_renamed.pdf", height = 15, width = 10)

het_dist_summary_labeled_renamed <- het_dist_summary_renamed +
  plot_annotation(tag_levels = "a")
het_dist_summary_labeled_renamed
ggsave("plots/het_distribution_chr_summary_labeled_renamed.pdf", height = 15, width = 10)
