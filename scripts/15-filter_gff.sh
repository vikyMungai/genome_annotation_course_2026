#!/bin/bash

#SBATCH --job-name=filter_gff
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
CONTAINER_ANN="${COURSEDIR}/containers/Annotation_analysis_R4.4.sif"

# import module for function on file system 
source "${WORKDIR}/scripts/utils/file_utils.sh"

# results directory 
RESULT_DIR="${WORKDIR}/output"

# input dir and file 
INTER_DIR="${RESULT_DIR}/interProScan"
IPRSCAN_FILE="${INTER_DIR}/assembly.all.maker.noseq.renamed.iprscan.gff"
TRANSCRIPT_FASTA="${RESULT_DIR}/MAKER/final/assembly.all.maker.transcripts.renamed.fasta"
PROTEIN_FASTA="${RESULT_DIR}/MAKER/final/assembly.all.maker.proteins.renamed.fasta"


# output directory and file 
OUTDIR="${RESULT_DIR}/filter_gff"
TEMP_DIR="${OUTDIR}/tmp"

# output for gff 
FILE_NAME_GFF=$(basename ${IPRSCAN_FILE%.iprscan.gff})
OUT_QUALITY_FILTER="${OUTDIR}/${FILE_NAME_GFF}.iprscan_quality_filtered.gff"
OUT_GENE_FILTER="${OUTDIR}/filtered.genes.renamed.gff3"
OUTPUT_LIST="${OUTDIR}/list.txt"
# output file for transcript fasta 
FILE_NAME_TRANS=$(basename ${TRANSCRIPT_FASTA%.fasta})
OUT_TRANSC_FILE="${OUTDIR}/${FILE_NAME_TRANS}.filtered.fasta"
# output for protein fasta 
FILE_NAME_PROT=$(basename ${PROTEIN_FASTA%.fasta})
OUT_PROTEIN_FILE="${OUTDIR}/${FILE_NAME_PROT}.filtered.fasta"

create_dir "$OUTDIR"
# create temp dir 
create_dir "$TEMP_DIR"

# filter gff for quality 
apptainer exec --cleanenv --env TMPDIR="/tmp" \
    --bind "${TEMP_DIR}:/tmp" \
    --bind "$COURSEDIR" --bind "$WORKDIR" \
    "$CONTAINER" \
    perl /usr/local/bin/quality_filter.pl -s "$IPRSCAN_FILE" > "$OUT_QUALITY_FILTER"

# We only want to keep gene features and subfeatures in the third column of the gff file
grep -P "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" "$OUT_QUALITY_FILTER" > "$OUT_GENE_FILTER" 

sed -i '1i##gff-version 3' "$OUT_GENE_FILTER"

# check that the filtering was correct 
cut -f3 "$OUT_GENE_FILTER" | sort | uniq

# extract the remaining mRNA Sequences after filtering
grep -P "\tmRNA\t" "$OUT_GENE_FILTER" | awk '{print $9}' | cut -d ';' -f1 | sed 's/ID=//g' > "$OUTPUT_LIST"

# filter the transcripts for the retained models  
apptainer exec --cleanenv --bind "$COURSEDIR" --bind "$WORKDIR" \
    "$CONTAINER_ANN" seqkit grep -f "$OUTPUT_LIST" "$TRANSCRIPT_FASTA" -o "$OUT_TRANSC_FILE"

# filter the proteins for the retained models 
apptainer exec --cleanenv --bind "$COURSEDIR" --bind "$WORKDIR" \
    "$CONTAINER_ANN" seqkit grep -f "$OUTPUT_LIST" "$PROTEIN_FASTA" -o "$OUT_PROTEIN_FILE"