#!/bin/bash

#SBATCH --job-name=annotation_criclize
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

CONTAINER="${COURSEDIR}/containers/Annotation_analysis_R4.4.sif"

RSCRIPT_FILE="${WORKDIR}/scripts/R_scripts/06_2-annotation_circlize.R"

GFF3_FILE="${WORKDIR}/output/EDTA/assembly.fasta.mod.EDTA.TEanno.gff3"

# removing headers # to the read and process the tables 
GYPSY_TSV="${WORKDIR}/output/TEsorter/Gypsy_sequences.fa.rexdb-plant.cls.tsv"
COPIA_TSV="${WORKDIR}/output/TEsorter/Copia_sequences.fa.rexdb-plant.cls.tsv"

apptainer exec -C --bind "$WORKDIR" "$CONTAINER" Rscript "$RSCRIPT_FILE"