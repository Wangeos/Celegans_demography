library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)
library(readxl)
library(ggforce)

args <- commandArgs(trailingOnly = TRUE)

setwd(glue::glue("../{args}/output/R/output"))

#`data.table::fread` helps to read the file in a faster way than `read.table()`
##`skip = 1` means skipping the first row of the file
df_pcs_noremoval_complete1 <- data.table::fread(paste0("../../WI.20231213.hard-filter.isotype.rename_chrs.missing_",args,".evec"), skip = 1)
eval <- data.table::fread(paste0("../../WI.20231213.hard-filter.isotype.rename_chrs.missing_",args,".eval"))

#`dplyr::select()`: select (and optionally rename) variables in a data frame
##`strain = V1` means renaming the `V1` column to `strain`
df_pcs_noremoval_complete2 <- dplyr::select(df_pcs_noremoval_complete1, strain = V1, V2:V16)
df_pcs_noremoval_complete3 <- dplyr::rename(df_pcs_noremoval_complete2, PC1=V2, PC2=V3, PC3=V4, PC4=V5, PC5=V6)

#Get the top 50 PC variations
colnames(eval) <- "Variation"
eval_pc50 <- eval[1:50,]
eval_pc50$Proportion <- eval_pc50$Variation/sum(eval_pc50$Variation)

#Load the origin info of 324 isotypes from Lee et al. (2021)
loc_path <- "~/analyses_cae/Celegans/CaeNDR/20231213/hard_filtered/pop_structure/eigensoft/chr_renamed/smartpca/no_removal/missing_array/R/Lee2021_S3.xlsx"
sheet <- "Sheet1"
loc <- read_excel(loc_path, sheet = sheet)

#Load the info of 611 isotypes
iso_table <- read_xlsx("~/analyses_cae/Celegans/CaeNDR/20231213/hard_filtered/pop_structure/eigensoft/chr_renamed/smartpca/no_removal/missing_array/R/20231213_c_elegans_strain_data-summary.xlsx",sheet="isotypes")
geo <- iso_table[c("isotype","latitude","longitude")]
colnames(geo)[1] <- "strain"

#Add the origin info to the isotype table as an additional column
df_pcs_noremoval_complete_loc <- dplyr::left_join(df_pcs_noremoval_complete3, loc[c("strain","origin")], by='strain')
df_pcs_noremoval_complete_loc_geo <- dplyr::left_join(df_pcs_noremoval_complete_loc, geo, by='strain')
df_pcs_noremoval_complete_loc_geo$origin <- gsub("Unknown","Unknown in Lee et al. (2021)",df_pcs_noremoval_complete_loc_geo$origin)
df_pcs_noremoval_complete_loc_geo$origin[is.na(df_pcs_noremoval_complete_loc_geo$origin)] <- "Undefined"
iso_table_geo <- dplyr::left_join(iso_table, loc[c("strain","origin")], by='strain')
iso_table_geo$origin <- gsub("Unknown","Unknown in Lee et al. (2021)",iso_table_geo$origin)
iso_table_geo$origin[is.na(iso_table_geo$origin)] <- "Undefined"

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
plot_PC12_defined <- ggplot(df_pcs_noremoval_complete_loc_geo) +
  geom_point(shape=21, size=2, alpha=0.8, aes(x=PC1, y=PC2, fill=origin)) +
  scale_fill_manual(values = cols) +
  theme_bw() +
  theme(axis.title = element_text(size=11, color = "black"), 
        axis.text = element_text(size=10, color = "black"),
        legend.position = c(0.7,0.8),
        legend.title = element_blank(),
        legend.background = element_rect(linewidth=0.1, color="black"),
        panel.grid = element_blank())+
  labs(x=paste0("PC1 (",round(eval_pc50$Proportion[1]*100,digits=2),"%)"), 
       y=paste0("PC2 (",round(eval_pc50$Proportion[2]*100,digits=2),"%)"))  +
  guides(fill= guide_legend(nrow=6))
plot_PC12_defined

pdf("plots/PCA_defined.pdf", height = 6, width = 6)
plot_PC12_defined
dev.off()



#Loading the table with full information on geographical origins
iso_table_new <- read_xlsx("~/analyses_cae/Celegans/CaeNDR/20231213/hard_filtered/pop_structure/eigensoft/chr_renamed/smartpca/no_removal/missing_array/R/iso_table_geo.xlsx",sheet="iso_table_geo")
geo_new <- iso_table_new[c("isotype","latitude","longitude","origin","origin_lee")]
colnames(geo_new)[1] <- "strain"
geo_new$origin_lee[grep("Undefined",geo_new$origin_lee, invert=T)] <- "Used in Lee et al. (2021)"
geo_new$origin_lee[grep("Undefined",geo_new$origin_lee)] <- "New"
df_pcs_noremoval_complete_loc_geo_new <- dplyr::left_join(df_pcs_noremoval_complete3, geo_new[c("strain","origin","origin_lee")], by='strain')
df_pcs_noremoval_complete_loc_geo_new$origin[is.na(df_pcs_noremoval_complete_loc_geo_new$origin)] <- "Undefined"

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
plot_PC12 <-ggplot(df_pcs_noremoval_complete_loc_geo_new) +
  geom_point(size=2, alpha=0.8, aes(x=PC1, y=PC2, fill=origin, shape=origin_lee)) +
  scale_fill_manual(values = cols_new) +
  scale_shape_manual(values = shapes_new) +
  theme_bw() +
  theme(axis.title = element_text(size=11, color = "black"), 
        axis.text = element_text(size=10, color = "black"),
        legend.position = c(0.7,0.7),
        legend.title = element_blank(),
        legend.background = element_rect(linewidth=0.1, color="black"),
        panel.grid = element_blank())+
  labs(x=paste0("PC1 (",round(eval_pc50$Proportion[1]*100,digits=2),"%)"), 
       y=paste0("PC2 (",round(eval_pc50$Proportion[2]*100,digits=2),"%)"))  +
  guides(fill= guide_legend(override.aes = list(shape=21), nrow=5))
plot_PC12

pdf("plots/PCA.pdf", height = 6, width = 6)
plot_PC12
dev.off()

plot_PC12_mag1 <- plot_PC12 +
  xlim(c(-0.05,0.05)) + ylim(c(-0.05,0.05))+
  theme(legend.position = c(0.5,0.8),
        legend.box="horizontal")
plot_PC12_mag1

pdf("plots/PCA_mag1.pdf", height = 6, width = 6)
plot_PC12_mag1
dev.off()

plot_PC12_nested <- plot_PC12 +
  facet_zoom(xlim=c(-0.03,0.05), ylim=c(-0.03,0.05),
             horizontal=F, zoom.size=0.8, show.area = T)+
  theme(legend.position = c(0.7,0.8))
plot_PC12_nested

pdf("plots/PCA_nested.pdf", height = 8, width = 4.5)
plot_PC12_nested
dev.off()

