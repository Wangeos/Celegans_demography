library(dplyr)
library(ggplot2)
library(scales)

setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))

# Reread the eSMC2 output of both the autosomes and the chr-separated dataset
dir <- "../../"
pop_size_autosomes <- read.table(paste0(dir,"autosomes/output/Pop_size.txt"), header=T)
pop_size_I <- read.table(paste0(dir,"chr/output/I/Pop_size.txt"), header=T)
pop_size_II <- read.table(paste0(dir,"chr/output/II/Pop_size.txt"), header=T)
pop_size_III <- read.table(paste0(dir,"chr/output/III/Pop_size.txt"), header=T)
pop_size_IV <- read.table(paste0(dir,"chr/output/IV/Pop_size.txt"), header=T)
pop_size_V <- read.table(paste0(dir,"chr/output/V/Pop_size.txt"), header=T)
pop_size_X <- read.table(paste0(dir,"chr/output/X/Pop_size.txt"), header=T)
chrom_dfs <- list(Autosomes = pop_size_autosomes, 
                  I = pop_size_I, II = pop_size_II, III = pop_size_III,
                  IV = pop_size_IV, V = pop_size_V, X = pop_size_X)
pop_size <- bind_rows(chrom_dfs, .id = "Chr")
pop_size$Chr <- factor(pop_size$Chr, levels = c("I", "II", "III", "IV", "V", "X","Autosomes"))
write.table(pop_size,"Pop_size_summary.txt",sep="\t",quote=F, row.names = F)

cols <- c("Autosomes"="black", 
          "I"="#E69F00",
          "II"="#56B4E9",
          "III"=  "#009E73",
          "IV"= "#F0E442",
          "V"="#0072B2",
          "X"="#D55E00")
linewidths <- c("Autosomes"=1, 
                "I"=0.5,
                "II"=0.5,
                "III"=0.5,
                "IV"=0.5,
                "V"=0.5,
                "X"=0.5)

# Highlight the autosome result
alphas <- c(rep(0.8, length(unique(pop_size$Chr))-1),1)

# Setting a logarithmic scale
custom_labels_log <- function(x) {
  parse(text = paste0("10^", log10(x)))
}

# Setting a scientific mathematical scale
scientific_10 <- function(x) {
  out <- ifelse(
    x == 0, 
    "0", 
    gsub("e\\+?", " %*% 10^", scientific_format()(x))
  )
  parse(text = out)
}

pop_trajectory_coloured <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size,colour=Chr,linewidth=Chr,alpha=Chr),
            pop_size)+
  scale_colour_manual(values = cols) +
  scale_alpha_manual(values = alphas)+
  scale_linewidth_manual(values = linewidths)+
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"),
        axis.text = element_text(size=13, color = "black"))+
  scale_x_continuous(labels = scientific_10)+
  scale_y_continuous(labels = scientific_10)
pop_trajectory_coloured
# ggsave("plots/pop_trajectory_coloured.pdf",height = 7*(sqrt(5)-1)/2, width = 6, dpi = 300)

# Let the y axis starts from 0
pop_trajectory_coloured_0 <- pop_trajectory_coloured+
  scale_y_continuous(limits = c(0,NA), labels = scientific_10)
pop_trajectory_coloured_0
ggsave("plots/pop_trajectory_coloured_0.pdf",height = 7*(sqrt(5)-1)/2, width = 6, dpi = 300)

# pop_trajectory <- ggplot()+
#   geom_step(aes(x=Expected_coalescent_time/1E5,y=Population_size/1E5,alpha=Chr),
#             pop_size, colour="red")+
#   scale_alpha_manual(values = alphas)+
#   labs(x=expression(Generations~ago~(10^5)),y=expression(Population~size~(10^5)))+
#   theme_classic()+
#   theme(axis.title = element_text(size=14, color = "black"), 
#         axis.text = element_text(size=13, color = "black"),
#         legend.position = "none")
# pop_trajectory
# ggsave("plots/pop_trajectory.pdf",height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)
# 
# pop_trajectory_0 <- pop_trajectory+
#   ylim(0, NA)
# pop_trajectory_0
# ggsave("plots/pop_trajectory_0.pdf",height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)



# Plotting the trajectory with the x axis in log scale
pop_trajectory_coloured_logx <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size,colour=Chr,linewidth=Chr,alpha=Chr),
            pop_size)+
  scale_colour_manual(values = cols) +
  scale_alpha_manual(values = alphas)+
  scale_linewidth_manual(values = linewidths)+
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"),
        axis.text = element_text(size=13, color = "black"))+
  scale_x_log10(labels = custom_labels_log)+
  scale_y_continuous(limits = c(0, NA), labels = scientific_10)
pop_trajectory_coloured_logx
ggsave("plots/pop_trajectory_coloured_logx.pdf",height = 7*(sqrt(5)-1)/2, width = 6, dpi = 300)

