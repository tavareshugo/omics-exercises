library(scRNAseq)
library(DropletUtils)
library(scater)
library(BiocParallel)
library(tidyverse)
library(patchwork)
library(ggvenn)

sce <- BachMammaryData(
  samples = c("NP_1", "NP_2", "G_1", "G_2", "L_1", "L_2", "PI_1", "PI_2"),
  location = TRUE,
  legacy = FALSE
)

sce <- sce |> 
  addPerCellQC() |>
  addPerFeatureQC()

plotColData(sce, x="Sample", y="sum") + 
    scale_y_log10() + 
    ggtitle("Total count")
    
plotColData(sce, x="Sample", y="detected") + 
    scale_y_log10() + 
    ggtitle("Detected features")

colData(sce)  |> 
    as.data.frame() |> 
    ggplot(aes(x = sum, y = detected)) +
    geom_point()
      
low_lib_size <- isOutlier(sce$sum, log=TRUE, type="lower")
table(low_lib_size)
attr(low_lib_size, "thresholds")

colData(sce)$low_lib_size <- low_lib_size
plotColData(sce, x="Sample", y="sum", colour_by = "low_lib_size") + 
    scale_y_log10() + 
    labs(y = "Total count", title = "Total count") +
    guides(colour=guide_legend(title="Discarded"))

low_n_features <- isOutlier(sce$detected, log=TRUE, type="lower")
table(low_n_features)
colData(sce)$low_n_features <- low_n_features
plotColData(sce, x="Sample", y="detected", colour_by = "low_n_features") + 
    scale_y_log10() + 
    labs(y = "Genes detected", title = "Genes detected") +
    guides(colour=guide_legend(title="Discarded"))

