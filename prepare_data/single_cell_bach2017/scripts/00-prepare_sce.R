library(scRNAseq)
set.seed(42)

sce <- BachMammaryData(
  samples = c("NP_1", "NP_2", "G_1", "G_2", "L_1", "L_2", "PI_1", "PI_2"),
  location = TRUE,
  legacy = FALSE
)
colnames(sce) <- sce$Barcode

# artificially degrade some cells to simulate low-quality data
cts <- assay(sce, "counts")
low_cells <- sample(colnames(cts), 
                    size = floor(0.05 * ncol(cts)))

cts[, low_cells] <- round(t(t(cts[, low_cells]) * rexp(length(low_cells), 10)))

low_genes <- sample(rownames(cts), 
                  size = floor(0.01 * nrow(cts)))

cts[low_genes, ] <- round(cts[low_genes, ] * rexp(length(low_genes), 10))

assay(sce, "counts") <- cts

# saveRDS(sce, file = "preprocessed/bach_mammary_gland_sce.rds")

# convert SingleCellExperiment to Seurat object
# library(Seurat)
# seurat <- as.Seurat(sce)
Seurat::as.Seurat(sce)

DropletUtils::read10xCounts("preprocessed/cellranger/GSM2834498")