pop_trajectory_coloured_logx_1E3_0 <- pop_trajectory_coloured_logx+
  scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
  scale_y_continuous(limits = c(0, NA), labels = scientific_10)
pop_trajectory_coloured_logx_1E3_0
ggsave("plots/pop_trajectory_coloured_logx_1E3_0.pdf",height = 7*(sqrt(5)-1)/2, width = 6, dpi = 300)

pop_trajectory_coloured_logx_1E3_0_poster <- pop_trajectory_coloured_logx_1E3_0+
  theme(legend.position = "inside",
        legend.position.inside = c(0.85,0.7))
pop_trajectory_coloured_logx_1E3_0_poster
ggsave("plots/pop_trajectory_coloured_logx_1E3_0_poster.pdf",height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)

# pop_trajectory_logx_1E3 <- ggplot()+
#   geom_step(aes(x=Expected_coalescent_time,y=Population_size/1E5,alpha=Chr),
#             pop_size, colour="red")+
#   scale_alpha_manual(values = alphas)+
#   labs(x=expression(Generations~ago),y=expression(Population~size~(10^5)))+
#   theme_classic()+
#   theme(axis.title = element_text(size=14, color = "black"), 
#         axis.text = element_text(size=13, color = "black"),
#         legend.position = "none")+
#   scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)
# pop_trajectory_logx_1E3
# ggsave("plots/pop_trajectory_logx_1E3.pdf",height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)

# Let the y axis starts from 0
# pop_trajectory_logx_1E3_0 <- pop_trajectory_logx_1E3+
#   ylim(0, NA)
# pop_trajectory_logx_1E3_0
# ggsave("plots/pop_trajectory_logx_1E3_0.pdf",height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)

# Plotting the trajectory with both axes in log scale
pop_trajectory_coloured_log_1E3 <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size,colour=Chr,linewidth=Chr,alpha=Chr),
            pop_size)+
  scale_colour_manual(values = cols) +
  scale_alpha_manual(values = alphas)+
  scale_linewidth_manual(values = linewidths)+
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"),
        axis.text = element_text(size=13, color = "black"))+
  scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
  scale_y_log10(limits = c(1E3,2E6),labels = custom_labels_log)
pop_trajectory_coloured_log_1E3
ggsave("plots/pop_trajectory_coloured_log_1E3.pdf", height = 7*(sqrt(5)-1)/2, width = 6, dpi = 300)

# Add the PSMC' result
psmcp <- read.table("../../../../../07.MSMC/bi5/output/msmc_rescaled.txt",
                    header=T)

psmcp_pop_size <- psmcp[,c(2,5)]
psmcp_pop_size$Chr <- rep("Autosomes (PSMC')",length(psmcp_pop_size))
psmcp_pop_size <- psmcp_pop_size[,c(3,1:2)]
colnames(psmcp_pop_size) <- colnames(pop_size)

# Double the pop size inferred by PSMC'
psmcp_pop_size_rescaled <- psmcp[,c(2,5)]
sigma <- 0.99
rescaling_factor <- 2/(2-sigma)
psmcp_pop_size_rescaled$population_size <- psmcp_pop_size_rescaled$population_size*rescaling_factor
psmcp_pop_size_rescaled$Chr <- rep("Autosomes (PSMC', rescaled)",length(psmcp_pop_size_rescaled))
psmcp_pop_size_rescaled <- psmcp_pop_size_rescaled[,c(3,1:2)]
colnames(psmcp_pop_size_rescaled) <- colnames(pop_size)

pop_size_psmcp <- rbind(pop_size, psmcp_pop_size, psmcp_pop_size_rescaled)
pop_size_psmcp$Chr <- factor(pop_size_psmcp$Chr, levels = c("I", "II", "III", "IV", "V", "X", 
                                                            "Autosomes", "Autosomes (PSMC')", "Autosomes (PSMC', rescaled)"))
write.table(pop_size_psmcp,"Pop_size_summary_with_psmcp.txt",sep="\t",quote=F, row.names = F)

cols_psmcp <- c("Autosomes"="black",
                "Autosomes (PSMC')"="dimgray",
                "Autosomes (PSMC', rescaled)"="dimgray",
                "I"="#E69F00",
                "II"="#56B4E9",
                "III"=  "#009E73",
                "IV"= "#F0E442",
                "V"="#0072B2",
                "X"="#D55E00")
linewidths_psmcp <- c("Autosomes"=1, 
                      "Autosomes (PSMC')"=0.75,
                      "Autosomes (PSMC', rescaled)"=0.75,
                      "I"=0.5,
                      "II"=0.5,
                      "III"=0.5,
                      "IV"=0.5,
                      "V"=0.5,
                      "X"=0.5)
