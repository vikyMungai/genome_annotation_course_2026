#!/bin/bash

#SBATCH --job-name=run_InterProScan
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

DATA_DIR="$COURSEDIR/data/interproscan-5.70-102.0/data"

CONTAINER="${COURSEDIR}/containers/InterProScan_5.70.sif"

# import module for function on file system 
source "${WORKDIR}/scripts/utils/file_utils.sh"

# results directory 
RESULT_DIR="${WORKDIR}/output"

# directory with the gff and fasta files with gene ID renamed 
RENAME_DIR="${RESULT_DIR}/MAKER/final"
PROTEIN_FASTA_RENAMED="${RENAME_DIR}/assembly.all.maker.proteins.renamed.fasta"

# output directory 
OUTPUT_DIR="${RESULT_DIR}/interProScan"
OUTPUT_FILE="${OUTPUT_DIR}/output.iprscan"

create_dir "$OUTPUT_DIR"

# run InterProScan on your protein FASTA file
apptainer exec --cleanenv --pwd "$RENAME_DIR" \
    --bind "${DATA_DIR}:/opt/interproscan/data" \
    --bind "$COURSEDIR" --bind "$WORKDIR" \
    --bind "${RENAME_DIR}/tmp:/temp" "$CONTAINER" \
    /opt/interproscan/interproscan.sh \
    -appl pfam --disable-precalc -f TSV \
    --goterms --iprlookup --seqtype p \
    -i ${PROTEIN_FASTA_RENAMED} -o "$OUTPUT_FILE"

