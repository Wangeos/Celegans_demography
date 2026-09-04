library(dplyr)
library(ggplot2)

#`getActiveDocumentContext()` can get the path of `output/`
setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))

#`data.table::fread` helps to read the file in a faster way than `read.table()`
het_homalt_mis_count <- data.table::fread("../../het_homAlt_mis_counts.txt")
het_count <- het_homalt_mis_count[,1:3]
colnames(het_count) <- c("chr","pos","het_count")

sample_count <- 611
variant_count <- nrow(het_count)
het_only <- dplyr::filter(het_count, het_count!=0)
df <- data.frame(Statistic=c("Total count of sites",
                             "Total count of sites with heterozygous genotypes",
                             "Proportion of sites with heterozygous genotypes (%)",
                             "Total count of heterozygous genotypes",
                             "Mean heterozygous strain count per site"
                             ),
                 Value=c(variant_count,
                         nrow(het_only),
                         nrow(het_only)/variant_count*100,
                         sum(het_count$het_count),
                         sum(het_count$het_count)/variant_count
                         )
)
#Set the precision to be 5
df$Value <- sprintf("%.5f", df$Value)
#Trim all the redundant 0s for decimals
df$Value <- sub("\\.0+$", "", df$Value)
write.table(df,"statistics_summary.txt",quote=F,sep="\t",row.names = F)

#Generate the spectrum of het sites
het_table <- table(het_count$het_count)
het_table_df <- data.frame(het_table)
colnames(het_table_df) <- c("het_count","site_count")
write.table(het_table_df,"het_spectrum.txt",quote=F,sep="\t",row.names = F)
het_bar <- ggplot()+
  geom_bar(aes(x=het_count,y=site_count/1000),
           het_table_df,
           stat = "identity",width=1)+
  labs(x="Count of heterozygous strains",
       y=expression(paste("Count of sites (×10"^3,")")))+
  scale_x_discrete(breaks = seq(0, max(as.numeric(het_table_df$het_count)), by = 100))+
  theme_minimal()
