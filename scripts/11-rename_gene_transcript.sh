#!/bin/bash

#SBATCH --job-name=rename_gene_transcript
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=01:00:00
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

# outdir directory where the files are stored 
OUTDIR="${WORKDIR}/output/MAKER"
# directory where the renamed file will be saved 
RENAME_DIR="${OUTDIR}/final"

# prefix with accession ID 
PREFIX="Ice-1" 

# make a tmp directory 
create_dir "${RENAME_DIR}/tmp"

cd "$OUTDIR"

# files that needs to be renamed 
PROTEIN_FASTA="assembly.all.maker.proteins.fasta"
TRANSCRIPT_FASTA="assembly.all.maker.transcripts.fasta"
GFF_FILE="assembly.all.maker.noseq.gff"

PROTEIN_FASTA_RENAMED="${RENAME_DIR}/${PROTEIN_FASTA%.fasta}.renamed.fasta"
TRANSCRIPT_FASTA_RENAMED="${RENAME_DIR}/${TRANSCRIPT_FASTA%.fasta}.renamed.fasta"
GFF_FILE_RENAMED="${RENAME_DIR}/${GFF_FILE%.gff}.renamed.gff"
ID_MAP="${RENAME_DIR}/id.map"

# copy the fasta file in the final direcotry 
cp "$OUTDIR/${GFF_FILE}" "${GFF_FILE_RENAMED}"
cp "$OUTDIR/${PROTEIN_FASTA}" "${PROTEIN_FASTA_RENAMED}"
cp "$OUTDIR/${TRANSCRIPT_FASTA}" "${TRANSCRIPT_FASTA_RENAMED}"

apptainer exec --cleanenv --env TMPDIR=/tmp \
    --bind "${OUTDIR}/tmp:/tmp" --bind "$COURSEDIR" --bind "$WORKDIR" \
    --pwd "$OUTDIR" "$CONTAINER" \
    maker_map_ids --prefix "$PREFIX" --justify 7 "$GFF_FILE_RENAMED" > "$ID_MAP"

# assign consistent IDs to the gene models 
apptainer exec --cleanenv --env TMPDIR=/tmp \
    --bind "${OUTDIR}/tmp:/tmp" --bind "$COURSEDIR" --bind "$WORKDIR" \
    --pwd "$OUTDIR" "$CONTAINER" \
    map_gff_ids "$ID_MAP" "$GFF_FILE_RENAMED" 

apptainer exec --cleanenv --env TMPDIR=/tmp \
    --bind "${OUTDIR}/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
    --pwd "$OUTDIR" "$CONTAINER" \
    map_gff_ids "$ID_MAP" "$PROTEIN_FASTA_RENAMED" 

apptainer exec --cleanenv --env TMPDIR=/tmp \
    --bind "${OUTDIR}/tmp":/tmp --bind "$COURSEDIR" --bind "$WORKDIR" \
    --pwd "$OUTDIR" "$CONTAINER" \
    map_gff_ids "$ID_MAP" "$TRANSCRIPT_FASTA_RENAMED" 
