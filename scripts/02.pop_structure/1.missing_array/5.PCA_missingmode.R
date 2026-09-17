library(dplyr)
library(tidyr)
library(ggplot2)
library(ggrepel)
library(readxl)
library(ggforce)
library(patchwork)

#`getActiveDocumentContext()` can get the path of `output/`
setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))

#`data.table::fread` helps to read the file in a faster way than `read.table()`
##`skip = 1` means skipping the first row of the file
df_pcs_noremoval_complete1 <- data.table::fread("missingmode.pca.evec", skip = 1)
eval <- data.table::fread("missingmode.pca.eval")

#`dplyr::select()`: select (and optionally rename) variables in a data frame
##`strain = V1` means renaming the `V1` column to `strain`
df_pcs_noremoval_complete2 <- dplyr::select(df_pcs_noremoval_complete1, strain_vcf = V1, V2:V16)
df_pcs_noremoval_complete3 <- dplyr::rename(df_pcs_noremoval_complete2, PC1=V2, PC2=V3, PC3=V4, PC4=V5, PC5=V6)

#Get PC variations
colnames(eval) <- "Variation"
eval$Proportion <- eval$Variation/sum(eval$Variation)

#Load the origin info of 324 isotypes from Lee et al. (2021)
loc_path <- "Lee2021_S3.xlsx"
sheet <- "Sheet1"
loc <- read_excel(loc_path, sheet = sheet)
colnames(loc)[1] <- "strain_old"

#Load the info of 611 isotypes
#Note it is the strain names of isotypes that are consistent to the table of Lee et al, not the isotype name
iso_table <- read_xlsx("20231213_c_elegans_strain_data-summary.xlsx",sheet="isotypes")
geo <- iso_table[c("strain","isotype","latitude","longitude")]
colnames(geo)[1] <- "strain_old"
colnames(geo)[2] <- "strain_vcf"

#Add the origin info to the isotype table as an additional column
df_pcs_noremoval_complete_geo <- dplyr::left_join(df_pcs_noremoval_complete3, geo, by='strain_vcf')
df_pcs_noremoval_complete_geo_loc <- dplyr::left_join(df_pcs_noremoval_complete_geo, loc[c("strain_old","origin")], by='strain_old')
df_pcs_noremoval_complete_geo_loc$origin <- gsub("Unknown","Unknown in Lee et al. (2021)",df_pcs_noremoval_complete_geo_loc$origin)
df_pcs_noremoval_complete_geo_loc$origin[is.na(df_pcs_noremoval_complete_geo_loc$origin)] <- "Undefined"
colnames(loc)[1] <- "strain"
iso_table_geo <- dplyr::left_join(iso_table, loc[c("strain","origin")], by='strain')
iso_table_geo$origin <- gsub("Unknown","Unknown in Lee et al. (2021)",iso_table_geo$origin)
iso_table_geo$origin[is.na(iso_table_geo$origin)] <- "Undefined"
write.table(iso_table_geo,"iso_table_geo.txt",sep="\t",quote=F,row.names = F)
#Add the origin info of other isotypes manually in the table written down...or copy the manually modified .xlsx file to the `output/`

#PCA plot with isotypes not included in Lee et al. (2021) coloured in white
cols <- c("Africa"="#ffa2ae",
          "Asia"="#000000",
          "Atlantic"="#4de9dd",
          "Australia"="#0045ae",
          "Europe"="#ff0004",
          "Hawaii"="#e4c4a4",
          "New Zealand"="#ff8000",
          "N. America"="#de4bfa",
          "S. America"="#db6c91",
          "Unknown in Lee et al. (2021)" = "grey",
          "Undefined"="#ffffff"
)
plot_PC12_defined <- ggplot(df_pcs_noremoval_complete_geo_loc) +
  geom_point(shape=21, size=2, alpha=0.8, aes(x=PC1, y=PC2, fill=origin)) +
  scale_fill_manual(values = cols) +
  theme_bw() +
  theme(axis.title = element_text(size=11, color = "black"), 
        axis.text = element_text(size=10, color = "black"),
        legend.position = "right",
        legend.title = element_blank(),
        panel.grid = element_blank())+
  labs(x=paste0("PC1 (",round(eval$Proportion[1]*100,digits=2),"%)"), 
       y=paste0("PC2 (",round(eval$Proportion[2]*100,digits=2),"%)"))  +
  guides(fill= guide_legend(ncol=1))
plot_PC12_defined
ggsave("plots/PCA_defined.pdf", height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)


