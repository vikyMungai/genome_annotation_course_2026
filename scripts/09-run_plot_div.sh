#!/bin/bash

#SBATCH --job-name=plot_div
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=01:00:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --mail-type=start,fail,end
#SBATCH --output=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.out
#SBATCH --error=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.err

WORKDIR="/data/users/vmungai/genome_annotation_course_2026"
COURSEDIR="/data/courses/genome_annotation_resources/2026"

CONTAINER="${COURSEDIR}/containers/Annotation_analysis_R4.4.sif"

RSCRIPT_FILE="${WORKDIR}/scripts/R_scripts/09-plot_div.R"

OUT_DIR="${WORKDIR}/plots/TE_landscape"

mkdir -p "$OUT_DIR"

cd "$OUT_DIR"

apptainer exec -C --bind "$WORKDIR" "$CONTAINER" Rscript --vanilla "$RSCRIPT_FILE"