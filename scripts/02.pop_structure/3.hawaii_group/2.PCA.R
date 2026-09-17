library(tidyverse)
library(ggrepel)
library(readxl)
library(ggforce)
library(ggnewscale)
library(sf)
library(rnaturalearth)

#`getActiveDocumentContext()` can get the path of `output/`
setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))

#`data.table::fread` helps to read the file in a faster way than `read.table()`
##`skip = 1` means skipping the first row of the file
df_pcs1 <- data.table::fread("WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.hawaii_g.evec", skip = 1)
eval <- data.table::fread("WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.hawaii_g.eval")

#`dplyr::select()`: select (and optionally rename) variables in a data frame
##`strain = V1` means renaming the `V1` column to `strain`
df_pcs2 <- dplyr::select(df_pcs1, strain_vcf = V1, V2:V16)
df_pcs3 <- dplyr::rename(df_pcs2, PC1=V2, PC2=V3, PC3=V4, PC4=V5, PC5=V6)

#Get the top 50 PC variations
colnames(eval) <- "Variation"
eval$Proportion <- eval$Variation/sum(eval$Variation)

#Load the origin info of 324 isotypes from Lee et al. (2021)
loc_path <- "../C:/Users/wangc/Downloads/Research/PhD/Data_analyses/Caenorhabditis/Celegans/CaeNDR/20231213/raw/Lee2021_S3.xlsx"
sheet <- "Sheet1"
loc <- read_excel(loc_path, sheet = sheet)
colnames(loc)[1] <- "strain_old"

#Load the info of 611 isotypes
#Note it is the strain names of isotypes that are consistent to the table of Lee et al, not the isotype name
iso_table <- read_xlsx("../20231213_c_elegans_strain_data-summary.xlsx",sheet="isotypes")
geo <- iso_table[c("strain","isotype","latitude","longitude")]
colnames(geo)[1] <- "strain_old"
colnames(geo)[2] <- "strain_vcf"

#Add the origin info to the isotype table as an additional column
df_pcs_geo <- dplyr::left_join(df_pcs3, geo, by='strain_vcf')
df_pcs_geo_loc <- dplyr::left_join(df_pcs_geo, loc[c("strain_old","origin")], by='strain_old')
df_pcs_geo_loc$origin <- gsub("Unknown","Unknown in Lee et al. (2021)",df_pcs_geo_loc$origin)
df_pcs_geo_loc$origin[is.na(df_pcs_geo_loc$origin)] <- "Undefined"
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
plot_PC12_defined <- ggplot(df_pcs_geo_loc) +
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

pdf("plots/PCA_defined.pdf", height = 8*(sqrt(5)-1)/2, width = 8)
plot_PC12_defined
dev.off()


#Loading the table with full information on geographical origins
iso_table_new <- read_xlsx("../iso_table_geo.xlsx",sheet="iso_table_geo")
geo_new <- iso_table_new[c("isotype","latitude","longitude","origin","origin_lee","origin_hawaii")]
colnames(geo_new)[1] <- "strain_vcf"
geo_new$origin_lee[grep("Undefined",geo_new$origin_lee, invert=T)] <- "Used in Lee et al. (2021)"
geo_new$origin_lee[grep("Undefined",geo_new$origin_lee)] <- "New"
df_pcs_geo_loc_new <- dplyr::left_join(dplyr::select(df_pcs_geo_loc,-c("origin")), geo_new[c("strain_vcf","origin","origin_lee","origin_hawaii")], by='strain_vcf')
df_pcs_geo_loc_new$origin[is.na(df_pcs_geo_loc_new$origin)] <- "Undefined"
df_pcs_geo_loc_new$latitude <- as.numeric(df_pcs_geo_loc_new$latitude)
df_pcs_geo_loc_new$longitude <- as.numeric(df_pcs_geo_loc_new$longitude)
write.table(df_pcs_geo_loc_new,"df_pcs_geo_loc.txt",sep="\t",quote=F,row.names = F)

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
plot_PC12 <-ggplot(df_pcs_geo_loc_new) +
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

pdf("plots/PCA.pdf", height = 8*(sqrt(5)-1)/2, width = 8)
plot_PC12
dev.off()



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
plot_PC12_hawaii <-ggplot(df_pcs_geo_loc_new) +
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

pdf("plots/PCA_hawaii.pdf", height = 8*(sqrt(5)-1)/2, width = 8)
plot_PC12_hawaii
dev.off()

#Read the Supplemental File from Crombie et al. (2022) paper on the detailed sampling sites
supple_table <- read_xlsx("C:/Users/wangc/Downloads/Research/PhD/Papers/Dataset/Caenorhabditis/elegans/Crombie(2022)-Supplement/mec16400-sup-0002-supinfo.xlsx",
                          sheet="Supplemental File 2",
                          col_types = "text")
df_pcs_geo_loc_new_supple <- merge(df_pcs_geo_loc_new, supple_table, by.x="strain_vcf", by.y="strain_name")
write.table(df_pcs_geo_loc_new_supple,"df_pcs_geo_loc_supple.txt",sep="\t",quote=F,row.names = F)

plot_PC12_hawaii_g <- ggplot(df_pcs_geo_loc_new_supple) +
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
plot_PC12_hawaii_g

pdf("plots/PCA_hawaii_3K.pdf", height = 8*(sqrt(5)-1)/2, width = 8)
plot_PC12_hawaii_g
dev.off()

