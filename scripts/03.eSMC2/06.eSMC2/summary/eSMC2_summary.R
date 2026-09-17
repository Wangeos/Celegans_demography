library(ggplot2)
library(foreach)
library(scales)
library(patchwork)

setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))
pop_list <- c("bi1","bi2","bi4","bi5")
dir_list <- paste0("../../",pop_list)

pop_size <- foreach(i = c(1:length(dir_list))) %do% {
  read.table(paste0(dir_list[i],"autosomes_chr/output/Pop_size_summary.txt"),header=T,sep="\t")
}
for(i in c(1:length(dir_list))){
  pop_size[[i]]$Chr <- factor(pop_size[[i]]$Chr, levels = c("I", "II", "III", "IV", "V", "X","Autosomes"))
}
auto_single_value <- foreach(i = c(1:length(dir_list))) %do% {
  read.table(paste0(dir_list[i],"autosomes/output/Single_value.txt"),header=T,sep="\t")
}
auto_sigma <- foreach(i = c(1:length(dir_list))) %do% {
  auto_single_value[[i]]$Values[auto_single_value[[i]]$Parameters=="Sigma"]
}

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
alphas <- c(rep(0.8, length(unique(pop_size[[1]]$Chr))-1),1)

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

# Providing population names for plot titles
name_list <- c("Big Island1",
               "Big Island2",
               "Big Island4",
               "Big Island5")


eSMC2_plot <- foreach(i = c(1:length(dir_list))) %do% {
  ggplot()+
    geom_step(aes(x=Expected_coalescent_time,y=Population_size,colour=Chr,linewidth=Chr,alpha=Chr),
              pop_size[[i]])+
    scale_colour_manual(name = "Chromosome", values = cols) +
    scale_alpha_manual(name = "Chromosome", values = alphas)+
    scale_linewidth_manual(name = "Chromosome", values = linewidths)+
    labs(title=bquote(.(name_list[i])*": "*italic("\u03C3")*"* = "*.(sprintf("%.2f", auto_sigma[i]))),
         x=expression(Generations~ago), y=expression(Population~size))+
    theme_classic()+
    theme(plot.title = element_text(family = "", face = "plain"),
          axis.title = element_text(size=14, color = "black"),
          axis.text = element_text(size=13, color = "black"))+
    scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
    scale_y_continuous(limits = c(0, NA), labels = scientific_10)
}

eSMC2_summary <- eSMC2_plot[[1]] + eSMC2_plot[[2]] + eSMC2_plot[[3]] + eSMC2_plot[[4]] +
  plot_layout(ncol = 2, guides = "collect", axis_titles = "collect")
eSMC2_summary
ggsave("plots/eSMC2_summary.pdf", height = 10*(sqrt(5)-1)/2, width = 10, dpi = 300, device = cairo_pdf)


eSMC2_plot_ticked <- foreach(i = c(1:length(dir_list))) %do% {
  ggplot()+
    geom_step(aes(x=Expected_coalescent_time,y=Population_size,colour=Chr,linewidth=Chr,alpha=Chr),
              pop_size[[i]])+
    scale_colour_manual(name = "Chromosome", values = cols) +
    scale_alpha_manual(name = "Chromosome", values = alphas)+
    scale_linewidth_manual(name = "Chromosome", values = linewidths)+
    labs(title=bquote(.(name_list[i])*": "*italic("\u03C3")*"* = "*.(sprintf("%.2f", auto_sigma[i]))),
         x=expression(Generations~ago), y=expression(Population~size))+
    theme_classic()+
    theme(plot.title = element_text(family = "", face = "plain"),
          axis.title = element_text(size=14, color = "black"),
          axis.text = element_text(size=13, color = "black"))+
    scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
    scale_y_continuous(limits = c(0, NA), labels = scientific_10)+
    guides(x = guide_axis_logticks())
}

eSMC2_summary_ticked <- eSMC2_plot_ticked[[1]] + eSMC2_plot_ticked[[2]] + eSMC2_plot_ticked[[3]] + eSMC2_plot_ticked[[4]] +
  plot_layout(ncol = 2, guides = "collect", axis_titles = "collect")
eSMC2_summary_ticked
ggsave("plots/eSMC2_summary_ticked.pdf", height = 10*(sqrt(5)-1)/2, width = 10, dpi = 300, device = cairo_pdf)

