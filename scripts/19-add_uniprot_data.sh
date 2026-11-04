#!/bin/bash

#SBATCH --job-name=add_uniprot_data
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=03:00:00
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

# container for MAKER 
CONTAINER="${COURSEDIR}/containers/MAKER_3.01.03.sif"

module load BLAST+/2.15.0-gompi-2021a

# input file 
GENES="${WORKDIR}/output/filter_gff/filtered.genes.renamed.gff3"

PROTEINS_FASTA="${INPUT_DIR}/assembly.all.maker.proteins.renamed.filtered.fasta"
UNIPROT_FASTA="${COURSEDIR}/data/uniprot_viridiplantae_reviewed.fa"

# outdir 
OUTDIR="${WORKDIR}/output/comparisons/uniprot"

TEMP_DIR="${OUTDIR}/tmp"

create_dir "$TEMP_DIR"

apptainer exec --cleanenv --env TMPDIR="/tmp" \
    --bind /data --bind "$WORKDIR" --bind "${TEMP_DIR}:/tmp" \
    --pwd "$OUTDIR" "$CONTAINER" \
    maker_functional_fasta "$UNIPROT_FASTA" "$OUTDIR/blastp_uniprot.besthits.tsv" "$PROTEINS_FASTA" \
    > "$OUTDIR/maker_proteins.filtered.Uniprot.fasta"

apptainer exec --cleanenv --env TMPDIR="/tmp" \
    --bind /data --bind "$WORKDIR" --bind "${TEMP_DIR}:/tmp" \
    --pwd "$OUTDIR" "$CONTAINER" \
    maker_functional_fasta "$UNIPROT_FASTA" "$OUTDIR/blastp_uniprot.besthits.tsv" "$GENES" \
    > "$OUTDIR/maker_genes.filtered.Uniprot.gff3"