library(dplyr)
library(foreach)
library(ggplot2)
library(ggtext)
library(scales)
library(RColorBrewer)

setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))

dir <- "../../"
bi1 <- read.table(paste0(dir,"bi1/autosomes/output/Pop_size.txt"), header=T)
bi2 <- read.table(paste0(dir,"bi2/autosomes/output/Pop_size.txt"), header=T)
bi4 <- read.table(paste0(dir,"bi4/autosomes/output/Pop_size.txt"), header=T)
bi5 <- read.table(paste0(dir,"bi5/autosomes/output/Pop_size.txt"), header=T)
mix <- read.table(paste0(dir,"mix/autosomes/output/Pop_size.txt"), header=T)
loc_dfs <- list(BI1 = bi1, BI2 = bi2, BI4 = bi4, BI5 = bi5, Mix = mix)
pop_size <- bind_rows(loc_dfs, .id = "Location")

dir_list <- c(paste0("../../",
                     c("bi1","bi2","bi4","bi5","mix")))

auto_single_value <- foreach(i = c(1:length(dir_list))) %do% {
  read.table(paste0(dir_list[i],"autosomes/output/Single_value.txt"),header=T,sep="\t")
}
auto_sigma <- foreach(i = c(1:length(dir_list))) %do% {
  auto_single_value[[i]]$Values[auto_single_value[[i]]$Parameters=="Sigma"]
}

col_pal <- brewer.pal(n = 8, name = 'Set2')
cols <- c("BI1"=col_pal[1], 
          "BI2"=col_pal[2],
          "BI4"=col_pal[4],
          "BI5"=col_pal[5],
          "Mix"= "black")

loc_labels <- c(
  "BI1" = sprintf("Big Island1<br>(4 isotypes; <i>σ</i>* = %.2f)", auto_sigma[1]),
  "BI2" = sprintf("Big Island2<br>(4 isotypes; <i>σ</i>* = %.2f)", auto_sigma[2]),
  "BI4" = sprintf("Big Island4<br>(5 isotypes; <i>σ</i>* = %.2f)", auto_sigma[3]),
  "BI5" = sprintf("Big Island5<br>(24 isotypes; <i>σ</i>* = %.2f)", auto_sigma[4]),
  "Mix" = sprintf(
    "Mix (4 isotypes from Big<br>Island1, 2, 4 and 5;<br><i>σ</i>* = %.2f)",
    auto_sigma[5]
  )
)

# Setting a logarithmic scale
custom_labels_log <- function(x) {
  parse(text = paste0("10^", log10(x)))
}

# Setting a scientific mathematical scale
scientific_10 <- function(x) {
  out <- ifelse(
    x == 0, 
    "0", 
    gsub("e\\+?", " %*% 10^", label_scientific()(x))
  )
  parse(text = out)
}

pop_trajectory_coloured <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size,colour=Location),
            pop_size)+
  scale_colour_manual(values = cols, labels = loc_labels) +
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"),
        axis.text = element_text(size=13, color = "black"),
        legend.key.height = unit(2, "lines"),
        legend.text = element_markdown())+
  scale_x_continuous(labels = scientific_10)+
  scale_y_continuous(labels = scientific_10)
pop_trajectory_coloured
# ggsave("plots/pop_trajectory_coloured.pdf",height = 7*(sqrt(5)-1)/2, width = 6, dpi = 300)

# Let the y axis starts from 0
pop_trajectory_coloured_0 <- pop_trajectory_coloured+
  scale_y_continuous(limits = c(0,NA), labels = scientific_10)
pop_trajectory_coloured_0
ggsave("plots/pop_trajectory_coloured_0.pdf",height = 7*(sqrt(5)-1)/2, width = 7, dpi = 300, device = cairo_pdf)

pop_trajectory_coloured_logx_1E3_0 <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size,colour=Location),
            pop_size)+
  scale_colour_manual(values = cols, labels = loc_labels) +
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"),
        axis.text = element_text(size=13, color = "black"),
        legend.key.height = unit(2, "lines"),
        legend.text = element_markdown())+
  scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
  scale_y_continuous(limits = c(0,NA), labels = scientific_10)
pop_trajectory_coloured_logx_1E3_0
ggsave("plots/pop_trajectory_coloured_logx_1E3_0.pdf",height = 7*(sqrt(5)-1)/2, width = 7, dpi = 300, device = cairo_pdf)

pop_trajectory_coloured_logx_1E3_0_ticked <- pop_trajectory_coloured_logx_1E3_0 +
  guides(x = guide_axis_logticks())
pop_trajectory_coloured_logx_1E3_0_ticked
ggsave("plots/pop_trajectory_coloured_logx_1E3_0_ticked.pdf",height = 7*(sqrt(5)-1)/2, width = 7, dpi = 300, device = cairo_pdf)

pop_trajectory_coloured_logx_1E3_0_ticked_ne <- pop_trajectory_coloured_logx_1E3_0_ticked +
  labs(x=expression(Generations~ago),y=expression(Effective~population~size~(italic(N[e]))))
