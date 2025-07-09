library(DropletUtils)
library(scran)
library(scater)
library(batchelor)
library(tidyverse)

sample_info <- read_csv("sample_info.csv")

files <- file.path("preprocessed/cellranger", 
                    sample_info$sra_run, 
                    "outs", 
                    "filtered_feature_bc_matrix")
names(files) <- sample_info$sample
sce <- read10xCounts(files, col.names = TRUE, type = "sparse")

# add sample information to colData
colData(sce) <- merge(colData(sce), 
                      sample_info, 
                      by.x = "Sample", 
                      by.y = "sample", 
                      all.x = TRUE)

# remove empty cells and genes
sce <- sce[, colSums(counts(sce)) > 0]
sce <- sce[rowSums(counts(sce)) > 0, ]

# normalise counts
sce <- multiBatchNorm(sce, 
                      batch = sce$Sample, 
                      preserve.single = TRUE)

# find highly variable genes
gene_var <- modelGeneVar(sce, 
                         block = sce$Sample)
metadata(sce)[["hvgs"]] <- getTopHVGs(gene_var,
                                      prop = 0.1)

# investigate batch effects
set.seed(975)
sce <- sce |> 
  runPCA(ncomponents = 20, 
         exprs_values = "logcounts", 
         subset_row = metadata(sce)[["hvgs"]]) |> 
  runTSNE(dimred = "PCA", perplexity = 30, 
          exprs_values = "logcounts") |> 
  runUMAP(dimred = "PCA", 
          exprs_values = "logcounts")


# trying to recreate figure from paper
plotReducedDim(sce, 
               dimred = "TSNE", 
               colour_by = "Sample")

# this reveals the samples are mis-labelled!
# I think the correct is: 
# Gestation should be Nulliparous
# Nulliparous should be Lactation
# Lactation should be Gestation
# Post-involution is correct
plotReducedDim(sce, 
               dimred = "TSNE", 
               colour_by = rownames(sce)[rowData(sce)$Symbol == "Krt18"])

# this might be an interesting lesson in reproducibility
# and metadata errors and how important it is to check 
# for known markers