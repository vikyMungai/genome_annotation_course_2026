#!/bin/bash

#SBATCH --job-name=Maker_gene_annotation
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=64G
#SBATCH --time=01:00:00
#SBATCH --account=class-sbl-30004-ws-2026
#SBATCH --reservation=class-sbl-30004-2026-10-21
#SBATCH --mail-user=vittoria.mungai@students.unibe.ch
#SBATCH --mail-type=start,fail,end
#SBATCH --output=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.out
#SBATCH --error=/data/users/vmungai/genome_annotation_course_2026/logs/%x_%j.err


set -euo pipefail

COURSEDIR="/data/courses/genome_annotation_resources/2026"
WORKDIR="/data/users/vmungai/genome_annotation_course_2026"
DATA_DIR="${WORKDIR}/data/maker"
OUTDIR="${WORKDIR}/output/MAKER"
MAKER_SIF="${COURSEDIR}/containers/MAKER_3.01.03.sif"
AUGUSTUS_CONFIG_PATH="${COURSEDIR}/tools/MAKER/augustus_config"

# Before submitting, copy the four templates from:
# /data/courses/genome_annotation_resources/2026/tools/MAKER/control_files/
# into your project root, then edit maker_opts.ctl:
# genome = your genome FASTA; est = your Trinity FASTA; rmlib = your EDTA TE library.
# Protein references already point to the course directory (to annotate the genes). 
# Submit from the project root: sbatch scripts/XX-run_maker.sh
# The copy below uses YOUR EDITED project files, then runs MAKER in output/MAKER.
unset SINGULARITY_BIND APPTAINER_BIND SINGULARITY_TMPDIR

mkdir -p "${OUTDIR}/tmp"

cp "${DATA_DIR}/maker_opts.ctl" "${DATA_DIR}/maker_bopts.ctl" \
    "${DATA_DIR}/maker_exe.ctl" "${DATA_DIR}/maker_evm.ctl" "${OUTDIR}/"

cd "$OUTDIR"

# Use the container's MPICH launcher; keep cpus=1 in maker_opts.ctl.
apptainer exec --cleanenv --env AUGUSTUS_CONFIG_PATH="$AUGUSTUS_CONFIG_PATH" \
    --bind /data --bind "$WORKDIR" --bind "$OUTDIR/tmp":/TMP \
    --pwd "$OUTDIR" "$MAKER_SIF" \
    mpiexec -launcher fork -n "$SLURM_CPUS_PER_TASK" \
    maker -mpi --ignore_nfs_tmp -TMP /TMP \
    maker_opts.ctl maker_bopts.ctl maker_exe.ctl maker_evm.ctl



