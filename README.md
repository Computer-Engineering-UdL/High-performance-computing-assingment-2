# High-performance-computing-assingment-2

This repository contains the material for an OpenMP convolution assignment from the High Performance Computing course at UdL MEINF.

The main program is [`src/omp_convolution.c`](src/omp_convolution.c), which reads a PPM image, loads a convolution kernel, splits the image into partitions, and applies the kernel to the RGB channels. The code also records timing information so different runs can be compared.

## Repository layout

- [`src/omp_convolution.c`](src/omp_convolution.c) — main OpenMP implementation and the `main` / `convolve2D` workflow.
- [`src/scripts/run_omp_conv.sh`](src/scripts/run_omp_conv.sh) — job wrapper that sets `OMP_NUM_THREADS` and runs the OpenMP executable.
- [`src/scripts/submit_serial_all.sh`](src/scripts/submit_serial_all.sh) — submits the serial benchmark batch.
- [`src/scripts/submit_omp_sched.sh`](src/scripts/submit_omp_sched.sh) — submits OpenMP runs for scheduling comparisons.
- [`src/scripts/submit_omp_scaling.sh`](src/scripts/submit_omp_scaling.sh) — submits OpenMP runs for thread-scaling experiments.
- [`src/total_times.txt`](src/total_times.txt) — total runtime measurements collected from the experiments.
- [`src/conv_times.txt`](src/conv_times.txt) — convolution-only timing measurements.
- [`src/sched_info.txt`](src/sched_info.txt) — recorded OpenMP scheduling policy for each run.
- [`src/thread_info.txt`](src/thread_info.txt) — currently empty.
- [`logs/`](logs/) — captured run outputs from the benchmark jobs.

## What the project does

The program performs a 2D convolution over PPM images. It supports:

- reading the input image and kernel from text files,
- partitioning large images into chunks with halo rows,
- running the convolution independently on the red, green, and blue channels,
- measuring the time spent reading, copying, convolving, and storing results.

## Requirements

- A C compiler with OpenMP support, such as `gcc` or `clang`.
- A POSIX-like environment for the provided shell scripts.
- PPM images and kernel definition files in the formats expected by the program.
- The cluster job scripts assume `qsub` and the directory layout used in the coursework environment.

## Build

This repository does not include a `Makefile`, so the executable must be compiled manually.

Typical build command:

```bash
gcc -O2 -fopenmp src/omp_convolution.c -o omp_convolution
```

If you want a separate serial binary for comparison, build it from the corresponding serial source used in your environment.

## Run

The OpenMP program expects four command-line arguments:

```text
omp_convolution <image-file> <kernel-file> <result-file> <partitions>
```

Example:

```bash
./omp_convolution input.ppm kernel.txt output.ppm 4
```

The job scripts in [`src/scripts/`](src/scripts/) automate the benchmark runs:

- `run_omp_conv.sh` passes the image, kernel, output path, partition count, thread count, and schedule label.
- `submit_omp_scaling.sh` varies the thread count to study scaling.
- `submit_omp_sched.sh` varies the OpenMP scheduling policy.
- `submit_serial_all.sh` runs the serial baseline cases.

## Results and logs

The repository includes timing summaries and scheduling notes generated from the experiments:

- [`src/total_times.txt`](src/total_times.txt)
- [`src/conv_times.txt`](src/conv_times.txt)
- [`src/sched_info.txt`](src/sched_info.txt)
- [`src/thread_info.txt`](src/thread_info.txt)

The detailed job outputs are stored under [`logs/`](logs/).

## Main implementation details

The most important functions in [`src/omp_convolution.c`](src/omp_convolution.c) are:

- `main` — orchestrates argument parsing, file I/O, timing, and chunk processing.
- `initimage` / `duplicateImageData` — allocate and prepare image structures.
- `readImage` / `savingChunk` — handle chunked I/O for partitioned execution.
- `leerKernel` — reads the kernel matrix from disk.
- `convolve2D` — performs the OpenMP-parallel convolution across the image data.
- `freeImagestructure` — releases allocated memory.

## Notes

- The code is written for partitioned execution so it can handle larger images.
- The provided scripts were designed for a job scheduler environment, but the core executable can also be run locally if you provide valid input files.