pop_trajectory_coloured_logx_1E3_0_ticked_ne
ggsave("plots/pop_trajectory_coloured_logx_1E3_0_ticked_ne.pdf",height = 7*(sqrt(5)-1)/2, width = 7, dpi = 300, device = cairo_pdf)

# Swap with more informative population names
loc_labels_new <- c(
  "BI1" = sprintf("Kalopa (BI1)<br>(4 isotypes; <i>σ</i>* = %.2f)", auto_sigma[1]),
  "BI2" = sprintf("Kipukapuaulu 1 (BI2)<br>(4 isotypes; <i>σ</i>* = %.2f)", auto_sigma[2]),
  "BI4" = sprintf("Manuka (BI4)<br>(5 isotypes; <i>σ</i>* = %.2f)", auto_sigma[3]),
  "BI5" = sprintf("Kaloko (BI5)<br>(24 isotypes; <i>σ</i>* = %.2f)", auto_sigma[4]),
  "Mix" = sprintf(
    "Mix (4 isotypes from Kalopa,<br>Kipukapuaulu 1, Manuka<br>and Kaloko; <i>σ</i>* = %.2f)",
    auto_sigma[5]
  )
)

pop_trajectory_coloured_logx_1E3_0_ticked_ne_renamed <- pop_trajectory_coloured_logx_1E3_0_ticked_ne+
  scale_colour_manual(values = cols, labels = loc_labels_new)
pop_trajectory_coloured_logx_1E3_0_ticked_ne_renamed
ggsave("plots/pop_trajectory_coloured_logx_1E3_0_ticked_ne_renamed.pdf",height = 7*(sqrt(5)-1)/2, width = 7, dpi = 300, device = cairo_pdf)

# Add "sigma" to "Ne" of the y axis label
pop_trajectory_coloured_logx_1E3_0_ticked_nesigma_renamed <- pop_trajectory_coloured_logx_1E3_0_ticked_ne_renamed +
  labs(y=bquote(Effective~population~size~(italic(N[e*","*italic(sigma)]))))
pop_trajectory_coloured_logx_1E3_0_ticked_nesigma_renamed
ggsave("plots/pop_trajectory_coloured_logx_1E3_0_ticked_nesigma_renamed.pdf",height = 7*(sqrt(5)-1)/2, width = 7, dpi = 300, device = cairo_pdf)

pop_trajectory_coloured_logx_1E3_0_poster <- pop_trajectory_coloured_logx_1E3_0+
  theme(legend.position = "inside",
        legend.position.inside = c(0.85,0.7))
pop_trajectory_coloured_logx_1E3_0_poster
ggsave("plots/pop_trajectory_coloured_logx_1E3_0_poster.pdf",height = 7*(sqrt(5)-1)/2, width = 6, dpi = 300, device = cairo_pdf)

pop_trajectory_coloured_log_1E3 <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size,colour=Location),
            pop_size)+
  scale_colour_manual(values = cols, labels = loc_labels) +
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"),
        axis.text = element_text(size=13, color = "black"),
        legend.key.height = unit(2, "lines"),
        legend.text = element_markdown())+
  scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
  scale_y_log10(limits = c(1E3,2E6),labels = custom_labels_log)
pop_trajectory_coloured_log_1E3
ggsave("plots/pop_trajectory_coloured_log_1E3.pdf", height = 7*(sqrt(5)-1)/2, width = 7, dpi = 300, device = cairo_pdf)

pop_trajectory_coloured_log_1E3_teterina2023 <- pop_trajectory_coloured_log_1E3+
  scale_x_log10(limits = c(0.5,2E6), breaks = c(1E0,1E2,1E4,1E6), labels = custom_labels_log)+
  scale_y_log10(limits = c(1,2E6), breaks = c(1E0,1E2,1E4,1E6), labels = custom_labels_log)
pop_trajectory_coloured_log_1E3_teterina2023
ggsave("plots/pop_trajectory_coloured_log_1E3_teterina2023.pdf", height = 7*(sqrt(5)-1)/2, width = 7, dpi = 300, device = cairo_pdf)
ggsave("plots/pop_trajectory_coloured_log_1E3_teterina2023_wider.pdf", height = 3, width = 11, dpi = 300, device = cairo_pdf)

pop_trajectory_coloured_log_1E3_teterina2023_ticked <- pop_trajectory_coloured_log_1E3_teterina2023 +
  guides(x = guide_axis_logticks(), y = guide_axis_logticks())
pop_trajectory_coloured_log_1E3_teterina2023_ticked
ggsave("plots/pop_trajectory_coloured_log_1E3_teterina2023_ticked.pdf", height = 7*(sqrt(5)-1)/2, width = 7, dpi = 300, device = cairo_pdf)
ggsave("plots/pop_trajectory_coloured_log_1E3_teterina2023_ticked_wider.pdf", height = 3, width = 11, dpi = 300, device = cairo_pdf)
