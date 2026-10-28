#!/bin/bash

#SBATCH --job-name=examine_AED
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

# input dir and gff file 
RENAME_DIR="${RESULT_DIR}/MAKER/final"
GFF_FILE_RENAMED="${RENAME_DIR}/assembly.all.maker.noseq.renamed.gff"

# output directory and file 
OUTDIR="${RESULT_DIR}/AED_values"
TEMP_DIR="${OUTDIR}/tmp"
OUTPUT_FILE="${OUTDIR}/assembly.all.maker.renamed.gff.AED.txt"

create_dir "$OUTDIR"
# create a tmp directory
create_dir "$TEMP_DIR"

apptainer exec --cleanenv --env TMPDIR="/tmp" \
    --bind "${TEMP_DIR}:/tmp" \
    --bind "$COURSEDIR" --bind "$WORKDIR" \
    "$CONTAINER" \
    perl /usr/local/bin/AED_cdf_generator.pl -b 0.025 "$GFF_FILE_RENAMED" > "$OUTPUT_FILE"