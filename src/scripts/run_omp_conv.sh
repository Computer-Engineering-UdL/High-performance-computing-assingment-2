#!/bin/bash
#$ -cwd
#$ -j y
#$ -V
#$ -o logs/
#$ -N conv_omp
#$ -pe smp 4
#$ -l h_rt=00:30:00

EXE="$1"
IMG="$2"
KER="$3"
PART="$4"
THREADS="$5"
SCHED="$6"
CHUNK="$7"

export OMP_NUM_THREADS="$THREADS"

OUTFILE="${TMPDIR}/${JOB_NAME}.ppm"

echo "===== OPENMP JOB ====="
echo "HOSTNAME=$(hostname)"
echo "IMG=$IMG"
echo "KER=$KER"
echo "PART=$PART"
echo "THREADS=$THREADS"
echo "SCHED=$SCHED"
echo "CHUNK=$CHUNK"
echo "OMP_NUM_THREADS=$OMP_NUM_THREADS"
echo "OUTFILE=$OUTFILE"
echo "======================"

"$EXE" "$IMG" "$KER" "$OUTFILE" "$PART"

rm -f "$OUTFILE"
