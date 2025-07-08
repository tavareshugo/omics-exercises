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
  --fasta $PWD/references/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa.gz \
  --gtf $PWD/references/Mus_musculus.GRCm38.102.gtf.gz \
  --aligner star_salmon \
  --extra_salmon_quant_args '--seqBias --gcBias' \
  --skip_deseq2_qc
