# Load the circlize package
library(circlize)
library(tidyverse)
library(ComplexHeatmap)

workdir <- "/data/users/vmungai/genome_annotation_course_2026"
index_fasta <- paste0(workdir,"/output/EDTA/assembly.fasta.fai") 

out_dir <- paste0(workdir,"/plots/04_2-annotation_circlize") 


# Load the TE annotation GFF3 file
gff_file <- paste0(workdir, "/output/EDTA/assembly.fasta.mod.EDTA.TEanno.gff3")
gff_data <- read.table(gff_file, header = FALSE, sep = "\t", stringsAsFactors = FALSE)

# Check the superfamilies present in the GFF3 file, and their counts
gff_data$V3 %>% table()


custom_ideogram <- read.table(index_fasta, header = FALSE, stringsAsFactors = FALSE)
custom_ideogram$chr <- custom_ideogram$V1
custom_ideogram$start <- 1
custom_ideogram$end <- custom_ideogram$V2
custom_ideogram <- custom_ideogram[, c("chr", "start", "end")]
custom_ideogram <- custom_ideogram[order(custom_ideogram$end, decreasing = T), ]
sum(custom_ideogram$end[1:20])

# Select only the first 20 longest scaffolds, You can reduce this number if you have longer chromosome scale scaffolds
custom_ideogram <- custom_ideogram[1:20, ]

# Function to filter GFF3 data based on Superfamily (You need one track per Superfamily)
filter_superfamily <- function(gff_data, superfamily, custom_ideogram) {
    filtered_data <- gff_data[gff_data$V3 == superfamily, ] %>%
        as.data.frame() %>%
        mutate(chrom = V1, start = V4, end = V5, strand = V6) %>%
        select(chrom, start, end, strand) %>%
        filter(chrom %in% custom_ideogram$chr)
    return(filtered_data)
}

density_plot_file <- paste0(out_dir, "/02-TE_density.pdf")

pdf(density_plot_file, width = 10, height = 10)
gaps <- c(rep(1, length(custom_ideogram$chr) - 1), 5) # Add a gap between scaffolds, more gap for the last scaffold
circos.par(start.degree = 90, gap.after = 1, track.margin = c(0, 0), gap.degree = gaps)
# Initialize the circos plot with the custom ideogram
circos.genomicInitialize(custom_ideogram)

# Plot te density with all superfamily of interest 
superfamily_list = c("Gypsy_LTR_retrotransposon", "Copia_LTR_retrotransposon", 
                    "CACTA_TIR_transposon", "L1_LINE_retrotransposon", "PIF_Harbinger_TIR_transposon", 
                    "helitron", "Mutator_TIR_transposon")
legend_colors = c("darkgreen", "darkred", "turquoise", "powderblue", 
                 "tomato3", "violetred1", "royalblue1")

for (i in seq_along(superfamily_list)) {
    circos.genomicDensity(filter_superfamily(gff_data, superfamily_list[i], custom_ideogram),
    count_by = "number", col = legend_colors[i], track.height = 0.07, window.size = 1e5)
}
circos.clear()

lgd <- Legend(
    title = "Superfamily", at = superfamily_list,
    legend_gp = gpar(fill = legend_colors)
)

draw(lgd, x = unit(0.5, "npc"), y = unit(0.5, "npc"), just = "center")

dev.off()


# Now plot all your most abundant TE superfamilies in one plot

# after I have run TEs 
# Plot the distribution of Athila and CRM clades (known centromeric TEs in Brassicaceae).
# You need to run the TEsorter on TElib to get the clades classification from the TE library


gff_file # this is the file where we have the TEs names and they association to a clade