linetypes_psmcp <- c("Autosomes"=1, 
                     "Autosomes (PSMC')"=2,
                     "Autosomes (PSMC', rescaled)"=1,
                     "I"=1,
                     "II"=1,
                     "III"=1,
                     "IV"=1,
                     "V"=1,
                     "X"=1)

# Highlight the autosome result
alphas_psmcp <- c(rep(0.8, length(unique(pop_size_psmcp$Chr))-3),1,0.8,0.8)

pop_trajectory_coloured_logx_psmcp <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size,
                colour=Chr,linewidth=Chr,alpha=Chr,linetype=Chr),
            pop_size_psmcp)+
  scale_colour_manual(values = cols_psmcp) +
  scale_alpha_manual(values = alphas_psmcp)+
  scale_linewidth_manual(values = linewidths_psmcp)+
  scale_linetype_manual(values = linetypes_psmcp)+
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"),
        axis.text = element_text(size=13, color = "black"))+
  scale_x_log10(labels = custom_labels_log)+
  scale_y_continuous(limits = c(0, NA), labels = scientific_10)
pop_trajectory_coloured_logx_psmcp
ggsave("plots/pop_traj_coloured_logx_psmcp.pdf",height = 7*(sqrt(5)-1)/2, width = 7, dpi = 300)

pop_trajectory_coloured_logx_1E3_0_psmcp <- pop_trajectory_coloured_logx_psmcp+
  scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
  scale_y_continuous(limits = c(0, NA), labels = scientific_10)
pop_trajectory_coloured_logx_1E3_0_psmcp
ggsave("plots/pop_traj_coloured_logx_1E3_0_psmcp.pdf",height = 7*(sqrt(5)-1)/2, width = 7, dpi = 300)


pop_trajectory_log_1E3 <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size,alpha=Chr),
            pop_size, colour="red")+
  scale_alpha_manual(values = alphas)+
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"),
        axis.text = element_text(size=13, color = "black"),
        legend.position = "none")+
  scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
  scale_y_log10(limits = c(1E3,2E6),labels = custom_labels_log)
pop_trajectory_log_1E3
ggsave("plots/pop_trajectory_log_1E3.pdf", height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)



# Read the sigma inferred using autosome data
# single_value <- read.table(paste0(dir,"autosomes/output/Single_value.txt"), header=T)
# res_sigma <- single_value$Values[3]
# 
# pop_trajectory_coloured_log_1E3_sigma <- pop_trajectory_log_1E3+
#   annotate("text", x=1E5, y =1E4,
#            label=bquote(italic("\u03c3")*"* ="~.(res_sigma)))
# pop_trajectory_coloured_log_1E3_sigma
# ggsave("plots/pop_trajectory_coloured_log_1E3_sigma.pdf",
#        height = 7*(sqrt(5)-1)/2, width = 6, dpi = 300, device = cairo_pdf)

# Generate plots above with chr-separated data only
pop_size_chr <- filter(pop_size, Chr != "Autosomes")

pop_trajectory_chr <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time/1E5,y=Population_size/1E5,group=Chr),
            pop_size_chr,alpha=0.3, colour="red")+
  scale_alpha_manual(values = alphas)+
  labs(x=expression(Generations~ago~(10^5)),y=expression(Population~size~(10^5)))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"), 
        axis.text = element_text(size=13, color = "black"),
        legend.position = "none")
pop_trajectory_chr
ggsave("plots/pop_trajectory_chr.pdf",height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)

pop_trajectory_chr_0 <- pop_trajectory_chr+
  ylim(0, NA)
pop_trajectory_chr_0
ggsave("plots/pop_trajectory_chr_0.pdf",height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)

pop_trajectory_chr_logx_1E3 <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size/1E5,group=Chr),
            pop_size_chr,alpha=0.3, colour="red")+
  scale_alpha_manual(values = alphas)+
  labs(x=expression(Generations~ago),y=expression(Population~size~(10^5)))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"), 
        axis.text = element_text(size=13, color = "black"),
        legend.position = "none")+
  scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)
pop_trajectory_chr_logx_1E3
ggsave("plots/pop_trajectory_chr_logx_1E3.pdf",height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)

pop_trajectory_chr_logx_1E3_0 <- pop_trajectory_chr_logx_1E3+
  ylim(0, NA)
pop_trajectory_chr_logx_1E3_0
ggsave("plots/pop_trajectory_chr_logx_1E3_0.pdf",height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)

pop_trajectory_chr_log_1E3 <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size,group=Chr),
            pop_size_chr,alpha=0.3, colour="red")+
  scale_alpha_manual(values = alphas)+
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"),
        axis.text = element_text(size=13, color = "black"),
        legend.position = "none")+
  scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
  scale_y_log10(limits = c(1E3,2E6),labels = custom_labels_log)
pop_trajectory_chr_log_1E3
ggsave("plots/pop_trajectory_chr_log_1E3.pdf", height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)
