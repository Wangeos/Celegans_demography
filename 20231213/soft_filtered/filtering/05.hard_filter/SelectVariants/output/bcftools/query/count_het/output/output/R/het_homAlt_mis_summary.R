library(dplyr)
library(ggplot2)

#`getActiveDocumentContext()` can get the path of `output/`
setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))

#`data.table::fread` helps to read the file in a faster way than `read.table()`
het_count <- data.table::fread("../../het_homAlt_mis_counts.txt")
colnames(het_count) <- c("chr","pos","het_count","hom_alt_count","mis_count")

sample_count <- 611
variant_count <- nrow(het_count)

#Categorise sites based on the het count
het_homalt_group <- group_by(het_count,het_count,hom_alt_count)  #Simply using `group_by()` without a `summarise()` or other transformation will not alter the appearance of the dataset but will group the data internally. It prepares the data for operations that depend on groups (like `summarise()`, `mutate()`, `filter()`, etc.) but doesn’t itself change the visible data output.
het_homalt_table <- summarise(het_homalt_group,
                       site_count=n(),
                       .groups="drop")  #The `.groups = "drop"` argument tells dplyr to remove any grouping structure after the summary operation is complete.
write.table(het_homalt_table,"het_homAlt_spectrum.txt",quote=F,sep="\t",row.names = F)
het_homalt_heatmap <- ggplot() +
  geom_tile(data=het_homalt_table, mapping=aes(x = het_count, y = hom_alt_count, fill = site_count)) +
  scale_fill_viridis_c(option = "plasma", 
                       name = "Number of sites") +  # Use viridis color scale for better visibility
  labs(x = "Heterozygous individual count", y = "Homozygous alternative individual count") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
