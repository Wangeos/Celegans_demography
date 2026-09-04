library(ggplot2)
library(readxl)

setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))
count <- read_xlsx("prune_count.xlsx", sheet = "in")
count <- count[-2,]
count$Dataset <- factor(count$Dataset,
                      levels=c("Total", "r^2=0.8", "r^2=0.6", "r^2=0.2", "r^2=0.1"))

ld_pruning_summary <- ggplot()+
  geom_col(mapping=aes(x=Dataset, y=Variant_count/1E6), data=count)+
  geom_text(mapping=aes(x=Dataset, y=Variant_count/1E6,
                        label=sprintf("%.2f",Variant_count/1E6)),
            data=count, size=4,vjust=-0.5)+
  xlab("Dataset")+
  ylab(expression("Variant count (×10"^6*")"))+
  ylim(c(0,3.5))+
  scale_x_discrete(expression(italic(r)^2~"threshold"),
                   labels = c(
                     "Total" = "No LD pruning",
                     "r^2=0.8" = expression(italic(r)^2~"<"~0.8),
                     "r^2=0.6" = expression(italic(r)^2~"<"~0.6),
                     "r^2=0.2" = expression(italic(r)^2~"<"~0.2),
                     "r^2=0.1" = expression(italic(r)^2~"<"~0.1)
                   ))+
  theme_bw()
ggsave("ld_pruning_summary.pdf",height = 6*(sqrt(5)-1)/2, width = 6, dpi = 300)

