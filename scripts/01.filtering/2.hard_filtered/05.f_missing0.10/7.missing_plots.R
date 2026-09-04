library(readxl)
library(ggplot2)

setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))
imiss <- read.table("WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.imiss", header=T)

# Read the geographical info of isotypes
iso_table_new <- read_xlsx("iso_table_geo.xlsx",sheet="iso_table_geo")
geo_new <- iso_table_new[c("isotype","strain","latitude","longitude","origin","origin_lee","origin_hawaii")]
colnames(geo_new)[1] <- "strain_vcf"
geo_new$origin_lee[grep("Undefined",geo_new$origin_lee, invert=T)] <- "Used in Lee et al. (2021)"
geo_new$origin_lee[grep("Undefined",geo_new$origin_lee)] <- "New"

# Check the mean imiss of isotypes from different geographical origins
geo_new_imiss <- merge(geo_new, imiss, by.x = "strain_vcf", by.y = "INDV", all)
mean_geo_hawaii_imiss <- tapply(geo_new_imiss$F_MISS, geo_new_imiss$origin_hawaii, mean)

# Plot the imiss range of isotypes from different geographical origins
# df_mean_geo_hawaii_imiss <- data.frame("Geo_origin" = names(mean_geo_hawaii_imiss),
#                                        "Mean_imiss" = mean_geo_hawaii_imiss)
# df_mean_geo_hawaii_imiss_ordered <- df_mean_geo_hawaii_imiss[order(df_mean_geo_hawaii_imiss$Mean_imiss, decreasing = TRUE),]
# df_mean_geo_hawaii_imiss_ordered$Geo_origin <- factor(df_mean_geo_hawaii_imiss_ordered$Geo_origin,
#                                                       levels = df_mean_geo_hawaii_imiss_ordered$Geo_origin)
geo_new_imiss$origin_hawaii <- factor(geo_new_imiss$origin_hawaii,
                                      levels = c("Kauai","Oahu","Molokai","Maui","Big Island",
                                                 "Africa","Asia","Atlantic","Australia",
                                                 "Europe","N. America","New Zealand",
                                                 "S. America","Unknown"))
xlab_size <- paste0(levels(geo_new_imiss$origin_hawaii),
                    "\n(N = ",
                    table(geo_new_imiss$origin_hawaii),
                    ")")
cols_hawaii <- c("Africa"="#ffa2ae",
                 "Asia"="#000000",
                 "Atlantic"="#4de9dd",
                 "Australia"="#0045ae",
                 "Europe"="#ff0004",
                 "New Zealand"="#ff8000",
                 "N. America"="#de4bfa",
                 "S. America"="#db6c91",
                 "Unknown" = "grey",
                 "Kauai"="#FFFF6D",
                 "Oahu"="#FF6DB6",
                 "Molokai"="#490092",
                 "Maui"="#6DB6FF",
                 "Big Island"="#e4c4a4"
)

violin_imiss <- ggplot()+
  geom_violin(aes(x = origin_hawaii, y = F_MISS, fill = origin_hawaii), 
               geo_new_imiss)+
  geom_jitter(aes(x = origin_hawaii, y = F_MISS), geo_new_imiss, size=0.2)+
  scale_fill_manual(values = cols_hawaii,
                    breaks = c("Africa","Asia","Atlantic","Australia",
                               "Europe","N. America","New Zealand","S. America",
                               "Kauai","Oahu","Molokai","Maui","Big Island",
                               "Unknown"))+
  geom_vline(xintercept = 5.5, linetype = "dashed")+
  scale_x_discrete(labels=xlab_size)+
  annotate("text",label = "Hawaiian known", 
           x = 3, y = max(geo_new_imiss$F_MISS)+0.01)+
  xlab(NULL)+
  ylab("Fraction of missing genotypes")+
  theme_classic()+
  theme(legend.position="none",
        axis.text.x = element_text(angle = 45, hjust = 0.9))
violin_imiss
ggsave("plots/imiss_violin.pdf", height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)


# Read the coverage (or sequencing depth) data of all strains
strain_depth <- read.table("CaeNDR strain coverages - C. elegans.csv",
                           sep=",", header=T)
geo_new_imiss_depth <- merge(geo_new_imiss,strain_depth, by.x = "strain", by.y = "Strain", all.x = T)
write.table(geo_new_imiss_depth, "geo_new_imiss_depth.txt",quote=F,sep="\t",row.names = F)
geo_new_imiss_depth_sorted <- geo_new_imiss_depth[order(geo_new_imiss_depth$Coverage),]

# Plot the depth range of isotypes from different geographical origins
violin_depth <- ggplot()+
  geom_violin(aes(x = origin_hawaii, y = Coverage, fill = origin_hawaii), 
               geo_new_imiss_depth)+
  geom_jitter(aes(x = origin_hawaii, y = Coverage), geo_new_imiss_depth, size=0.2)+
  scale_fill_manual(values = cols_hawaii,
                    breaks = c("Africa","Asia","Atlantic","Australia",
                               "Europe","N. America","New Zealand","S. America",
                               "Kauai","Oahu","Molokai","Maui","Big Island",
                               "Unknown"))+
  geom_vline(xintercept = 5.5, linetype = "dashed")+
  scale_x_discrete(labels=xlab_size)+
  ylim(c(0,NA))+
  annotate("text",label = "Hawaiian known", 
           x = 3, y = max(geo_new_imiss_depth$Coverage))+
  xlab(NULL)+
  ylab("Sequencing coverage")+
  theme_classic()+
  theme(legend.position="none",
        axis.text.x = element_text(angle = 45, hjust = 0.9))
violin_depth
ggsave("plots/depth_violin.pdf", height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)


