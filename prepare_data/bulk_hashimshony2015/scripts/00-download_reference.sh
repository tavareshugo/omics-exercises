#!/bin/bash

set -eou pipefail

mkdir -p references
cd references

wget https://ftp.ensembl.org/pub/release-114/fasta/caenorhabditis_elegans/dna/Caenorhabditis_elegans.WBcel235.dna_sm.toplevel.fa.gz

wget https://ftp.ensembl.org/pub/release-114/gtf/caenorhabditis_elegans/Caenorhabditis_elegans.WBcel235.114.gtf.gz

wget https://ftp.ensembl.org/pub/release-114/gff3/caenorhabditis_elegans/Caenorhabditis_elegans.WBcel235.114.gff3.gz