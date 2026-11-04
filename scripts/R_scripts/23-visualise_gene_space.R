library(GENESPACE)

wd <- "/data/users/vmungai/genome_annotation_course_2026/output/comparisons/gene_space"
focal_genome <- "Ice_1"

load(file.path(wd, "results", "gsParams.rda")) # Loads gsParam.

dir.create(
  file.path(wd, "processed_riparian"),
  showWarnings = FALSE
)

# Compare your accession with TAIR10, ordering scaffolds by synteny
plot_riparian(
  gsParam,
  genomeIDs = c("TAIR10", focal_genome),
  refGenome = "TAIR10",
  reorderBySynteny = TRUE,
  pdfFile = file.path(
    wd,
    "processed_riparian",
    "my_accession_vs_TAIR10.pdf"
  )
)
'''
# TODO: update YOUR_SCAFFOLD
# Improve scaffold order and display orientation
flips <- data.frame(
  genome = focal_genome,
  chr = "YOUR_SCAFFOLD"
)

# Compare your accession with TAIR10, correcting scaffold orientation

plot_riparian(
  gsParam,
  genomeIDs = c("TAIR10", focal_genome),
  refGenome = "TAIR10",
  reorderBySynteny = TRUE,
  syntenyWeight = 1,
  invertTheseChrs = flips,
  pdfFile = file.path(
    wd,
    "processed_riparian",
    "my_accession_vs_TAIR10_oriented.pdf"
  )
)

# Show all five genomes

plot_riparian(
  gsParam,
  refGenome = "TAIR10",
  reorderBySynteny = TRUE,
  syntenyWeight = 1,
  invertTheseChrs = flips,
  scalePlotWidth = 1.5,
  pdfFile = file.path(
    wd,
    "processed_riparian",
    "all_genomes_TAIR10.pdf"
  )
)
'''