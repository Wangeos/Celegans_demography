library(ggplot2)
library(scales)

mu=2.3E-9 # Mutation rate

#`getActiveDocumentContext()` can get the path of `output/`
setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))

msmc <- read.table("hawaii_g.bi1.2samples.hap.msmc.final.txt", header=T)

# Rescale both time boundaries and the population size
msmcRescaled <- msmc
msmcRescaled$left_time_boundary <- msmcRescaled$left_time_boundary/mu
msmcRescaled$right_time_boundary <- msmcRescaled$right_time_boundary/mu
msmcRescaled$population_size <- (1/msmcRescaled$lambda_00)/(2*mu)
write.table(msmcRescaled,"msmc_rescaled.txt",sep="\t",quote=F,row.names = F, col.names = T)

pop_trajectory <- ggplot()+
  geom_step(aes(x=left_time_boundary/1E5,y=population_size/1E5),msmcRescaled,
            colour="red")+
  labs(x=expression(Generations~ago~(10^5)),y=expression(Population~size~(10^5)))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"), 
        axis.text = element_text(size=13, color = "black"))
pop_trajectory
ggsave("plots/pop_trajectory.pdf",height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)

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

pop_trajectory_log <- ggplot()+
  geom_step(aes(x=left_time_boundary,y=population_size),msmcRescaled,
            colour="red")+
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"), 
        axis.text = element_text(size=13, color = "black"))+
  scale_x_log10(limits = c(1,1E6),labels = custom_labels_log)+
  scale_y_log10(limits = c(1,1E6),labels = custom_labels_log)
pop_trajectory_log
ggsave("plots/pop_trajectory_log.pdf",height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)

pop_trajectory_log_1E3 <- ggplot()+
  geom_step(aes(x=left_time_boundary,y=population_size),msmcRescaled,
            colour="red")+
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"), 
        axis.text = element_text(size=13, color = "black"))+
  scale_x_log10(limits = c(1E3,1E6),labels = custom_labels_log)+
  scale_y_log10(limits = c(1E3,1E6),labels = custom_labels_log)
pop_trajectory_log_1E3
ggsave("plots/pop_trajectory_log_1E3.pdf",height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)

ggsave("plots/pop_trajectory_log_1E3_po.pdf",height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)

pop_trajectory_logx_1E3_0 <- ggplot()+
  geom_step(aes(x=left_time_boundary,y=population_size),
            msmcRescaled,colour="red")+
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"),
        axis.text = element_text(size=13, color = "black"))+
  scale_x_log10(limits = c(1E3,2E6),labels = custom_labels_log)+
  scale_y_continuous(limits = c(0, NA), labels = scientific_10)
pop_trajectory_logx_1E3_0
ggsave("plots/pop_trajectory_logx_1E3_0.pdf",height = 7*(sqrt(5)-1)/2, width = 5, dpi = 300)