het_bar
pdf("plots/het_bar.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_bar
dev.off()

het_bar_100 <- het_bar+
  coord_cartesian(xlim = c(0, 110))+
  scale_x_discrete(breaks = seq(0, 100, by = 10))
het_bar_100
pdf("plots/het_bar_100.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_bar_100
dev.off()

het_perc_bar <- ggplot()+
  geom_bar(aes(x=het_count,y=site_count/variant_count*100),
           het_table_df,
           stat = "identity",width=1)+
  labs(x="Count of heterozygous strains",
       y="Proportion of sites (%)")+
  scale_x_discrete(breaks = seq(0, max(as.numeric(het_table_df$het_count)), by = 100))+
  theme_minimal()
het_perc_bar
pdf("plots/het_perc_bar.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_perc_bar
dev.off()

het_perc_bar_100 <- het_perc_bar+
  coord_cartesian(xlim = c(0, 110))+
  scale_x_discrete(breaks = seq(0, 100, by = 10))
het_perc_bar_100
pdf("plots/het_perc_bar_100.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_perc_bar_100
dev.off()

#Read the unpolarised, polarised and site-level hard-filtered-only data
het_homalt_mis_count_unpol <- data.table::fread("../no_polarisation/output/het_homAlt_mis_counts.txt")
het_count_unpol) <- het_homalt_mis_count_unpol[,1:3]
colnames(het_count_unpol) <- c("chr","pos","het_count")
het_table_unpol <- table(het_count_unpol$het_count)
het_table_unpol_df <- data.frame(het_table_unpol)
colnames(het_table_unpol_df) <- c("het_count","site_count")

het_count_pol <- data.table::fread("../03.sort_by_sample/output/het_counts.txt")
colnames(het_count_pol) <- c("chr","pos","het_count")
het_table_pol <- table(het_count_pol$het_count)
het_table_pol_df <- data.frame(het_table_pol)
colnames(het_table_pol_df) <- c("het_count","site_count")

het_homalt_mis_count_hard_only <- data.table::fread("../no_polarisation/output/het_homAlt_mis_counts.site_level1.txt")
het_count_hard_only <- het_homalt_mis_count_hard_only[,1:3]
colnames(het_count_hard_only) <- c("chr","pos","het_count")
het_table_hard_only <- table(het_count_hard_only$het_count)
het_table_hard_only_df <- data.frame(het_table_hard_only)
colnames(het_table_hard_only_df) <- c("het_count","site_count")

#Combine the unpolarised, polarised and the hard-filtered table
het_table_df_combined <- bind_rows(mutate(het_table_unpol_df,source="Unpolarized"),
                                   mutate(het_table_hard_only_df,source="Unpolarized + site-level\nhard-filtered"),
                                   mutate(het_table_pol_df,source="Polarized"),
                                   mutate(het_table_df,source="Polarized + site-level\nhard-filtered"))
het_table_df_combined$source <- factor(het_table_df_combined$source,
                                       levels=c("Polarized + site-level\nhard-filtered",
                                                "Unpolarized + site-level\nhard-filtered",
                                                "Polarized",
                                                "Unpolarized"))
write.table(het_table_df_combined,"het_table_combined.txt",quote=F,sep="\t",row.names = F)
het_bar_combined <- ggplot()+
  geom_bar(aes(x=het_count,y=site_count/1000,fill=source),
           het_table_df_combined,
           stat = "identity",position="dodge",
           alpha=0.8,width=1)+
  labs(x="Count of heterozygous strains",
       y=expression(paste("Count of sites (×10"^3,")")))+
  scale_x_discrete(breaks = seq(0, max(as.numeric(het_table_df_combined$het_count)), by = 100))+
  scale_fill_manual(breaks=c("Polarized + site-level\nhard-filtered","Unpolarized + site-level\nhard-filtered","Polarized","Unpolarized"),
    values=c("black","darkgrey","blue","red"))+
  theme_minimal()+
  theme(legend.position = c(0.8,0.8),
        legend.title = element_blank(),
        legend.background = element_rect(linewidth=0.1, color="black"))
het_bar_combined
pdf("plots/het_bar_combined.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_bar_combined
dev.off()

het_bar_100_combined <- het_bar_combined+
  coord_cartesian(xlim = c(0, 110))+
  scale_x_discrete(breaks = seq(0, 100, by = 10))
het_bar_100_combined
pdf("plots/het_bar_100_combined.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_bar_100_combined
dev.off()

het_bar_80_combined <- het_bar_combined+
  coord_cartesian(xlim = c(0, 85))+
  scale_x_discrete(breaks = seq(0, 80, by = 10))
het_bar_80_combined
pdf("plots/het_bar_80_combined.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_bar_80_combined
dev.off()

het_bar_50_combined <- het_bar_combined+
  coord_cartesian(xlim = c(0, 55))+
  scale_x_discrete(breaks = seq(0, 50, by = 10))
het_bar_50_combined
pdf("plots/het_bar_50_combined.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_bar_50_combined
dev.off()


#Note three tables have different count of variants
het_table_unpol_df$perc <- het_table_unpol_df$site_count/nrow(het_count_unpol)
het_table_pol_df$perc <- het_table_pol_df$site_count/nrow(het_count_pol)
het_table_hard_only_df$perc <- het_table_hard_only_df$site_count/nrow(het_count_hard_only)
het_table_df$perc <- het_table_df$site_count/nrow(het_count)

het_table_df_combined_perc <- bind_rows(mutate(het_table_unpol_df,source="Unpolarized"),
                                        mutate(het_table_hard_only_df,source="Unpolarized + site-level\nhard-filtered"),
                                        mutate(het_table_pol_df,source="Polarized"),
                                        mutate(het_table_df,source="Polarized + site-level\nhard-filtered"))
het_table_df_combined_perc$source <- factor(het_table_df_combined_perc$source,
                                            levels=c("Polarized + site-level\nhard-filtered",
                                                     "Unpolarized + site-level\nhard-filtered",
                                                     "Polarized",
                                                     "Unpolarized"))
write.table(het_table_df_combined_perc,"het_table_combined_perc.txt",quote=F,sep="\t",row.names = F)
het_perc_bar_combined <- ggplot()+
  geom_bar(aes(x=het_count,y=perc*100,fill=source),
           het_table_df_combined_perc,
           stat = "identity",position="dodge",
           alpha=0.8,width=1)+
  labs(x="Count of heterozygous strains",
       y="Proportion of sites (%)")+
  scale_x_discrete(breaks = seq(0, max(as.numeric(het_table_df_combined$het_count)), by = 100))+
  scale_fill_manual(breaks=c("Polarized + site-level\nhard-filtered","Unpolarized + site-level\nhard-filtered","Polarized","Unpolarized"),
                    values=c("black","darkgrey","blue","red"))+
  theme_minimal()+
  theme(legend.position = c(0.8,0.8),
        legend.title = element_blank(),
        legend.background = element_rect(linewidth=0.1, color="black"))
het_perc_bar_combined
pdf("plots/het_perc_bar_combined.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_perc_bar_combined
dev.off()

het_perc_bar_100_combined <- het_perc_bar_combined+
  coord_cartesian(xlim = c(0, 110))+
  scale_x_discrete(breaks = seq(0, 100, by = 10))
het_perc_bar_100_combined
pdf("plots/het_perc_bar_100_combined.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_perc_bar_100_combined
dev.off()

het_perc_bar_80_combined <- het_perc_bar_combined+
  coord_cartesian(xlim = c(0, 85))+
  scale_x_discrete(breaks = seq(0, 100, by = 10))
het_perc_bar_80_combined
pdf("plots/het_perc_bar_80_combined.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_perc_bar_80_combined
dev.off()

het_perc_bar_50_combined <- het_perc_bar_combined+
  coord_cartesian(xlim = c(0, 55))+
  scale_x_discrete(breaks = seq(0, 100, by = 10))
het_perc_bar_50_combined
pdf("plots/het_perc_bar_50_combined.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_perc_bar_50_combined
dev.off()
