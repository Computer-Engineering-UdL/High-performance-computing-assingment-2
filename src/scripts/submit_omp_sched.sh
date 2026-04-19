#!/bin/bash
cd ~/hpc_conv || exit 1

IMGDIR=/share/apps/files/convolution/images
KERDIR=/share/apps/files/convolution/kernel

K5="$KERDIR/kernel5x5_Sharpen.txt"
K25="$KERDIR/kernel25x25_random.txt"
K49="$KERDIR/kernel49x49_random.txt"
K99="$KERDIR/kernel99x99_random.txt"

declare -a CASES=(
  "$IMGDIR/im01.ppm|$K5|1|im01_k5"
  "$IMGDIR/im03.ppm|$K25|1|im03_k25"
  "$IMGDIR/im04.ppm|$K49|1|im04_k49"
  "$IMGDIR/im05.ppm|$K99|3|im05_k99"
)

for item in "${CASES[@]}"; do
  IFS='|' read -r IMG KER PART TAG <<< "$item"

  for SCHED in static dynamic guided; do
    HRT="01:00:00"

    if [ "$TAG" = "im05_k99" ]; then
      HRT="06:00:00"
    fi

    qsub -N "sch_${TAG}_${SCHED}" -pe smp 4 -v OMP_NUM_THREADS=4 -l h_rt="$HRT" \
      ~/hpc_conv/scripts/run_omp_conv.sh \
      ~/hpc_conv/bin/omp_convolution \
      "$IMG" "$KER" "$PART" 4 "$SCHED" 4
  done
done
