#!/bin/bash

set -eou pipefail

# Activate conda environment
eval "$(conda shell.bash hook)"
source "$CONDA_PREFIX/etc/profile.d/mamba.sh"
mamba activate sra

# Define range
start=2
end=$(wc -l < sample_info.csv)


# Read SRA IDs from sample_info.csv and process them
for i in $(seq $start $end); do
    echo "Processing line $i from sample_info.csv"

    # Fetch current SRA ID
    sra=$(cut -d "," -f 2 sample_info.csv | head -n $i | tail -n 1)

    echo "SRA ID: $sra"

    # Prefetch
    prefetch --max-size 100G "${sra}"

    # Validate
    vdb-validate "${sra}"

    # Convert to FASTQ
    fasterq-dump --outdir reads/ "${sra}"

    # Compress FASTQ files
    echo "Compressing FASTQ files for ${sra}"
    for f in reads/${sra}*.fastq; do
        gzip "$f"
    done

    echo "Finished processing ${sra}"
    echo "----------------------------------------"
done
