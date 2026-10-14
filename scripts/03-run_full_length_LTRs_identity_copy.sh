#!/bin/bash
#SBATCH --job-name=run_Rscript_LTRs_identity_copy
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

R_SCRIPT="${WORKDIR}/scripts/R_scripts/03-full_length_LTRs_identity_copy.R"

# import module for function on file system 
source "${WORKDIR}/scripts/utils/file_utils.sh"
# output directory
OUTDIR="/data/users/vmungai/genome_annotation_course_2026/plots/TEsorter_full_length_LTRs"

create_dir "$OUTDIR"

cd "$OUTDIR"
apptainer exec -C --bind "$WORKDIR" --bind "$COURSEDIR" --pwd "$OUTDIR" \
   "$COURSEDIR/containers/Annotation_analysis_R4.4.sif" \
   Rscript --vanilla "$R_SCRIPT"