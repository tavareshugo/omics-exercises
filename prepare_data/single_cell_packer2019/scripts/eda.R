library(DropletUtils)
library(scran)
library(scater)
library(batchelor)
library(tidyverse)

sce <- read10xCounts("cellranger/")

sce <- sce %>% 
  addPerCellQC() %>% 
  addPerFeatureQC()

plotColData(sce, x="Sample", y="sum") + 
  scale_y_log10() + 
  ggtitle("Total count")

setwd("~/hugo_workdir/omics-exercises/prepare_data/single_cell_packer2019/")

sample_info <- read_csv("sample_info.csv")

list.files("results/scrnaseq/star/")

matrix_files <- file.path("results/scrnaseq/star", 
                          paste0(sample_info$sra_run, "_t", sample_info$timepoint),
                          paste0(sample_info$sra_run, "_t", sample_info$timepoint, ".Solo.out/Gene/filtered"))
names(matrix_files) <- sample_info$sample

sce <- read10xCounts(matrix_files)
sce2 <- sce %>% 
  quickCorrect(batch = sce$Sample)

reducedDim(sce, "corrected") <- reducedDim(sce2$corrected, "corrected")
if(all(rownames(sce2$dec) == rownames(sce))) rowData(sce) <- cbind(rowData(sce), sce2$dec)

sce$timepoint <- sce$Sample %>% 
  str_remove("_.*$") %>% 
  as.factor()

sce <- sce %>% 
  runUMAP(dimred = "corrected")

plotUMAP(sce, colour_by = "Sample")

plotUMAP(sce, colour_by = "timepoint")

ggcells(sce, aes(UMAP.1, UMAP.2)) +
  geom_point(alpha = 0.2) +
  facet_wrap(~ Sample) +
  theme_classic()

# can probably half the number of samples for t300 and a third of t400
table(sce$timepoint)

samples_to_keep <- c(paste0("t300_", 1:6), paste0("t400_", 1:4), paste0("t500_", 1:8))
table(sce$timepoint[sce$Sample %in% samples_to_keep])

