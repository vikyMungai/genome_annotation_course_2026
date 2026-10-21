#!/bin/bash

#SBATCH --job-name=run_parser
#SBATCH --partition=pshort_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=01:00:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --mail-user=vittoria.mungai@students.unibe.ch
#SBATCH --mail-type=start,fail,end
#SBATCH --output=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.out
#SBATCH --error=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.err

WORKDIR="/data/users/vmungai/genome_annotation_course_2026"
COURSEDIR="/data/courses/genome_annotation_resources/2026"

PERL_SCRIPT="${WORKDIR}/scripts/perl_scripts/07-parseRM.pl"
# container to run perl script 
CONTAINER="${COURSEDIR}/containers/Annotation_analysis_R4.4.sif"
# EDTA directories 
EDTA_DIR="${WORKDIR}/output/EDTA"
EDTA_ANNO_DIR="${EDTA_DIR}/assembly.fasta.mod.EDTA.anno"
# EDTA files 
EDTA_RM_FILE="${EDTA_ANNO_DIR}/assembly.fasta.mod.EDTA.RM.out"
EDTA_RM_NONZERO_FILE="${EDTA_ANNO_DIR}/assembly.mod.EDTA.RM.nonzero.out"

awk 'NR == 1 || $2 != 0' "$EDTA_RM_FILE" > "$EDTA_RM_NONZERO_FILE"

cd "$EDTA_ANNO_DIR"

# run perl script 
apptainer exec -C --bind "$WORKDIR" --bind "$COURSEDIR" \
        "$CONTAINER" perl "$PERL_SCRIPT" -i "$EDTA_RM_NONZERO_FILE" -l 50,1 -v