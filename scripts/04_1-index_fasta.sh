#!/bin/bash

#SBATCH --job-name=index_fasta
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --cpus-per-task=3
#SBATCH --mem=8G
#SBATCH --time=00:30:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-21
#SBATCH --mail-user=vittoria.mungai@students.unibe.ch
#SBATCH --mail-type=start,fail,end
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err

WORKDIR="/data/users/vmungai/genome_annotation_course_2026"
COURSEDIR="/data/courses/genome_annotation_resources/2026"

CONTAINER="${COURSEDIR}/containers/Annotation_analysis_R4.4.sif"

FASTA_ASSEMBLY="${WORKDIR}/output/EDTA/assembly.fasta"
OUT_DIR="${WORKDIR}/output/EDTA/assembly.fasta.fai"



# index the .fasta file to obtain the lengths of teh scaffolds for teh ideogram data 
apptainer exec -C --bind "$WORKDIR" "$CONTAINER" samtools faidx "$FASTA_ASSEMBLY"
