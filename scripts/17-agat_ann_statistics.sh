#!/bin/bash

#SBATCH --job-name=busco_qc
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=03:00:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --mail-type=start,fail,end
#SBATCH --output=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.out
#SBATCH --error=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.err

# Stop on failed commands, unset variables, or failures within pipelines.
set -euo pipefail

WORKDIR="/data/users/vmungai/genome_annotation_course_2026"
COURSEDIR="/data/courses/genome_annotation_resources/2026"

CONTAINER="${COURSEDIR}/containers/AGAT_v1.4.1.sif"

# input dir and files 
INPUT_DIR="${WORKDIR}/output/filter_gff"
FILTERED_GENES_GFF="${INPUT_DIR}/filtered.genes.renamed.gff3"

OUTDIR="${WORKDIR}/output/agat_statistics"
OUT_FILE="${OUTDIR}/annotation.stat"

apptainer exec --cleanenv --bind "$COURSEDIR" --bind "$WORKDIR" \
    "$CONTAINER" agat_sp_statistics.pl --gff "$FILTERED_GENES_GFF" --output "$OUT_FILE"