eSMC2_plot_ticked_ne <- foreach(i = c(1:length(dir_list))) %do% {
  ggplot()+
    geom_step(aes(x=Expected_coalescent_time,y=Population_size,colour=Chr,linewidth=Chr,alpha=Chr),
              pop_size[[i]])+
    scale_colour_manual(name = "Chromosome", values = cols) +
    scale_alpha_manual(name = "Chromosome", values = alphas)+
    scale_linewidth_manual(name = "Chromosome", values = linewidths)+
    labs(title=bquote(.(name_list[i])*": "*italic("\u03C3")*"* = "*.(sprintf("%.2f", auto_sigma[i]))),
         x=expression(Generations~ago), y=expression(Effective~population~size~(italic(N[e]))))+
    theme_classic()+
    theme(plot.title = element_text(family = "", face = "plain"),
          axis.title = element_text(size=14, color = "black"),
          axis.text = element_text(size=13, color = "black"))+
    scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
    scale_y_continuous(limits = c(0, NA), labels = scientific_10)+
    guides(x = guide_axis_logticks())
}

eSMC2_summary_ticked_ne <- eSMC2_plot_ticked_ne[[1]] + eSMC2_plot_ticked_ne[[2]] + eSMC2_plot_ticked_ne[[3]] + eSMC2_plot_ticked_ne[[4]] +
  plot_layout(ncol = 2, guides = "collect", axis_titles = "collect")
eSMC2_summary_ticked_ne
ggsave("plots/eSMC2_summary_ticked_ne.pdf", height = 10*(sqrt(5)-1)/2, width = 10, dpi = 300, device = cairo_pdf)

# Swap with more informative population names
name_list_new <- c("Kalopa (BI1)",
               "Kipukapuaulu 1 (BI2)",
               "Manuka (BI4)",
               "Kaloko (BI5)")

eSMC2_plot_ticked_ne_renamed <- foreach(i = c(1:length(dir_list))) %do% {
  ggplot()+
    geom_step(aes(x=Expected_coalescent_time,y=Population_size,colour=Chr,linewidth=Chr,alpha=Chr),
              pop_size[[i]])+
    scale_colour_manual(name = "Chromosome", values = cols) +
    scale_alpha_manual(name = "Chromosome", values = alphas)+
    scale_linewidth_manual(name = "Chromosome", values = linewidths)+
    labs(title=bquote(.(name_list_new[i])*": "*italic("\u03C3")*"* = "*.(sprintf("%.2f", auto_sigma[i]))),
         x=expression(Generations~ago), y=expression(Effective~population~size~(italic(N[e]))))+
    theme_classic()+
    theme(plot.title = element_text(family = "", face = "plain"),
          axis.title = element_text(size=14, color = "black"),
          axis.text = element_text(size=13, color = "black"))+
    scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
    scale_y_continuous(limits = c(0, NA), labels = scientific_10)+
    guides(x = guide_axis_logticks())
}

eSMC2_summary_ticked_ne_renamed <- eSMC2_plot_ticked_ne_renamed[[1]] + eSMC2_plot_ticked_ne_renamed[[2]] + eSMC2_plot_ticked_ne_renamed[[3]] + eSMC2_plot_ticked_ne_renamed[[4]] +
  plot_layout(ncol = 2, guides = "collect", axis_titles = "collect")
eSMC2_summary_ticked_ne_renamed
ggsave("plots/eSMC2_summary_ticked_ne_renamed.pdf", height = 10*(sqrt(5)-1)/2, width = 10, dpi = 300, device = cairo_pdf)

# Add "sigma" to "Ne" of the y axis label
eSMC2_plot_ticked_nesigma_renamed <- foreach(i = c(1:length(dir_list))) %do% {
  ggplot()+
    geom_step(aes(x=Expected_coalescent_time,y=Population_size,colour=Chr,linewidth=Chr,alpha=Chr),
              pop_size[[i]])+
    scale_colour_manual(name = "Chromosome", values = cols) +
    scale_alpha_manual(name = "Chromosome", values = alphas)+
    scale_linewidth_manual(name = "Chromosome", values = linewidths)+
    labs(title=bquote(.(name_list_new[i])*": "*italic("\u03C3")*"* = "*.(sprintf("%.2f", auto_sigma[i]))),
         x=expression(Generations~ago), y=bquote(Effective~population~size~(italic(N[e*","*italic(sigma)]))))+
    theme_classic()+
    theme(plot.title = element_text(family = "", face = "plain"),
          axis.title = element_text(size=14, color = "black"),
          axis.text = element_text(size=13, color = "black"))+
    scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
    scale_y_continuous(limits = c(0, NA), labels = scientific_10)+
    guides(x = guide_axis_logticks())
}

eSMC2_summary_ticked_nesigma_renamed <- eSMC2_plot_ticked_nesigma_renamed[[1]] + eSMC2_plot_ticked_nesigma_renamed[[2]] + eSMC2_plot_ticked_nesigma_renamed[[3]] + eSMC2_plot_ticked_nesigma_renamed[[4]] +
  plot_layout(ncol = 2, guides = "collect", axis_titles = "collect")
eSMC2_summary_ticked_nesigma_renamed
ggsave("plots/eSMC2_summary_ticked_nesigma_renamed.pdf", height = 10*(sqrt(5)-1)/2, width = 10, dpi = 300, device = cairo_pdf)
