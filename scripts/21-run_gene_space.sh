#!/bin/bash

#SBATCH --job-name=run_gene_space
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=64G
#SBATCH --time=02:00:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-11-04
#SBATCH --mail-type=start,fail,end
#SBATCH --output=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.out
#SBATCH --error=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.err

# Stop on failed commands, unset variables, or failures within pipelines.
set -euo pipefail

WORKDIR="/data/users/vmungai/genome_annotation_course_2026"
COURSEDIR="/data/courses/genome_annotation_resources/2026"

# import module for function on file system 
source "${WORKDIR}/scripts/utils/file_utils.sh"

# container 
GENESPACE_SIF="${COURSEDIR}/containers/genespace_latest.sif"

GENESPACE_DIR="${WORKDIR}/output/comparisons/gene_space"


# Use host-backed temporary storage for R's parallel workers.
TMPDIR="${WORKDIR}/output/comparisons/GENESPACE_R_tmp"

create_dir "$TMPDIR"

cd "$WORKDIR"

apptainer exec --cleanenv \
    --bind /data --bind "$WORKDIR" \
    --bind "$TMPDIR":/temp --env TMPDIR=/temp --pwd "$WORKDIR" \
    "$GENESPACE_SIF" Rscript "${WORKDIR}/scripts/R_scripts/21-gene_space.R" "$GENESPACE_DIR"
