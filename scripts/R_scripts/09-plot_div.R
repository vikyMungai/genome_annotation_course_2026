library(reshape2)
# library(hrbrthemes)
library(tidyverse)
library(data.table)


# get data from parameter
work_dir <- "/data/users/vmungai/genome_annotation_course_2026"


edta_anno_dir <- paste0(work_dir, "/output/EDTA/assembly.fasta.mod.EDTA.anno")

output_dir <- paste0(work_dir, "/plots/TE_landscape") 

data <- paste0(edta_anno_dir, "/assembly.mod.EDTA.RM.nonzero.out.landscape.Div.Rname.tab") 

rep_table <- fread(data, header = FALSE, sep = "\t")
rep_table %>% head()
# How does the data look like?

colnames(rep_table) <- c("Rname", "Rclass", "Rfam", 1:50)
rep_table <- rep_table %>% filter(Rfam != "unknown")
rep_table$fam <- paste(rep_table$Rclass, rep_table$Rfam, sep = "/")

table(rep_table$fam)
# How many elements are there in each Superfamily?

# 0.2-0.3 peak of DNA 
# 0.1 peak LTR, these are very old and should be present in each acessions 
# the peak near 0 are recent Ts 

rep_table.m <- melt(rep_table)


# Arrange the data so that they are in the following order:
# LTR/Copia, LTR/Gypsy, all types of DNA transposons (TIR transposons), DNA/Helitron, all types of MITES
rep_table.m$fam <- factor(rep_table.m$fam, levels = c(
  "LTR/Copia", "LTR/Gypsy", "DNA/DTA", "DNA/DTC", "DNA/DTH", "DNA/DTM", "DNA/DTT", "DNA/Helitron",
  "MITE/DTA", "MITE/DTC", "MITE/DTH", "MITE/DTM"
))

# NOTE: Check that all the superfamilies in your dataset are included above. check 

rep_table.m$distance <- as.numeric(rep_table.m$variable) / 100 # as it is percent divergence

# Question:
# rep_table.m$age <- ??? # Calculate using the substitution rate and the formula provided in the tutorial


# options(scipen = 999)

# remove helitrons as EDTA is not able to annotate them properly (https://github.com/oushujun/EDTA/wiki/Making-sense-of-EDTA-usage-and-outputs---Q&A)
rep_table.m <- rep_table.m %>% filter(fam != "DNA/Helitron")

ggplot(rep_table.m, aes(fill = fam, x = distance, weight = value / 1000000)) +
  geom_bar() +
  cowplot::theme_cowplot() +
  scale_fill_brewer(palette = "Paired") +
  xlab("Distance") +
  ylab("Sequence (Mbp)") +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, size = 9, hjust = 1), plot.title = element_text(hjust = 0.5))

plot_file = paste0(output_dir, "/plots.pdf")
ggsave(filename = plot_file, width = 10, height = 5, useDingbats = F)