het_homalt_heatmap
pdf("plots/het_homAlt/het_homAlt_heatmap.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_homalt_heatmap
dev.off()

#Apply a log scale to the colour range as the value of most cells are quite small
het_homalt_heatmap_log <- het_homalt_heatmap+
  scale_fill_viridis_c(option = "plasma", 
                       name = "Number of sites",
                       trans="log",
                       labels = function(x) formatC(x, format = "f", digits = 2)  # Round to 2 decimal places
                       )
het_homalt_heatmap_log
pdf("plots/het_homAlt/het_homAlt_heatmap_log.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_homalt_heatmap_log
dev.off()

#Calculate the percentage of sites under different homozygous alt counts within each bin of heterozygous count
het_group <- group_by(het_count,het_count)
het_homalt_perc <- mutate(count(het_group,hom_alt_count),hom_alt_perc=(n/sum(n)))
write.table(het_homalt_perc,"het_homAlt_perc_spectrum.txt",quote=F,sep="\t",row.names = F)
het_homalt_perc_heatmap <- ggplot() +
  geom_tile(data=het_homalt_perc, mapping=aes(x = het_count, y = hom_alt_count, fill = hom_alt_perc*100)) +
  scale_fill_viridis_c(option = "plasma", 
                       name = "Percentage of sites (%)") +  # Use viridis color scale for better visibility
  labs(x = "Heterozygous individual count", y = "Homozygous alternative individual count") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
het_homalt_perc_heatmap
pdf("plots/het_homAlt/het_homAlt_perc_heatmap.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_homalt_perc_heatmap
dev.off()

#Apply a log scale to the colour range
het_homalt_perc_heatmap_log <- het_homalt_perc_heatmap+
  scale_fill_viridis_c(option = "plasma", 
                       name = "Percentage of sites (%)",
                       trans="log",
                       labels = function(x) formatC(x, format = "f", digits = 2)  # Round to 2 decimal places
  )
het_homalt_perc_heatmap_log
pdf("plots/het_homAlt/het_homAlt_perc_heatmap_log.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_homalt_perc_heatmap_log
dev.off()
#But actually using log scale isn't informative for percentages

#Check the spectrum of hom_alt percentage of the first few bins
het_homalt_perc_10 <- filter(het_homalt_perc, het_count >= 0 & het_count <= 10)
homalt_spec <- ggplot()+
  geom_line(data=het_homalt_perc_10,
               mapping=aes(x=hom_alt_count,
                           y=hom_alt_perc*100,
                           colour=factor(het_count)),
                            alpha=0.7,linewidth=0.2)+
  xlab("Homozygous alternative individual count")+
  ylab("Percentage of sites (%)")+
  theme_minimal()+
  labs(colour="Heterozygous individual\nnumber of sites")
homalt_spec
pdf("plots/het_homAlt/het_homAlt_perc_spectrum.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
homalt_spec
dev.off()

homalt_spec_100 <- ggplot()+
  geom_line(data=het_homalt_perc_10,
            mapping=aes(x=hom_alt_count,
                        y=hom_alt_perc*100,
                        colour=factor(het_count)),
            alpha=0.7)+
  xlab("Homozygous alternative individual count")+
  ylab("Percentage of sites (%)")+
  theme_minimal()+
  labs(colour="Heterozygous individual\nnumber of sites")+
  xlim(c(0,100))
homalt_spec_100
pdf("plots/het_homAlt/het_homAlt_perc_spectrum_100.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
homalt_spec_100
dev.off()

#Categorise sites based on the missing count
het_mis_group <- group_by(het_count,het_count,mis_count)  #Simply using `group_by()` without a `summarise()` or other transformation will not alter the appearance of the dataset but will group the data internally. It prepares the data for operations that depend on groups (like `summarise()`, `mutate()`, `filter()`, etc.) but doesn’t itself change the visible data output.
het_mis_table <- summarise(het_mis_group,
                              site_count=n(),
                              .groups="drop")  #The `.groups = "drop"` argument tells dplyr to remove any grouping structure after the summary operation is complete.
write.table(het_mis_table,"het_mis_spectrum.txt",quote=F,sep="\t",row.names = F)
het_mis_heatmap <- ggplot() +
  geom_tile(data=het_mis_table, mapping=aes(x = het_count, y = mis_count, fill = site_count)) +
  scale_fill_viridis_c(option = "plasma", 
                       name = "Number of sites") +  # Use viridis color scale for better visibility
  labs(x = "Heterozygous individual count", y = "Missing individual count") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
het_mis_heatmap
pdf("plots/het_mis/het_mis_heatmap.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_mis_heatmap
dev.off()

#Apply a log scale to the colour range as the value of most cells are quite small
het_mis_heatmap_log <- het_mis_heatmap+
  scale_fill_viridis_c(option = "plasma", 
                       name = "Number of sites",
                       trans="log",
                       labels = function(x) formatC(x, format = "f", digits = 2)  # Round to 2 decimal places
  )
het_mis_heatmap_log
pdf("plots/het_mis/het_mis_heatmap_log.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_mis_heatmap_log
dev.off()

#Calculate the percentage of sites under different homozygous alt counts within each bin of heterozygous count
het_group <- group_by(het_count,het_count)
het_mis_perc <- mutate(count(het_group,mis_count),mis_perc=(n/sum(n)))
write.table(het_mis_perc,"het_mis_perc_spectrum.txt",quote=F,sep="\t",row.names = F)
het_mis_perc_heatmap <- ggplot() +
  geom_tile(data=het_mis_perc, mapping=aes(x = het_count, y = mis_count, fill = mis_perc*100)) +
  scale_fill_viridis_c(option = "plasma", 
                       name = "Percentage of sites (%)") +  # Use viridis color scale for better visibility
  labs(x = "Heterozygous individual count", y = "Missing individual count") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
het_mis_perc_heatmap
pdf("plots/het_mis/het_mis_perc_heatmap.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_mis_perc_heatmap
dev.off()

#Apply a log scale to the colour range
het_mis_perc_heatmap_log <- het_mis_perc_heatmap+
  scale_fill_viridis_c(option = "plasma", 
                       name = "Percentage of sites (%)",
                       trans="log",
                       labels = function(x) formatC(x, format = "f", digits = 2)  # Round to 2 decimal places
  )
het_mis_perc_heatmap_log
pdf("plots/het_mis/het_mis_perc_heatmap_log.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
het_mis_perc_heatmap_log
dev.off()
#But actually using log scale isn't informative for percentages

#Check the spectrum of hom_alt percentage of the first few bins
het_mis_perc_10 <- filter(het_mis_perc, het_count >= 0 & het_count <= 10)
mis_spec <- ggplot()+
  geom_line(data=het_mis_perc_10,
            mapping=aes(x=hom_alt_count,
                        y=hom_alt_perc*100,
                        colour=factor(het_count)),
            alpha=0.7,linewidth=0.2)+
  xlab("Homozygous alternative individual count")+
  ylab("Percentage of sites (%)")+
  theme_minimal()+
  labs(colour="Heterozygous individual\nnumber of sites")
mis_spec
pdf("plots/het_mis/het_mis_perc_spectrum.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
mis_spec
dev.off()

mis_spec_100 <- ggplot()+
  geom_line(data=het_mis_perc_10,
            mapping=aes(x=hom_alt_count,
                        y=hom_alt_perc*100,
                        colour=factor(het_count)),
            alpha=0.7)+
  xlab("Homozygous alternative individual count")+
  ylab("Percentage of sites (%)")+
  theme_minimal()+
  labs(colour="Heterozygous individual\nnumber of sites")+
  xlim(c(0,100))
mis_spec_100
pdf("plots/het_mis/het_mis_perc_spectrum_100.pdf", height = 6*(sqrt(5)-1)/2, width = 6)
mis_spec_100
dev.off()

#######
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
  labs(x="Count of heterozygous individuals",
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
