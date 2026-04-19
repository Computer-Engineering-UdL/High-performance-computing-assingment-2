#!/bin/bash
cd ~/hpc_conv || exit 1

IMGDIR=/share/apps/files/convolution/images
KERDIR=/share/apps/files/convolution/kernel

K5="$KERDIR/kernel5x5_Sharpen.txt"
K25="$KERDIR/kernel25x25_random.txt"
K49="$KERDIR/kernel49x49_random.txt"
K99="$KERDIR/kernel99x99_random.txt"

IMAGES=("im01" "im02" "im03" "im04" "im05")
KERNELS=("$K5" "$K25" "$K49" "$K99")
THREADS=(1 2 4)

for im in "${IMAGES[@]}"; do
  IMG="$IMGDIR/${im}.ppm"
  PART=1
  if [ "$im" = "im05" ]; then
    PART=3
  fi

  for KER in "${KERNELS[@]}"; do
    kbase=$(basename "$KER" .txt)

    for T in "${THREADS[@]}"; do
      HRT="01:00:00"

      if [ "$im" = "im05" ] && [ "$kbase" = "kernel49x49_random" ]; then
        HRT="03:00:00"
      fi

      if [ "$im" = "im05" ] && [ "$kbase" = "kernel99x99_random" ]; then
        HRT="06:00:00"
      fi

      qsub -N "omp_${im}_${kbase}_t${T}" -pe smp "$T" -v OMP_NUM_THREADS="$T" -l h_rt="$HRT" \
        ~/hpc_conv/scripts/run_omp_conv.sh \
        ~/hpc_conv/bin/omp_convolution \
        "$IMG" "$KER" "$PART" "$T" static 4
    done
  done
done
