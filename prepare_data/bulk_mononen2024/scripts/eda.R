library(tximport)
library(DESeq2)
library(tidyverse)

sample_info <- read_csv("sample_info.csv")

files <- file.path("results/rnaseq/star_salmon/", sample_info$sample, "quant.sf")
files <- set_names(files, sample_info$sample)
tx2gene <- read_tsv("results/rnaseq/star_salmon/tx2gene.tsv")

txi <- tximport(files, type = "salmon", tx2gene = tx2gene)

library(ggfortify)

rlogcounts <- rlog(round(txi$counts))

# run PCA
pcDat <- prcomp(t(rlogcounts))
# plot PCA
autoplot(pcDat)

autoplot(pcDat,
         data = sample_info, 
         colour = "diet", 
         shape = "strain",
         size = 5)
