#!/bin/bash
#SBATCH --job-name=TEsorter_intact_LTR
#SBATCH --partition=pibu_el8
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=01:00:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-14
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

# Stop on failed commands, unset variables, or failures within pipelines.
set -euo pipefail

COURSEDIR=/data/courses/genome_annotation_resources/2026
WORKDIR="/data/users/vmungai/genome_annotation_course_2026" 

# import module for function on file system 
source "${WORKDIR}/scripts/utils/file_utils.sh"

# Use the intact-element FASTA
# Edit these two input paths to match your assembly's filename.
RAW="${WORKDIR}/output/EDTA"

# Expand the wildcard outside quotes
shopt -s nullglob
FASTA=("$RAW"/*.mod.EDTA.raw/*.mod.LTR.intact.raw.fa)
GFF=("$RAW"/*.mod.EDTA.raw/*.mod.LTR.intact.raw.gff3)

# output directory  
OUTDIR="$WORKDIR/output/LTR_full_length"

# Prevent inherited container settings from changing the course environment.
unset SINGULARITY_BIND APPTAINER_BIND SINGULARITY_TMPDIR

# create output directory 
create_dir "$OUTDIR"
# create a temp dir for large files 
create_dir "$OUTDIR/tmp"

# Work with copies so ongoing EDTA files are not changed.
cp "${FASTA[0]}" "$OUTDIR/intact_LTR.fa"
cp "${GFF[0]}" "$OUTDIR/intact_LTR.gff3"

cd "$OUTDIR"
apptainer exec -C --bind "$WORKDIR" --bind "$COURSEDIR" \
    --bind "$OUTDIR/tmp":/tmp --pwd "$OUTDIR" \
    "$COURSEDIR/containers/TEsorter_1.3.0.sif" \
    TEsorter intact_LTR.fa -db rexdb-plant -p "$SLURM_CPUS_PER_TASK"
# After this job succeeds, run the R script in the output directory:
# cd "$OUTDIR"
# apptainer exec -C --bind "$WORKDIR" --bind "$COURSEDIR" --pwd "$OUTDIR" \
#   "$COURSEDIR/containers/Annotation_analysis_R4.4.sif" \
#   Rscript --vanilla "$COURSEDIR/scripts/03-full_length_LTRs_identity_copy.R"

# You can also download the data and script and run it locally in RStudio. 