plot_PC12_hawaii_g_ellipse <- ggplot(df_pcs_geo_loc_new_supple) +
  geom_mark_ellipse(aes(x=PC1, y=PC2,
                        fill = collection_cluster_3km), 
                    alpha = 0.3,linetype=0)+
  scale_fill_brewer(palette = "Set2")+
  scale_x_continuous(expand = expansion(mult = 0.2)) +
  scale_y_continuous(expand = expansion(mult = 0.2))+
  new_scale_fill() + 
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
       y=paste0("PC2 (",round(eval$Proportion[2]*100,digits=2),"%)"))+
  guides(fill= guide_legend(override.aes = list(shape=21),ncol=1))
plot_PC12_hawaii_g_ellipse

pdf("plots/PCA_hawaii_3K_ell.pdf", height = 8*(sqrt(5)-1)/2, width = 8)
plot_PC12_hawaii_g_ellipse
dev.off()

# Use more informative names for sampling locations
loc_rename <- c(
  "Big Island1" = "Kalopa (BI1)",
  "Big Island2" = "Kipukapuaulu 1 (BI2)",
  "Big Island3" = "Kipukapuaulu 2 (BI3)",
  "Big Island4" = "Manuka (BI4)",
  "Big Island5" = "Kaloko (BI5)",
  "Big Island6" = "Volcano 1 (BI6)",
  "Big Island7" = "Volcano 2 (BI7)",
  "Maui3" = "Maui (Maui3)"
)

plot_PC12_hawaii_g_ellipse_rename <- ggplot(df_pcs_geo_loc_new_supple) +
  geom_mark_ellipse(aes(x=PC1, y=PC2,
                        fill = collection_cluster_3km), 
                    alpha = 0.3,linetype=0)+
  scale_fill_brewer("Sampling locations", palette = "Set2", labels = loc_rename)+
  scale_x_continuous(expand = expansion(mult = 0.2)) +
  scale_y_continuous(expand = expansion(mult = 0.2))+
  new_scale_fill() + 
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
       y=paste0("PC2 (",round(eval$Proportion[2]*100,digits=2),"%)"))+
  guides(fill= guide_legend(override.aes = list(shape=21),ncol=1))
plot_PC12_hawaii_g_ellipse_rename
ggsave("plots/PCA_hawaii_3K_ell_renamed.pdf", height = 8*(sqrt(5)-1)/2, width = 8)


plot_PC12_hawaii_g_ellipse_lab <- plot_PC12_hawaii_g_ellipse+
  geom_text_repel(data = df_pcs_geo_loc_new_supple,
                  mapping = aes(x=PC1, y=PC2, label = strain_vcf, colour=collection_cluster_3km),
                  size = 2,
                  box.padding = 0.4,
                  point.padding = 0.3,
                  max.overlaps = Inf,
                  segment.size = 0.1,
                  min.segment.length = 0,
                  force=10,
                  parse = F)+
  scale_colour_brewer(palette = "Set2", guide = FALSE)
plot_PC12_hawaii_g_ellipse_lab

pdf("plots/PCA_hawaii_3K_ell_lab.pdf", height = 8*(sqrt(5)-1)/2, width = 8)
plot_PC12_hawaii_g_ellipse_lab
dev.off()




world <- ne_countries(scale = "medium", returnclass = "sf")
world_map <- ggplot(data = world) +
  geom_sf()+
  theme_classic()

pca_map <- world_map+
  geom_point(mapping=aes(x=longitude,y=latitude,fill=origin,shape=origin_lee), data=df_pcs_geo_loc_new, color="black", size=2)+
  scale_fill_manual(values = cols) +
  scale_shape_manual(values = shapes_new) +
  theme_classic()+
  theme(legend.position = c(0.15,0.25),
        legend.title = element_blank(),
        legend.background = element_rect(linewidth=0.1, color="black"),
        panel.grid = element_blank())+
  coord_sf()+
  xlab(NULL)+ylab(NULL)+
  guides(fill="none")
pca_map
pdf("plots/PCA_map.pdf", width=12, height=6)
pca_map
dev.off()

pca_map_hawaii <- world_map+
  geom_point(mapping=aes(x=longitude,y=latitude,fill=origin_hawaii, shape=origin_lee), data=df_pcs_geo_loc_new, color="black", size=2)+
  scale_fill_manual(values = cols_hawaii) +
  scale_shape_manual(values = shapes_new) +
  theme_classic()+
  theme(legend.position = c(0.3,0.25),
        legend.title = element_blank(),
        legend.background = element_rect(linewidth=0.1, color="black"),
        panel.grid = element_blank())+
  coord_sf()+
  xlab(NULL)+ylab(NULL)+
  xlim(c(-161,-154))+ylim(c(18,23))+
  guides(fill="none")
pca_map_hawaii
pdf("plots/PCA_map_hawaii.pdf", width=6, height=6*(sqrt(5)-1)/2)
pca_map_hawaii
dev.off()

sample_site_bi <- data.frame(name=c("Big Island1","Big Island2","Big Island3","Big Island4","Big Island5","Big Island6","Big Island7"),
                             longitude=c(-155.4399778,-155.221661,-155.3046194,-155.81956,-155.9490944,-155.697525,-155.235493),
                             latitude=c(20.03859444,19.424272,19.44180278,19.120367,19.71897222,19.10540278,19.449831))

sample_site_map_bi <- world_map+
  geom_point(mapping=aes(x=longitude,y=latitude,color=name), data=sample_site_bi, size=3, alpha=0.7)+
  scale_color_brewer(palette = "Set2")+
  theme_bw()+
  theme(legend.position = "none")+
  coord_sf()+
  xlab(NULL)+ylab(NULL)+
  xlim(c(-156.4,-154.6))+ylim(c(18.6,20.4))
sample_site_map_bi
ggsave("plots/sample_site_map_bi.pdf",height=3, width=3, dpi=300)
