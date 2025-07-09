#!/bin/bash

set -eou pipefail

# Activate conda environment
eval "$(conda shell.bash hook)"
source "$CONDA_PREFIX/etc/profile.d/mamba.sh"
mamba activate sra

# function to process each SRA sample
process_sample() {
  sra="$1"
  echo "Processing $sra"

  # Prefetch with cache and size limit
  prefetch --max-size 100G "$sra"

  # Validate
  vdb-validate "$sra"

  # Convert to FASTQ
  fasterq-dump --split-files --include-technical --outdir reads/ "$sra"

  # Compress
  for f in reads/${sra}*.fastq; do
    gzip "$f"
  done

  echo "Finished $sra"
}

export -f process_sample

# Extract SRA IDs, skip header, and run in parallel
tail -n +26 sample_info.csv | cut -d ',' -f2 | parallel --group --joblog logs/00-download_sra.sh -j 2 process_sample
