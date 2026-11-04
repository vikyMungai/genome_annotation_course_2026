#!/bin/bash

#SBATCH --job-name=blast_comparison
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=16G
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

module load BLAST+/2.15.0-gompi-2021a

# input directory 
INPUT_DIR="${WORKDIR}/output/filter_gff"

PROTEINS_FASTA="${INPUT_DIR}/assembly.all.maker.proteins.renamed.filtered.fasta"
TRANSCRIPT_FASTA="${INPUT_DIR}/assembly.all.maker.transcripts.renamed.filtered.fasta"

UNIPROT_FASTA="${COURSEDIR}/data/uniprot_viridiplantae_reviewed.fa"
TAIR10="${COURSEDIR}/data/TAIR10_pep_20110103_representative_gene_model"

# outdir 
OUTDIR="${WORKDIR}/output/comparisons/blast"

create_dir "$OUTDIR/tmp"


# Indexing is necessary before running BLAST using the `makeblastdb` command, but the course directory already
# have indexed reference protein files using the following commands. So you do not need to run these commands
# again.
# makeblastdb -in "$UNIPROT" -dbtype prot
# makeblastdb -in "$TAIR10" -dbtype prot

#  Compare your filtered proteins with reviewed plant UniProt proteins 
blastp -query "$PROTEINS_FASTA" -db "$UNIPROT_FASTA" -num_threads 10 -outfmt 6 \
    -evalue 1e-5 -max_target_seqs 10 -out "${OUTDIR}/blastp_uniprot.tsv" &

UNIPROT_JOB=$!

# Compare your filtered proteins with reviewed plant TAIR10 representative proteins
blastp -query "$PROTEINS_FASTA" -db "$TAIR10" -num_threads 10 -outfmt 6 \
    -evalue 1e-5 -max_target_seqs 10 -out "${OUTDIR}/blastp_TAIR10.tsv" &
TAIR10_JOB=$!

# Wait for both searches and check that each succeeded.
wait "$UNIPROT_JOB"
wait "$TAIR10_JOB"

# Keep the highest-scoring hit for each query protein.
for reference in uniprot TAIR10; do
    sort -k1,1 -k12,12gr -k11,11g "$OUTDIR/blastp_${reference}.tsv" | \
    awk -F '\t' '!seen[$1]++' > "$OUTDIR/blastp_${reference}.besthits.tsv"
done