#Loading the table with full information on geographical origins
iso_table_new <- read_xlsx("iso_table_geo.xlsx",sheet="iso_table_geo")
geo_new <- iso_table_new[c("isotype","latitude","longitude","origin","origin_lee","origin_hawaii")]
colnames(geo_new)[1] <- "strain_vcf"
geo_new$origin_lee[grep("Undefined",geo_new$origin_lee, invert=T)] <- "Used in Lee et al. (2021)"
geo_new$origin_lee[grep("Undefined",geo_new$origin_lee)] <- "New"
df_pcs_noremoval_complete_geo_loc_new <- dplyr::left_join(dplyr::select(df_pcs_noremoval_complete_geo_loc,-c("origin")), geo_new[c("strain_vcf","origin","origin_lee","origin_hawaii")], by='strain_vcf')
df_pcs_noremoval_complete_geo_loc_new$origin[is.na(df_pcs_noremoval_complete_geo_loc_new$origin)] <- "Undefined"
df_pcs_noremoval_complete_geo_loc_new$latitude <- as.numeric(df_pcs_noremoval_complete_geo_loc_new$latitude)
df_pcs_noremoval_complete_geo_loc_new$longitude <- as.numeric(df_pcs_noremoval_complete_geo_loc_new$longitude)
write.table(df_pcs_noremoval_complete_geo_loc_new,"df_pcs_geo_loc.txt",sep="\t",quote=F,row.names = F)

cols_new <- c("Africa"="#ffa2ae",
              "Asia"="#000000",
              "Atlantic"="#4de9dd",
              "Australia"="#0045ae",
              "Europe"="#ff0004",
              "Hawaii"="#e4c4a4",
              "New Zealand"="#ff8000",
              "N. America"="#de4bfa",
              "S. America"="#db6c91",
              "Unknown" = "grey"
)
shapes_new <- c("Used in Lee et al. (2021)"=21,"New"=24)
plot_PC12 <-ggplot(df_pcs_noremoval_complete_geo_loc_new) +
  geom_point(size=2, alpha=0.8, aes(x=PC1, y=PC2, fill=origin, shape=origin_lee)) +
  scale_fill_manual(values = cols_new) +
  scale_shape_manual(values = shapes_new) +
  theme_bw() +
  theme(axis.title = element_text(size=11, color = "black"), 
        axis.text = element_text(size=10, color = "black"),
        legend.position = "right",
        legend.title = element_blank(),
        panel.grid = element_blank())+
  labs(x=paste0("PC1 (",round(eval$Proportion[1]*100,digits=2),"%)"), 
       y=paste0("PC2 (",round(eval$Proportion[2]*100,digits=2),"%)"))  +
  guides(fill= guide_legend(override.aes = list(shape=21),ncol=1))
plot_PC12
ggsave("plots/PCA.pdf", height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)

#Use different colours to mark the Hawaiian strains
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
plot_PC12_hawaii <-ggplot(df_pcs_noremoval_complete_geo_loc_new) +
  geom_point(size=2, alpha=0.8, aes(x=PC1, y=PC2, fill=origin_hawaii, shape=origin_lee)) +
  scale_fill_manual(values = cols_hawaii,
                    breaks = c("Africa","Asia","Atlantic","Australia",
                               "Europe","N. America","New Zealand","S. America",
                               "Kauai","Oahu","Molokai","Maui","Big Island",
                               "Unknown")) +
  scale_shape_manual(values = shapes_new) +
  theme_bw() +
  theme(axis.title = element_text(size=11, color = "black"), 
        axis.text = element_text(size=10, color = "black"),
        legend.position = "right",
        legend.title = element_blank(),
        panel.grid = element_blank())+
  labs(x=paste0("PC1 (",round(eval$Proportion[1]*100,digits=2),"%)"), 
       y=paste0("PC2 (",round(eval$Proportion[2]*100,digits=2),"%)"))  +
  guides(fill= guide_legend(override.aes = list(shape=21),ncol=1))
plot_PC12_hawaii
ggsave("plots/PCA_hawaii.pdf", height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)


# Plotting the association between PC1 and missingness
imiss_depth <- read.table("scripts/01.filtering/2.hard_filtered/05.f_missing0.10/output/geo_new_imiss_depth.txt", 
                          header = T, sep = "\t")
pcs_geo_loc_imiss_depth <- merge(df_pcs_noremoval_complete_geo_loc_new, 
                                 imiss_depth[,c("strain_vcf", "N_DATA", "N_GENOTYPES_FILTERED", "N_MISS", "F_MISS", "Coverage", "Included")],
                                 by = "strain_vcf")

