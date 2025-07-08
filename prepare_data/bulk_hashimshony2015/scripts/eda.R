library(tximport)
library(DESeq2)
library(tidyverse)

sample_info <- read_csv("sample_info.csv")
sample_info <- sample_info %>% 
  mutate(developmental_stage = fct_reorder(developmental_stage, timepoint))

files <- file.path("preprocessed/rnaseq/star_salmon/", sample_info$sample, "quant.sf")
files <- set_names(files, sample_info$sample)
tx2gene <- read_tsv("references/tx2gene.tsv")

txi <- tximport(files, type = "salmon", tx2gene = tx2gene)


library(ggfortify)

rlogcounts <- rlog(round(txi$counts))

# run PCA
pcDat <- prcomp(t(rlogcounts))
# plot PCA
autoplot(pcDat)

autoplot(pcDat,
         data = sample_info, 
         colour = "developmental_stage",
         size = 5)

stage_cor <- cor(rlogcounts)

library(pheatmap)
pheatmap(stage_cor, cluster_rows = FALSE, cluster_cols = FALSE)
