library(ggplot2)

setwd(glue::glue("{dirname(rstudioapi::getActiveDocumentContext()$path)}/output"))
summ <- read.table("../../stats_record_summary.txt")
colnames(summ) <- c("Filter","Variant_count")
summ$Filter <- factor(summ$Filter,
                         levels=c("Complete-site","0.05","0.1","0.15","0.2","0.25",
                                  "0.3","0.35","0.4","0.45","0.5","0.55","0.6",
                                  "0.65","0.7","0.75","0.8","0.85","0.9",
                                  "0.95","Unfiltered"))
p <- ggplot()+
  geom_col(mapping=aes(x=Filter, y=Variant_count/1E6), data=summ)+
  geom_text(mapping=aes(x=Filter, y=Variant_count/1E6,
                        label=round(Variant_count/1E6,2)),
            data=summ, size=4,vjust=-0.5)+
  xlab("Maximum fraction of missing genotypes (F_MISSING) for each variant")+
  ylab("Variant count (×10^6)")+
  theme_bw()
p
pdf("plots/stats_record.pdf", height = 5, width = 12)
p
dev.off()
