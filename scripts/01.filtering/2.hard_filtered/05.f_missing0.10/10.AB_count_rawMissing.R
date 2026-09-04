#library(data.table)

hp_table <- read.table("output/WI.20231213.hard-filter.isotype.rename_chrs.sample_sorted.missing_0.10.hp_ab.HP.txt")
sample_names <- read.table("sample_name.txt")
print("Finished reading the data.")

colnames(hp_table) <- c("Chr","Pos",sample_names$V1)
ab <- c()
for(i in c(1:ncol(hp_table)-2)){
  ab[i] <- sum(hp_table[,i+2] == "./.:AB")
}
ab_count <- cbind(sample_names, ab)
colnames(ab_count) <- c("Isotype","AB_count")
write.table(ab_count, "output/ab_count.txt", row.names = F, quote = F, sep = "\t")