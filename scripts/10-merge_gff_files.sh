#!/bin/bash

#SBATCH --job-name=merge_gff_files
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=01:00:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-28
#SBATCH --mail-type=start,fail,end
#SBATCH --output=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.out
#SBATCH --error=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.err

WORKDIR="/data/users/vmungai/genome_annotation_course_2026"
COURSEDIR="/data/courses/genome_annotation_resources/2026"

# import module for function on file system 
source "${WORKDIR}/scripts/utils/file_utils.sh"

CONTAINER="${COURSEDIR}/containers/MAKER_3.01.03.sif"

OUTDIR="${WORKDIR}/output/MAKER"

create_dir "$OUTDIR"
mkdir -p "$OUTDIR/tmp"

cd "$OUTDIR"

shopt -s nullglob
INDEXES=(*.maker.output/*_master_datastore_index.log)
test "${#INDEXES[@]}" -eq 1 
INDEX="${INDEXES[0]}"

apptainer exec --cleanenv --env TMPDIR=/tmp \
    --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
    --pwd "$OUTDIR" "$CONTAINER" \
    gff3_merge -d "$INDEX" -o assembly.all.maker.gff

apptainer exec --cleanenv --env TMPDIR=/tmp \
    --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
    --pwd "$OUTDIR" "$CONTAINER" \
    gff3_merge -d "$INDEX" -o assembly.all.maker.noseq.gff

apptainer exec --cleanenv --env TMPDIR=/tmp \
    --bind "$OUTDIR/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
    --pwd "$OUTDIR" "$CONTAINER" \
    fasta_merge -d "$INDEX" -o assembly
