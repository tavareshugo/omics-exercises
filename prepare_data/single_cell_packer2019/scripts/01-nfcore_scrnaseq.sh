#!/bin/bash

set -eou pipefail

# Activate conda environment
eval "$(conda shell.bash hook)"
source "$CONDA_PREFIX/etc/profile.d/mamba.sh"
mamba activate nextflow

# rnaseq workflow
nextflow run nf-core/scrnaseq -resume \
  -r 4.0.0 -profile singularity \
  --input nextflow_samplesheet.csv \
  --outdir results/scrnaseq \
  --fasta $PWD/references/Caenorhabditis_elegans.WBcel235.dna_sm.toplevel.fa.gz \
  --gtf $PWD/references/Caenorhabditis_elegans.WBcel235.114.gtf.gz \
  --aligner star \
  --protocol 10XV2
