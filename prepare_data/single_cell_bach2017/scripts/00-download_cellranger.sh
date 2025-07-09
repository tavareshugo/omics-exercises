#!/bin/bash

wget -O GSE106273_RAW.tar "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE106273&format=file"

tar -xvf GSE106273_RAW.tar

dirs=$(ls GSM2834* | sed 's/_.*//' | sort | uniq)

mkdir -p preprocessed/cellranger

for i in $dirs; do mkdir -p preprocessed/cellranger/$i/outs/filtered_feature_bc_matrix/; done

for i in $dirs; do mv $i* preprocessed/cellranger/$i/outs/filtered_feature_bc_matrix/; done

for i in $dirs
do
  files=$(ls preprocessed/cellranger/$i/outs/filtered_feature_bc_matrix/$i*)
  for file in $files
  do
    newfile=$(basename $file | sed 's/.*_//')
    mv "$file" "preprocessed/cellranger/$i/outs/filtered_feature_bc_matrix/$newfile"
  done
done