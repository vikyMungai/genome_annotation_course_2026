#!/bin/bash

#SBATCH --job-name=run_TEsorter
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=01:00:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-21
#SBATCH --mail-user=vittoria.mungai@students.unibe.ch
#SBATCH --mail-type=start,fail,end
#SBATCH --output=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.out
#SBATCH --error=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.err

WORKDIR="/data/users/vmungai/genome_annotation_course_2026"
COURSEDIR="/data/courses/genome_annotation_resources/2026"

CONTAINER="${COURSEDIR}/containers/TEsorter_1.3.0.sif"

EDTA_DIR="${WORKDIR}/output/EDTA"
COPIA_FASTA="${EDTA_DIR}/Copia_sequences.fa"
GYPSY_FASTA="${EDTA_DIR}/Gypsy_sequences.fa"

OUT_DIR="${WORKDIR}/output/TEsorter"

cd "$OUT_DIR"

# Run TEsorter Gypsy
apptainer exec --bind "$WORKDIR" "$CONTAINER" TEsorter "$GYPSY_FASTA" -db rexdb-plant -p 4

# Run TEsorter Copia
apptainer exec --bind "$WORKDIR" "$CONTAINER" TEsorter "$COPIA_FASTA" -db rexdb-plant -p 4
