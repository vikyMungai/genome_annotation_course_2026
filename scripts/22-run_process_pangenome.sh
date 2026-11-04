#!/bin/bash

#SBATCH --job-name=run_process_pangenome
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=00:30:00
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
RSCRIPT="${WORKDIR}/scripts/R_scripts/22-process_pangenome.R"

# container 
ANALYSIS_SIF="${COURSEDIR}/containers/Annotation_analysis_R4.4.sif"

TMPDIR="${WORKDIR}/output/comparisons/Annotation_R_tmp"

create_dir "$TMPDIR"

apptainer exec --cleanenv \
    --bind /data --bind "$WORKDIR" \
    --bind "$TMPDIR":/temp --env TMPDIR=/temp --pwd "$WORKDIR" \
    "$ANALYSIS_SIF" Rscript "$RSCRIPT"
