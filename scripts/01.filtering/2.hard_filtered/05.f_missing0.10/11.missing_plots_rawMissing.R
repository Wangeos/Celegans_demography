library(readxl)
library(ggplot2)
library(scales)

setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))
ab_count <- read.table("ab_count.txt", header=T)

# Read the geographical info of isotypes
iso_table_new <- read_xlsx("iso_table_geo.xlsx",sheet="iso_table_geo")
geo_new <- iso_table_new[c("isotype","strain","latitude","longitude","origin","origin_lee","origin_hawaii")]
colnames(geo_new)[1] <- "strain_vcf"
geo_new$origin_lee[grep("Undefined",geo_new$origin_lee, invert=T)] <- "Used in Lee et al. (2021)"
geo_new$origin_lee[grep("Undefined",geo_new$origin_lee)] <- "New"

# Check the mean imiss of isotypes from different geographical origins
geo_new_abcount <- merge(geo_new, ab_count, by.x = "strain_vcf", by.y = "Isotype", all)

# Plot the range of variants that were originally called heterozygous for isotypes from different geographical origins
geo_new_abcount$origin_hawaii <- factor(geo_new_abcount$origin_hawaii,
                                      levels = c("Kauai","Oahu","Molokai","Maui","Big Island",
                                                 "Africa","Asia","Atlantic","Australia",
                                                 "Europe","N. America","New Zealand",
                                                 "S. America","Unknown"))
xlab_size <- paste0(levels(geo_new_abcount$origin_hawaii),
                    "\n(N = ",
                    table(geo_new_abcount$origin_hawaii),
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



# Investigating whether the number of originally heterozygous calls is associated with the missing rate and the sequencing coverage
imiss_depth <- read.table("geo_new_imiss_depth.txt", 
                          header=T, sep="\t")
imiss_depth_info <- imiss_depth[,c("strain_vcf","N_DATA","N_GENOTYPES_FILTERED","N_MISS","F_MISS","Coverage","Included")]
geo_new_abcount_imiss_depth <- merge(geo_new_abcount, imiss_depth_info, by.x = "strain_vcf", by.y = "strain_vcf", all)
geo_new_abcount_imiss_depth$het_missing_rate <- geo_new_abcount_imiss_depth$AB_count/geo_new_abcount_imiss_depth$N_MISS
geo_new_abcount_imiss_depth$raw_missing <- geo_new_abcount_imiss_depth$N_MISS - geo_new_abcount_imiss_depth$AB_count
geo_new_abcount_imiss_depth$raw_missing_rate <- geo_new_abcount_imiss_depth$raw_missing/geo_new_abcount_imiss_depth$N_DATA
violin_rawmiss <- ggplot()+
  geom_violin(aes(x = origin_hawaii, y = raw_missing_rate, fill = origin_hawaii), 
              geo_new_abcount_imiss_depth)+
  geom_jitter(aes(x = origin_hawaii, y = raw_missing_rate), geo_new_abcount_imiss_depth, size=0.2)+
  scale_fill_manual(values = cols_hawaii,
                    breaks = c("Africa","Asia","Atlantic","Australia",
                               "Europe","N. America","New Zealand","S. America",
                               "Kauai","Oahu","Molokai","Maui","Big Island",
                               "Unknown"))+
  geom_vline(xintercept = 5.5, linetype = "dashed")+
  scale_x_discrete(labels=xlab_size)+
  annotate("text",label = "Hawaiian known", 
           x = 3, y = max(geo_new_abcount_imiss_depth$raw_missing_rate)+0.01)+
  xlab(NULL)+
  ylab("Proportion of originally missing genotypes")+
  theme_classic()+
  theme(legend.position="none",
        axis.text.x = element_text(angle = 45, hjust = 0.9))
violin_rawmiss
ggsave("plots/rawmiss_violin.pdf", height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)
