#!/bin/bash

#SBATCH --job-name=update_gff
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --mail-type=start,fail,end
#SBATCH --output=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.out
#SBATCH --error=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.err

# Stop on failed commands, unset variables, or failures within pipelines.
set -euo pipefail

WORKDIR="/data/users/vmungai/genome_annotation_course_2026"
COURSEDIR="/data/courses/genome_annotation_resources/2026"

CONTAINER="${COURSEDIR}/containers/MAKER_3.01.03.sif"

# import module for function on file system 
source "${WORKDIR}/scripts/utils/file_utils.sh"

# results directory 
RESULT_DIR="${WORKDIR}/output"

# input files 
RENAME_DIR="${RESULT_DIR}/MAKER/final"
GFF_FILE_RENAMED="${RENAME_DIR}/assembly.all.maker.noseq.renamed.gff"
INTER_DIR="${RESULT_DIR}/interProScan"
IPRSCAN_FILE="${INTER_DIR}/output.iprscan"

# temp directory 
TEMP_DIR="${RESULT_DIR}/tmp"

# updated gff file 
FILE_NAME=$(basename ${GFF_FILE_RENAMED%.gff})
OUTPUT_FILE="${INTER_DIR}/${FILE_NAME}.iprscan.gff"

create_dir "$TEMP_DIR"

# update the gff with the InterProScan results 
apptainer exec --cleanenv --env TMPDIR="/tmp" \
    --bind "${TEMP_DIR}:/tmp" \
    --bind "$COURSEDIR" --bind "$WORKDIR" \
    "$CONTAINER" \
    ipr_update_gff "$GFF_FILE_RENAMED" "$IPRSCAN_FILE" > "$OUTPUT_FILE"