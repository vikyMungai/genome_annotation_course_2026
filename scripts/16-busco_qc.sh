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

# load BUSCO module 
module load BUSCO/5.4.2-foss-2021a
export PYTHONNOUSERSITE=1

# import module for function on file system 
source "${WORKDIR}/scripts/utils/file_utils.sh"

# results directory 
RESULT_DIR="${WORKDIR}/output"

# input dir and files 
INPUT_DIR="${RESULT_DIR}/filter_gff"

# filtered protein and transcript fasta files 
TRANSCRIPT_FILTERED="${INPUT_DIR}/assembly.all.maker.transcripts.renamed.filtered.fasta"
PROTEIN_FILTERED="${INPUT_DIR}/assembly.all.maker.proteins.renamed.filtered.fasta"

# output dir 
OUTPUT_DIR="${RESULT_DIR}/busco_qc"


# retain only the longest protein and transcript per gene
FILE_NAME_TRANSC=$(basename ${TRANSCRIPT_FILTERED%.filtered.fasta})
TRANSCRIPT_FILTERED_LONG="${OUTPUT_DIR}/${FILE_NAME_TRANSC}.longest.fasta"
FILE_NAME_PROT=$(basename ${PROTEIN_FILTERED%.filtered.fasta})
PROTEIN_FILTERED_LONG="${OUTPUT_DIR}/${FILE_NAME_PROT}.longest.fasta"


# TODO: do the filtering to retain only the longest (look at page 7 of the pdf)



# Run BUSCO on the LONGEST protein and transcript sequences
busco -i "${TRANSCRIPT_FILTERED_LONG}" -l brassicales_odb10 -o busco_proteins -m proteins -c 4
busco -i "${PROTEIN_FILTERED_LONG}" -l brassicales_odb10 -o busco_transcripts -m transcriptome -c 4