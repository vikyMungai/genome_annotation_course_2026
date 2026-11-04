library(GENESPACE)

args <- commandArgs(trailingOnly = TRUE)

# Get the folder where the GENESPACE working directory is located
wd <- args[1]

gpar <- init_genespace(
  wd = wd,
  path2mcscanx = "/usr/local/bin",
  nCores = 20
)

# Run GENESPACE
out <- run_genespace(gpar)

pangenome <- query_pangenes(
  out,
  bed = NULL,
  refGenome = "TAIR10",
  transform = TRUE,
  showArrayMem = TRUE,
  showNSOrtho = TRUE,
  maxMem2Show = Inf
)

# Save pangenome object as RDS
saveRDS(
  pangenome,
  file = file.path(wd, "pangenome_matrix.rds")
)