plot_PC1_imiss_hawaii <-ggplot(pcs_geo_loc_imiss_depth) +
  geom_point(size=2, alpha=0.8, aes(x=PC1, y=F_MISS, fill=origin_hawaii, shape=origin_lee)) +
  scale_fill_manual(values = cols_hawaii,
                    breaks = c("Africa","Asia","Atlantic","Australia",
                               "Europe","N. America","New Zealand","S. America",
                               "Kauai","Oahu","Molokai","Maui","Big Island",
                               "Unknown")) +
  scale_shape_manual(values = shapes_new) +
  theme_bw() +
  theme(axis.title = element_text(size=11, color = "black"), 
        axis.text = element_text(size=10, color = "black"),
        legend.position = "right",
        legend.title = element_blank(),
        panel.grid = element_blank())+
  labs(x=paste0("PC1 under missingmode"), 
       y=paste0("Fraction of missing genotypes"))  +
  guides(fill= guide_legend(override.aes = list(shape=21),ncol=1))
plot_PC1_imiss_hawaii
ggsave("plots/PC1_imiss_hawaii.pdf", height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)



# Import the normal PCA result and compare the two PC1
default_pca <- read.table("df_pcs_geo_loc.txt", 
                          header = T, sep = "\t")
pcs_geo_loc_imiss_depth_pc <- merge(pcs_geo_loc_imiss_depth, 
                                    default_pca,
                                 by = "strain_vcf")
plot_PC1_PC1_hawaii <-ggplot(pcs_geo_loc_imiss_depth_pc) +
  geom_point(size=2, alpha=0.8, aes(x=PC1.y, y=PC1.x, fill=origin_hawaii.x, shape=origin_lee.x)) +
  scale_fill_manual(values = cols_hawaii,
                    breaks = c("Africa","Asia","Atlantic","Australia",
                               "Europe","N. America","New Zealand","S. America",
                               "Kauai","Oahu","Molokai","Maui","Big Island",
                               "Unknown")) +
  scale_shape_manual(values = shapes_new) +
  theme_bw() +
  theme(axis.title = element_text(size=11, color = "black"), 
        axis.text = element_text(size=10, color = "black"),
        legend.position = "right",
        legend.title = element_blank(),
        panel.grid = element_blank())+
  labs(x=paste0("PC1 (default)"), 
       y=paste0("PC1 under missingmode"))  +
  guides(fill= guide_legend(override.aes = list(shape=21),ncol=1))
plot_PC1_PC1_hawaii
ggsave("plots/PC1_PC1_hawaii.pdf", height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)

defaultpc_imiss <- merge(default_pca, 
                         imiss_depth[,c("strain_vcf", "N_DATA", "N_GENOTYPES_FILTERED", "N_MISS", "F_MISS", "Coverage", "Included")],
                          by = "strain_vcf")
plot_defaultPC1_imiss_hawaii <-ggplot(defaultpc_imiss) +
  geom_point(size=2, alpha=0.8, aes(x=PC1, y=F_MISS, fill=origin_hawaii, shape=origin_lee)) +
  scale_fill_manual(values = cols_hawaii,
                    breaks = c("Africa","Asia","Atlantic","Australia",
                               "Europe","N. America","New Zealand","S. America",
                               "Kauai","Oahu","Molokai","Maui","Big Island",
                               "Unknown")) +
  scale_shape_manual(values = shapes_new) +
  theme_bw() +
  theme(axis.title = element_text(size=11, color = "black"), 
        axis.text = element_text(size=10, color = "black"),
        legend.position = "right",
        legend.title = element_blank(),
        panel.grid = element_blank())+
  labs(x=paste0("PC1 (default)"), 
       y=paste0("Fraction of missing genotypes"))  +
  guides(fill= guide_legend(override.aes = list(shape=21),ncol=1))
plot_defaultPC1_imiss_hawaii

# Adjust the axis labels of missingmode PCA
plot_PC12_hawaii_relabeled <- plot_PC12_hawaii + 
  labs(x=paste0("PC1 under missingmode (",round(eval$Proportion[1]*100,digits=2),"%)"), 
                         y=paste0("PC2 under missingmode (",round(eval$Proportion[2]*100,digits=2),"%)"))
plot_PC12_hawaii_relabeled
ggsave("plots/PCA_hawaii_relabeled.pdf", height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)

# Put four plots into one panel
missingmode_pca_panel <- (plot_PC12_hawaii_relabeled + plot_PC1_PC1_hawaii) / (plot_PC1_imiss_hawaii + plot_defaultPC1_imiss_hawaii) +
  plot_layout(guides = "collect")
missingmode_pca_panel
ggsave("plots/missingmode_pca_panel.pdf", height = 7, width = 10, dpi = 300, device = cairo_pdf)
