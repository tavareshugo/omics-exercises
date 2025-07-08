#!/bin/bash

set -eou pipefail

# Activate conda environment
eval "$(conda shell.bash hook)"
source "$CONDA_PREFIX/etc/profile.d/mamba.sh"
mamba activate nextflow

# rnaseq workflow
nextflow run nf-core/rnaseq -resume \
  -r 3.19.0 -profile singularity \
  --input nextflow_samplesheet.csv \
  --outdir results/rnaseq \
  --fasta $PWD/references/Caenorhabditis_elegans.WBcel235.dna_sm.toplevel.fa.gz \
  --gtf $PWD/references/Caenorhabditis_elegans.WBcel235.114.gtf.gz \
  --aligner star_salmon \
  --extra_salmon_quant_args '--seqBias --gcBias' \
  --skip_deseq2_qc
