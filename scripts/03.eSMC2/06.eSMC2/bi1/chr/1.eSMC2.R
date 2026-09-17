
###################
# Source function #
###################
library(eSMC2)
library(ggplot2)
########
#Script#
########

##############
# parameters #
##############

args <- commandArgs(trailingOnly = TRUE)
var1 <- as.character(args[1])
print(var1)
rc_rate <- as.numeric(args[2])
print(rc_rate)

population="Hawaii"
M=4 # Number of haploid genomes
NC=1 # Number of chromosomes
mu=2.3E-9 # Mutation rate
r=rc_rate  # Recombination rate

setwd(paste0("output/",var1))

Os=Get_real_data("../../../../../05.generate_mhs/bi1/output/",M,
	paste0("hawaii_g.bi1.",var1,".hap.mhs"),delim = "\t")
results=eSMC2(n=40, rho=r/mu, Os, SF=T, Rho=F,
              BoxP=c(3,3),NC=NC)

#Outputing all parameters including selfing rate (Sigma)
single_value <- data.frame(Parameters = c("LH","Beta","Sigma","Mu"),
            Values = c(results$LH,results$beta,results$sigma,results$mu))
write.table(single_value,"Single_value.txt",sep="\t",quote=F,row.names = F)

write.table(c("Tc",results$Tc),"Tc.txt",sep="\t",quote=F,row.names = F, col.names = F)
write.table(c("L",results$L),"L.txt",sep="\t",quote=F,row.names = F, col.names = F)
write.table(c("Xi",results$Xi),"Xi.txt",sep="\t",quote=F,row.names = F, col.names = F)
write.table(c("rho",results$rho),"rho.txt",sep="\t",quote=F,row.names = F, col.names = F)
write.table(c("q",results$q),"Initial_density.txt",sep="\t",quote=F,row.names = F, col.names = F)
write.table(results$N,"Transition_matrix.txt",sep="\t",quote=F,row.names = F, col.names = F)
write.table(results$M,"Emission_matrix.txt",sep="\t",quote=F,row.names = F, col.names = F)

Ne_t <- results$Xi
Ne <- mean(results$mu/mu)
print(paste0("Mean Ne = ",0.5*Ne))

eff_ratio <- r/mu*2*(1-results$sigma)/(2-results$sigma)
sigma_factor <- 2*(1-results$sigma)/(2-results$sigma)
print(paste0("rho/theta = ",eff_ratio))
print(paste0("2(1-sigma)/(2-sigma) = ",sigma_factor))

pop_size <- cbind(results$Tc*Ne,(Ne_t)*0.5*Ne)
colnames(pop_size) <- c("Expected_coalescent_time","Population_size")
write.table(pop_size,"Pop_size.txt",sep="\t",quote=F,row.names = F, col.names = T)

pop_trajectory <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time/1E5,y=Population_size/1E5),pop_size,
            colour="red")+
  labs(x=expression(Generations~ago~(10^5)),y=expression(Population~size~(10^5)))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"), 
        axis.text = element_text(size=13, color = "black"))
pop_trajectory
ggsave("plots/pop_trajectory.pdf",height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)

custom_labels <- function(x) {
  parse(text = paste0("10^", log10(x)))
}

pop_trajectory_log <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size),pop_size,
            colour="red")+
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"), 
        axis.text = element_text(size=13, color = "black"))+
  scale_x_log10(limits = c(1,1E6),labels = custom_labels)+
  scale_y_log10(limits = c(1,1E6),labels = custom_labels)
pop_trajectory_log
ggsave("plots/pop_trajectory_log.pdf",height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)

pop_trajectory_log_1E3 <- ggplot()+
  geom_step(aes(x=Expected_coalescent_time,y=Population_size),pop_size,
            colour="red")+
  labs(x=expression(Generations~ago),y=expression(Population~size))+
  theme_classic()+
  theme(axis.title = element_text(size=14, color = "black"), 
        axis.text = element_text(size=13, color = "black"))+
  scale_x_log10(limits = c(1E3,1E6),labels = custom_labels)+
  scale_y_log10(limits = c(1E3,1E6),labels = custom_labels)
pop_trajectory_log_1E3
ggsave("plots/pop_trajectory_log_1E3.pdf",height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)


pop_trajectory_log_1E3_sigma <- pop_trajectory_log_1E3+
  annotate("text", x=1E5, y =1E4,
           label=bquote(italic("\u03c3")*"* ="~.(results$sigma)))
pop_trajectory_log_1E3_sigma
ggsave("plots/pop_trajectory_log_1E3_sigma.pdf",
        height = 8*(sqrt(5)-1)/2, width = 8, dpi = 300)

