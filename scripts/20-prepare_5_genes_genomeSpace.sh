#!/bin/bash

#SBATCH --job-name=prepare_5_genes_genomeSpace
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

# The 5 genes that I am working with are 
# Ice_1 (my accession)
# TAIR10 (reference)
# Etna_2
# Taz_0
# Altai_5 

# fasta files 
FA_DIR="${COURSEDIR}/data/Lian_et_al/GENESPACE/peptide"

ETNA_FA="${FA_DIR}/Etna_2.fa"
TAZ_FA="${FA_DIR}/Taz_0.fa"
ALTAI_FA="${FA_DIR}/Altai_5.fa"
TAIR10_FA="${COURSEDIR}/data/TAIR10.fa"


# bed files 
BED_DIR="${COURSEDIR}/data/Lian_et_al/GENESPACE/bed"

ETNA_BED="${BED_DIR}/Etna_2.bed"
TAZ_BED="${BED_DIR}/Taz_0.bed"
ALTAI_BED="${BED_DIR}/Altai_5.bed"
TAIR10_BED="${COURSEDIR}/data/TAIR10.bed" 

ACCESSION="Ice_1"

GENES="${WORKDIR}/output/filter_gff/filtered.genes.renamed.gff3"
# protein fasta file with longest isoforms 
LONGEST_PROTEINS="${WORKDIR}/output/busco_qc/assembly.all.maker.proteins.renamed.longest.fasta"

# output directory 
OUTDIR="$WORKDIR/output/comparisons"
GENESPACE_DIR="${OUTDIR}/gene_space"

create_dir "${GENESPACE_DIR}/bed"
create_dir "${GENESPACE_DIR}/peptide"
create_dir "${GENESPACE_DIR}/tmp"

# prepare the accession Ice-1
grep -P "\tgene\t" "$GENES" > "${GENESPACE_DIR}/temp_genes.gff3"
# Get the the first attribute in column 9 which is ID=gene_name.
awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' \
    "${GENESPACE_DIR}/temp_genes.gff3" > "${GENESPACE_DIR}/bed/${ACCESSION}.bed"

# Remove transcript suffixes and descriptions from FASTA headers.
sed '/^>/s/ .*//' "$LONGEST_PROTEINS" | sed '/^>/s/-R[A-z]*$//' \
    > "${GENESPACE_DIR}/peptide/${ACCESSION}.fa"

# copy the BED and FASTA files from the course directory
cp "$TAIR10_BED" "${GENESPACE_DIR}/bed/TAIR10.bed"
cp "$TAIR10_FA" "${GENESPACE_DIR}/peptide/TAIR10.fa"

# copy the other 3 accessions 
# Etna_2 
cp "$ETNA_BED" "${GENESPACE_DIR}/bed/Etna_2.bed"
cp "$ETNA_FA" "${GENESPACE_DIR}/peptide/Etna_2.fa"

# Taz_0 
cp "$TAZ_BED" "${GENESPACE_DIR}/bed/Taz_0.bed"
cp "$TAZ_FA" "${GENESPACE_DIR}/peptide/Taz_0.fa"

# Altai_5 
cp "$ALTAI_BED" "${GENESPACE_DIR}/bed/Altai_5.bed"
cp "$ALTAI_FA" "${GENESPACE_DIR}/peptide/Altai_5.fa"